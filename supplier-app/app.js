const config = require('./config')

App({
  globalData: {
    /** 登录用户信息（含 supplierId，来自 POST /auth/login 返回的 userInfo） */
    userInfo: null
  },

  onLaunch() {
    // 启动时同步缓存中的登录态
    this.globalData.userInfo = wx.getStorageSync(config.userKey) || null
  }
})
