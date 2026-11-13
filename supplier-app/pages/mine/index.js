/**
 * 我的
 * 账号信息来自登录返回的 userInfo（POST /api/auth/login）
 * 退出登录：POST /api/auth/logout 并清理本地登录态
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

Page({
  data: {
    user: {},
    supplierId: ''
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.setData({
      user: auth.getUserInfo() || {},
      supplierId: auth.getSupplierId()
    })
  },

  goQualification() {
    wx.navigateTo({ url: '/pages/qualification/list' })
  },

  onLogout() {
    wx.showModal({
      title: '退出登录',
      content: '确认退出当前账号？',
      confirmColor: '#c8161d',
      success: (res) => {
        if (!res.confirm) return
        // 通知后端注销 token，失败也照常清理本地
        http
          .post('/auth/logout', {}, { showError: false })
          .catch(() => {})
          .then(() => {
            auth.clearAuth()
            wx.reLaunch({ url: '/pages/login/index' })
          })
      }
    })
  }
})
