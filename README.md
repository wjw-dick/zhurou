# 猪事大吉 · 多端数字化平台

社区鲜肉 / 火锅食材 / 肉制品 一体化平台。包含 **统一后台管理**、**微信小程序商城**、**PC 品牌官网**、**H5 分享页**、**供应商端小程序**、**渠道商端小程序**，以及一套 **超管可全量维护（增删改查）** 的后端服务。

> 名称取自「诸事大吉」的谐音。门店形态：社区店 + 线上小程序商城（鲜肉预订 / 火锅套餐 / 肉制品礼盒），支持多门店连锁扩展。

---

## 一、技术栈

| 层 | 技术 |
|---|---|
| 后端 | Java 17 · Spring Boot 3.2.5 · MyBatis-Plus 3.5.5 · MySQL 8 · Redis · RabbitMQ(可选) · JWT |
| 后台管理 | Vue 3 · Vite 5 · TypeScript · Element Plus · Pinia · WangEditor 5 · ECharts |
| PC 官网 / H5 | Vue 3 · Vite 5 · TypeScript（自定义品牌样式，无 UI 框架） |
| 小程序 | 微信原生小程序（WXML / WXSS / JS） |
| 对象存储 | 本地 / MinIO / AWS S3 / 阿里云 OSS / 腾讯云 COS（5 驱动，后台卡片式切换） |
| 部署 | Docker Compose + Nginx |

---

## 二、目录结构

```
zhushidaji.com/
├─ db/
│  ├─ schema.sql              建表脚本（60 张表，utf8mb4）
│  └─ data.sql                初始化数据（超管/角色/**全量菜单+按钮权限**/字典/参数/示例商品）
├─ docs/
│  └─ API-public.md           对外公开接口契约（小程序/官网/H5 共用）
├─ backend/                   Maven 多模块后端
│  ├─ zhushi-common           通用：统一响应 R / 分页 / BaseEntity / 异常 / MyBatis-Plus / Redis / JWT / **通用 CRUD 基类**
│  ├─ zhushi-system           系统：RBAC / **菜单可视化维护** / 参数 / 字典 / 多语言 / 审计日志 / 登录
│  ├─ zhushi-store            门店
│  ├─ zhushi-product          商品：分类 / 商品 / SKU / 门店可售 / 检疫资质
│  ├─ zhushi-reserve          鲜肉预订：备货量（Redis 锁防超卖）/ 分割加工费 / 损耗率
│  ├─ zhushi-order            订单：下单 / 备货 / 发货 / 售后 / 状态日志
│  ├─ zhushi-member           会员：UnionID / 储值 / 积分 / 优惠券
│  ├─ zhushi-supplier         供应商：档案 / 协议 / 资质 / 采购 / 供货 / 送货 / 对账结算 / 库存预警
│  ├─ zhushi-channel          渠道商：档案 / 佣金规则 / 报单审核 / 结算 / 渠道专属价
│  ├─ zhushi-staff            店员 / 分割师傅：待办 / 分割登记 / 称重开单 / 业绩提成
│  ├─ zhushi-pay              支付：支付单 / 退款单
│  ├─ zhushi-wechat           微信：公众号菜单发布 / 模板消息 / 发送日志
│  ├─ zhushi-oss              对象存储：抽象接口 + 5 驱动 + 密钥加密
│  ├─ zhushi-portal           对外公开 API（/public/**，免登录）
│  ├─ zhushi-admin            启动模块（聚合，端口 8090，上下文 /api）
│  ├─ start.cmd / stop.cmd    Windows 一键启动 / 停止
│  └─ Dockerfile
├─ admin-web/                 统一后台管理（Vue3 + Element Plus）
├─ pc-web/                    PC 品牌官网
├─ h5-web/                    H5 分享页
├─ miniapp/                   微信小程序（主商城）
├─ supplier-app/              供应商小程序
├─ channel-app/               渠道商小程序
├─ docker-compose.yml
└─ README.md
```

---

## 三、环境要求

- JDK 17+、Maven 3.9+
- Node.js 18+（本项目使用 npm，**Windows 下若 PowerShell 禁止脚本，请用 `npm.cmd`**）
- MySQL 8.0、Redis 6+
- RabbitMQ（可选，当前无监听器，未启动不影响运行）
- 微信开发者工具（调试小程序）

---

## 四、初始化数据库

