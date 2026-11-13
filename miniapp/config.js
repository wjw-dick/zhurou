/**
 * 全局配置（小程序端）
 *
 * 【重要：域名白名单】
 * 正式发布前，必须登录「微信公众平台 -> 开发管理 -> 开发设置 -> 服务器域名」，
 * 把下面 baseURL 的域名（必须是 https，且已备案）加入「request 合法域名」白名单，
 * 否则真机上所有请求都会被拦截。
 *
 * 【本地开发调试】
 * 微信开发者工具 -> 详情 -> 本地设置 -> 勾选
 * 「不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书」，
 * 即可直接请求 http://localhost:8090/api 这类本地地址。
 */
module.exports = {
  // 后端接口 base URL（按实际部署域名替换）
  baseURL: 'https://your-domain.com/api',

  // 站点信息占位，实际可被 GET /public/config 覆盖
  siteName: '猪事大吉',

  // web-view 容器默认首页（公众号菜单跳转用）
  defaultWebUrl: 'https://your-domain.com',

  // 本地缓存 key 统一管理，避免各页面拼字符串
  storageKeys: {
    token: 'zs_token',      // 登录令牌
    member: 'zs_member',    // 会员信息对象
    memberId: 'zs_member_id', // 会员 ID
    cart: 'zs_cart',        // 购物车
    store: 'zs_store',      // 当前选中门店
    confirmItems: 'zs_confirm_items' // 待确认下单的商品（购物车/立即购买中转）
  }
}
