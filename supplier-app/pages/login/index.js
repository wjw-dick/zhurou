const http = require('../../utils/request')
const auth = require('../../utils/auth')

Page({
  data: {
    username: '',
    password: '',
    submitting: false
  },

  onLoad() {
    // 已登录直接进入工作台
    if (auth.isLogin()) {
      wx.switchTab({ url: '/pages/index/index' })
    }
  },

  onUsernameInput(e) {
    this.setData({ username: e.detail.value })
  },

  onPasswordInput(e) {
    this.setData({ password: e.detail.value })
  },

  /**
   * 登录：POST /api/auth/login
   * 账号密码由后台创建并绑定供应商，登录成功后缓存 token
   */
  onSubmit() {
    const username = (this.data.username || '').trim()
    const password = this.data.password || ''
    if (!username) {
      wx.showToast({ title: '请输入账号', icon: 'none' })
      return
    }
    if (!password) {
      wx.showToast({ title: '请输入密码', icon: 'none' })
      return
    }
    if (this.data.submitting) return
    this.setData({ submitting: true })

    http
      .post('/auth/login', { username, password }, { loading: true, loadingText: '登录中' })
      .then((data) => {
        auth.setToken(data.token)
        auth.setUserInfo(data.userInfo || {})
        if (!data.userInfo || !data.userInfo.supplierId) {
          // 未绑定供应商的账号可登录，但看不到供货数据，给予提示
          wx.showToast({ title: '该账号未绑定供应商', icon: 'none' })
        }
        wx.switchTab({ url: '/pages/index/index' })
      })
      .catch(() => {})
      .then(() => {
        this.setData({ submitting: false })
      })
  }
})