数据库：`zhushu`（utf8mb4）。**首次部署**按顺序执行：

```bash
mysql -h127.0.0.1 -uzhushu -p --default-character-set=utf8mb4 zhushu < db/schema.sql
mysql -h127.0.0.1 -uzhushu -p --default-character-set=utf8mb4 zhushu < db/data.sql
```

`data.sql` 会自动建立：

- 超级管理员 **admin / admin123**（`is_super = 1`，拥有**全部功能维护权限**）
- 演示账号（密码同为 `admin123`）：`store01`(店长)、`finance01`(财务)、`clerk01`(店员)、`cutter01`(分割师傅)、`service01`(客服)、`supplier01`(供应商)、`channel01`(渠道商)
- **五套平台菜单**：后台管理(ADMIN)、PC 官网导航、公众号菜单、小程序 tabBar、H5 底栏
- **按钮级权限**（如 `sys:user:add`、`product:info:audit`）便于给其他角色授权
- 字典（品类/订单状态/分割方式/资质类型…）、系统参数（站点/微信/支付/配送/佣金/预订/短信/对象存储）、示例门店与商品

> 生产环境请登录后台立即修改 admin 密码，并在「系统参数」中填写真实微信 / 支付 / 短信配置。

---

## 五、启动后端

```bash
cd backend
mvn clean package -DskipTests
java -jar zhushi-admin/target/zhushi-admin.jar
```

### Windows 一键启动

双击项目根目录的 **`一键启动.cmd`**（或命令行 `start-all.cmd`）即可自动完成：清理本项目旧进程 → 构建后端 → 启动后端 → 等待健康检查 → 启动后台管理前端 → 打开浏览器。

```cmd
一键启动.cmd              :: 后端 + 后台管理（默认）
一键启动.cmd all          :: 再额外启动 PC 官网(5174) 与 H5(5175)
一键启动.cmd rebuild      :: 强制重新构建后端
一键启动.cmd all rebuild
一键停止.cmd              :: 停止本项目全部进程

:: 纯 ASCII 别名，便于命令行输入
start-all.cmd  [all] [rebuild]
stop-all.cmd
```

> 脚本通过命令行特征只匹配本项目（`zhushi-admin.jar` / `zhushidaji.com`）的进程，**不会影响同机其他项目**（如 710auto）。
> 各服务分别在独立窗口运行，关闭对应窗口即停止该服务；入口 `.cmd` 为纯 ASCII，逻辑在 `scripts\*.ps1`（UTF-8 BOM），避免中文批处理的编码问题。

启动后：

- 服务地址：`http://127.0.0.1:8090/api`
- 接口文档：`http://127.0.0.1:8090/api/swagger-ui.html`
- 健康探测：`GET http://127.0.0.1:8090/api/public/config`

### 端口说明

默认端口 **8090**（避免与本机其他项目常用的 8080 冲突）。如需修改，请同时改两处：

1. `backend/zhushi-admin/src/main/resources/application.yml` 的 `server.port`
2. 各前端 `vite.config.ts` 的 `server.proxy['/api'].target`
3. 小程序 `config.js` 的 `baseUrl`

### 关键配置（application.yml）

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/zhushu?...
    username: zhushu
    password: P2hWaDN5K46BWaBE
  data:
    redis:
      host: 127.0.0.1
      port: 6379
