# 猪事大吉 · 对外公开接口（C 端）

> base URL：`http://<host>:8090/api`
> 统一响应：`{ "code": 200, "msg": "操作成功", "data": ... }`（`code != 200` 表示失败，`msg` 为提示）
> 以下接口均在鉴权白名单内，**无需登录**。
> 后台管理接口使用 JWT：请求头 `Authorization: Bearer <token>`。

## 一、站点与导航

| 方法 | 路径 | 说明 | 参数 |
|---|---|---|---|
| GET | `/public/config` | 站点配置（站名/logo/ICP/客服电话等） | - |
| GET | `/public/menus/{platform}` | 导航菜单 | platform = `PC` / `WECHAT` / `MINIAPP` / `H5` |
| GET | `/public/banners` | Banner 列表 | `position` = `PC_HOME` / `MINIAPP_HOME` / `H5` 等 |
| GET | `/public/i18n/{langCode}` | 多语言词条包 | langCode = `zh-CN` / `en-US` |

## 二、商品

| 方法 | 路径 | 说明 | 参数 |
|---|---|---|---|
| GET | `/public/categories` | 商品分类（平铺） | `bizType` = `PORK`/`HOTPOT`/`PROCESSED`/`BASE`/`SET` |
| GET | `/public/categories/tree` | 商品分类树 | `bizType` |
| GET | `/public/products` | 商品分页 | `categoryId` `bizType` `keyword` `reservable` `current` `size` |
| GET | `/public/products/{id}` | 商品详情 | 返回 `{ product, skus, qualifications }` |
| GET | `/public/products/{id}/skus` | 商品规格 | - |

## 三、门店与鲜肉预订

| 方法 | 路径 | 说明 | 参数 |
|---|---|---|---|
| GET | `/public/stores` | 门店列表 | - |
| GET | `/public/stores/{id}` | 门店详情 | - |
| GET | `/public/reserve/config` | 预订配置（可预订天数/截止时间/分割加工费） | `storeId` |
| GET | `/public/reserve/stocks` | 备货量查询 | `storeId` `reserveDate`(yyyy-MM-dd) |
| POST | `/public/reserve/booking` | 预订扣减（Redis 锁防超卖） | body: `{ storeId, productId, skuId, reserveDate, quantity }` |

## 四、官网 CMS

| 方法 | 路径 | 说明 | 参数 |
|---|---|---|---|
| GET | `/public/articles` | 文章分页 | `categoryId` `articleType`(=NEWS/BRAND/CASE/PAGE) `current` `size` |
| GET | `/public/articles/{id}` | 文章详情（自动 +1 浏览量） | - |
| GET | `/public/cms/categories` | CMS 栏目 | - |
| POST | `/public/message` | 提交留言 / 团购咨询 | body: `{ msgType( CONTACT / GROUP ), name, phone, company, content, city }` |

## 五、会员与订单

| 方法 | 路径 | 说明 | 参数 |
|---|---|---|---|
| GET | `/public/coupons` | 可用优惠券 | - |
| POST | `/public/login` | 微信登录（openid 不存在则自动注册会员） | body: `{ openid, unionid, nickname, avatar, phone }` → 返回 `Member` |
| GET | `/public/member/{id}` | 会员信息（余额/积分/等级） | - |
| GET | `/public/orders` | 会员订单分页 | `memberId` `status` `current` `size` |
| GET | `/public/orders/{orderNo}` | 订单详情 | 返回 `{ order, items }` |
| POST | `/public/orders` | 下单 | 见下方 |

### 下单请求体

```json
{
  "memberId": 1,
  "storeId": 1,
  "orderType": "NORMAL",
  "source": "MINIAPP",
  "deliveryType": "SELF_PICKUP",
  "appointDate": "2026-10-17",
  "receiverName": "张伟",
  "receiverPhone": "13900000001",
  "receiverAddress": "西城区某某小区",
  "items": [
    {
      "productId": 1,
      "skuId": 1,
      "productName": "精品五花肉",
      "skuName": "五花肉 500g",
      "price": 32.8,
      "quantity": 2,
      "weight": 0.5,
      "splitType": "CUBE",
      "splitFee": 2.0
    }
  ]
}
```

- `orderType`：`NORMAL` 普通 / `RESERVE` 鲜肉预订 / `SET` 火锅套餐 / `GIFT` 礼盒
- `deliveryType`：`SELF_PICKUP` 到店自提 / `DELIVERY` 门店配送（满额免配送费按门店配置）
- `splitType`：`CUBE` 切块 / `MINCED` 绞肉 / `SLICED` 切片 / `NONE` 不分割

## 六、枚举字典（后台「数据字典」可维护）

- 商品品类 `bizType`：`PORK` 鲜猪肉 / `HOTPOT` 火锅食材 / `PROCESSED` 肉制品 / `BASE` 底料蘸料 / `SET` 套餐礼盒
- 订单状态 `status`：`UNPAID` 待支付 / `PREPARING` 待备货 / `READY` 待取货 / `DELIVERING` 配送中 / `COMPLETED` 已完成 / `CANCELLED` 已取消 / `AFTERSALE` 售后
- 资质类型 `qualType`：`QUARANTINE` 动物产品检疫合格证明 / `QUALITY` 肉品品质检验合格证 / `SC` 食品生产许可 / `INSPECTION` 检测报告 / `BUSINESS` 营业执照

## 七、后台管理接口约定（JWT）

所有资源遵循统一 CRUD（`BaseController`）：

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `{base}/page` | 分页（`current` `size` `keyword` + 业务筛选参数） |
| GET | `{base}/list` | 不分页列表 |
| GET | `{base}/{id}` | 详情 |
| POST | `{base}` | 新增 |
| PUT | `{base}` | 修改 |
| DELETE | `{base}/{id}` | 删除 |
| DELETE | `{base}/batch` | 批量删除（body 为 id 数组） |

超管（`sys_user.is_super = 1`）对全部 `{base}` 拥有增删改查权限；其他角色按「角色-菜单」分配按钮级权限。
审计日志（`/system/audit`）与流水类（储值/积分/发送日志）为只读，超管亦不可修改。
