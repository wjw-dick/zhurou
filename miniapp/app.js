/**
 * 小程序入口
 * 职责：初始化全局数据、静默登录（换取会员）、拉取站点配置。
 */
const config = require('./config.js')
const auth = require('./utils/auth.js')
const request = require('./utils/request.js')

App({
  // 全局数据，各页面通过 getApp().globalData 读取
  globalData: {
    member: null,     // 会员信息（余额/积分/等级）
    store: null,      // 当前选中门店
    siteConfig: null, // 站点配置
    systemInfo: null  // 微信窗口信息
  },

  onLaunch() {
    // 1) 读取本地缓存的会员与门店
    this.globalData.member = auth.getMember()
    this.globalData.store = wx.getStorageSync(config.storageKeys.store) || null

    // 2) 获取窗口信息（安全区等）
    try {
      this.globalData.systemInfo = wx.getWindowInfo
        ? wx.getWindowInfo()
        : wx.getSystemInfoSync()
    } catch (e) {
      this.globalData.systemInfo = null
    }

    // 3) 静默登录：wx.login -> 后端 /public/login -> 会员信息
    auth.login().then(member => {
      this.globalData.member = member
    }).catch(() => {
      // 登录失败不阻塞使用，可在「我的」页手动重试
    })

    // 4) 拉取站点配置（站名/logo/客服电话等）
    request.get('/public/config').then(cfg => {
      this.globalData.siteConfig = cfg || null
      if (cfg && cfg.siteName) {
        this.globalData.siteName = cfg.siteName
      }
    }).catch(() => {})
  }
})