```

站点 / 微信 / 支付 / 配送费 / 佣金 / 分割加工费 / 对象存储等**业务参数全部走后台「系统参数」**可视化配置，无需改代码。加密类参数（AppSecret / AK / SK / 支付密钥）以 AES 加密入库，界面掩码显示。

---

## 六、启动前端

### 1. 统一后台管理（admin-web）

```bash
cd admin-web
npm install
npm run dev        # http://localhost:5173
```

生产构建：`npm run build`（产物 `dist/`）。登录账号 `admin / admin123`。

### 2. PC 品牌官网（pc-web）

```bash
cd pc-web && npm install && npm run dev   # http://localhost:5174
```

### 3. H5 分享页（h5-web）

```bash
cd h5-web && npm install && npm run dev   # http://localhost:5175
```

### 4. 小程序

用**微信开发者工具**分别导入以下目录，填入自己的 AppID：

| 目录 | 用途 |
|---|---|
| `miniapp` | 主商城（首页/分类/鲜肉预订/购物车/我的） |
| `supplier-app` | 供应商端（供货单/送货/对账/资质上传） |
| `channel-app` | 渠道商端（报单/佣金/订单/结算/下级） |

开发阶段在开发者工具中勾选「不校验合法域名」；上线前在微信公众平台配置 request 合法域名并修改各 `config.js` 的 `baseUrl`。

---

## 七、功能地图

### 后台管理（超管可全量维护）

| 模块 | 能力 |
|---|---|
| 系统管理 | 用户 / 角色（含权限分配树）/ **菜单维护（五套平台 · 左树 + 右属性 + 实时预览 + 拖拽排序 + 图标）** / 系统参数（分组表单）/ 数据字典 / 多语言 / 审计日志（只读）/ 对象存储（5 卡片切换 + 连接测试） |
| 门店 | 门店 CRUD、经纬度、营业时间、配送范围与费用 |
| 商品 | 分类（树）/ 商品（含 SKU、富文本详情、**检疫资质**、审核、上下架）/ 检疫资质 |
| 鲜肉预订 | 预订单、备货量（含备货汇总）、预订配置（分割加工费 / 损耗率） |
| 订单 | 订单（备货 / 发货 / 完成 / 取消）、售后 |
| 会员营销 | 会员（充值 / 积分调整）、会员等级、优惠券、储值流水、积分流水 |
| 供应商 | 档案 / 供货协议 / 资质审核 / 采购计划 / 供货单（入库）/ 送货单 / 对账结算 / 库存预警 / 出入库 |
| 渠道商 | 档案 / 佣金规则 / 报单审核（自动计佣）/ 结算 / 渠道专属价 |
| 店员 | 档案 / 备货待办（派单 / 完成）/ 分割登记 / 称重开单 / 业绩提成 |
| 官网 CMS | 栏目 / 文章（富文本，支持发布/置顶）/ Banner / 留言处理 |
| 微信 | 公众号菜单（可视化编辑 + 发布快照）/ 模板消息 / 发送日志 |
| 数据看板 | 销售概览、订单状态分布、近 7 日趋势 |

**权限模型**：后端 `BaseController` 统一约定 `{base}/page|list|{id}` 与 `POST/PUT/DELETE`，配合按钮级 `perm`（如 `product:info:add`）。`sys_user.is_super = 1` 的用户（超管）**在 `PermChecker` 中一律放行**，因此对任何模块都有增删改查能力；其他角色按「角色-菜单」分配。

**审计**：所有写操作（POST/PUT/DELETE）自动落 `sys_audit_log`；审计日志与流水类数据（储值/积分/发送日志）为只读，超管亦不可修改。

### 对外接口

见 `docs/API-public.md`：站点配置、导航菜单、Banner、分类、商品（含资质）、门店、鲜肉预订（备货查询/扣减）、官网文章、留言、优惠券、会员登录、下单与订单查询。全部位于 `/api/public/**`，免登录。

---

## 八、Docker 部署

```bash
docker compose up -d --build
```

默认仅启动 `backend` 与 `admin-web`（Nginx 托管），复用现有 MySQL / Redis。
如需一并启动 MySQL / Redis（可选）：

```bash
docker compose --profile infra up -d --build
```

访问：后台 `http://localhost:8088`，后端 `http://localhost:8090/api`。

---

## 九、常见问题

1. **端口被占用**：本项目默认 8090。若改端口，记得同步前端 `vite.config.ts` 与小程序 `config.js`。
2. **`mvn -pl zhushi-admin package` 报找不到兄弟模块**：请用 `mvn package`（根目录）或 `mvn -pl zhushi-admin -am package`。
3. **Windows PowerShell 禁止运行 npm/pnpm 脚本**：改用 `npm.cmd install`、`pnpm.cmd install`。
4. **控制台中文显示为乱码**：PowerShell 默认代码页非 UTF-8；数据库与接口均为 utf8mb4 + UTF-8，浏览器/小程序端显示正常。可在 PowerShell 执行 `chcp 65001` 改善。
5. **RabbitMQ 未启动**：不影响运行（当前无消息监听器）；启用异步消息时再启动即可。
6. **小程序 tabBar 无图标**：按需在 `assets/tabbar/` 放入 png 并补 `iconPath`，当前刻意只配文字以免缺图编译报错。
7. **微信登录**：小程序 `/public/login` 当前接收已解密的 `openid`，正式上线需改为「前端传 code → 后端调微信接口换 openid」，位置已在代码注释中标出。
