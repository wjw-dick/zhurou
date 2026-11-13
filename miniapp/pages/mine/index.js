/**
 * 我的（会员中心）
 * 接口：
 *   GET /public/member/{id}   会员信息（余额/积分/等级）
 *   GET /public/coupons       可用优惠券
 *   GET /public/config        站点配置（客服电话）
 */
const request = require('../../utils/request.js')
const format = require('../../utils/format.js')
const auth = require('../../utils/auth.js')

Page({
  data: {
    member: null,
    coupons: [],
    siteConfig: null,
    memberId: null
  },

  onShow() {
    auth.ensureLogin().then(member => {
      this.setData({ memberId: member && member.id ? member.id : auth.getMemberId() })
      this.loadMember()
    }).catch(() => {
      this.loadMember()
    })
    this.loadCoupons()
    const app = getApp()
    this.setData({ siteConfig: app.globalData.siteConfig })
  },

  onPullDownRefresh() {
    Promise.all([this.loadMember(), this.loadCoupons()])
      .then(() => wx.stopPullDownRefresh())
  },

  /** 会员信息 */
  loadMember() {
    const id = auth.getMemberId()
    if (!id) {
      this.setData({ member: auth.getMember() })
      return Promise.resolve()
    }
    return auth.refreshMember()
      .then(member => this.setData({ member: member }))
      .catch(() => this.setData({ member: auth.getMember() }))
  },

  /** 可用优惠券 */
  loadCoupons() {
    return request.get('/public/coupons')
      .then(res => {
        const list = Array.isArray(res) ? res : format.pageList(res)
        this.setData({ coupons: list.slice(0, 3) })
      })
      .catch(() => {})
  },

  /** 重新登录 */
  relogin() {
    wx.showLoading({ title: '登录中' })
    auth.login().then(member => {
      wx.hideLoading()
      this.setData({ member: member, memberId: member.id })
      wx.showToast({ title: '登录成功', icon: 'success' })
    }).catch(() => {
      wx.hideLoading()
      wx.showToast({ title: '登录失败', icon: 'none' })
    })
  },

  goOrders(e) {
    const status = e.currentTarget.dataset.status || 'UNPAID'
    wx.navigateTo({ url: '/pages/order/list?status=' + status })
  },

  goCoupons() {
    if (!this.data.coupons.length) {
      wx.showToast({ title: '暂无可用优惠券', icon: 'none' })
      return
    }
    wx.showModal({
      title: '我的优惠券',
      content: this.data.coupons.map(c => (c.couponName || c.name || '优惠券') + (c.amount ? ' ¥' + c.amount : '')).join('\n'),
      showCancel: false
    })
  },

  goCombo() {
    wx.navigateTo({ url: '/pages/combo/index' })
  },

  goReserve() {
    wx.switchTab({ url: '/pages/reserve/index' })
  },

  /** 联系客服 */
  contact() {
    const cfg = this.data.siteConfig || {}
    const phone = cfg.servicePhone || cfg.phone || ''
    if (phone) {
      wx.makePhoneCall({ phoneNumber: String(phone), fail() {} })
      return
    }
    wx.showToast({ title: '客服电话未配置', icon: 'none' })
  },

  /** 关于我们 / 帮助（网页容器） */
  goWeb(e) {
    const url = e.currentTarget.dataset.url
    if (!url) {
      wx.showToast({ title: '链接未配置', icon: 'none' })
      return
    }
    wx.navigateTo({ url: '/pages/webview/index?url=' + encodeURIComponent(url) })
  }
})
