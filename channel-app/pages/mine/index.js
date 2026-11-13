/**
 * 我的
 * 渠道信息：GET /api/channel/info/{channelId}
 * 退出登录：POST /api/auth/logout 并清理本地登录态
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const CHANNEL_TYPE_LABEL = {
  GROUP: '团购',
  DISTRIBUTOR: '分销',
  FRANCHISE: '加盟'
}

Page({
  data: {
    user: {},
    channelId: '',
    channel: {},
    channelTypeText: ''
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.setData({
      user: auth.getUserInfo() || {},
      channelId: auth.getChannelId()
    })
    this.loadChannel()
  },

  loadChannel() {
    if (!this.data.channelId) return
    http
      .get('/channel/info/' + this.data.channelId, {}, { showError: false })
      .then((channel) => {
        this.setData({
          channel: channel || {},
          channelTypeText: channel ? CHANNEL_TYPE_LABEL[channel.channelType] || channel.channelType : ''
        })
      })
      .catch(() => this.setData({ channel: {} }))
  },

  goSub() {
    wx.navigateTo({ url: '/pages/sub/list' })
  },

  goRule() {
    wx.navigateTo({ url: '/pages/commission/rule' })
  },

  onLogout() {
    wx.showModal({
      title: '退出登录',
      content: '确认退出当前账号？',
      confirmColor: '#c8161d',
      success: (res) => {
        if (!res.confirm) return
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
