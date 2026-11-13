/**
 * 供应商小程序 · 环境与全局配置
 * 切换环境只需修改 env 变量：dev=本地联调 / prod=生产
 */
const ENV = 'dev'

const ENV_CONFIG = {
  dev: {
    // 本地联调（微信开发者工具需勾选「不校验合法域名」）
    baseUrl: 'http://127.0.0.1:8090/api'
  },
  prod: {
    // 生产环境（需在微信公众平台配置 request / uploadFile 合法域名）
    baseUrl: 'https://api.zhushidaji.com/api'
  }
}

module.exports = {
  env: ENV,
  appName: '猪事大吉 · 供应商',
  baseUrl: ENV_CONFIG[ENV].baseUrl,
  /** 登录 token 缓存键 */
  tokenKey: 'zhushi_supplier_token',
  /** 登录用户信息缓存键 */
  userKey: 'zhushi_supplier_user'
}
