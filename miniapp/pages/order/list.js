/**
 * 订单中心
 * 接口：GET /public/orders?memberId=&status=&current=&size=
 * tab：UNPAID 待支付 / PREPARING 待备货 / READY 待取货 / DELIVERING 配送中 / COMPLETED 已完成
 */
const request = require('../../utils/request.js')
const format = require('../../utils/format.js')
const auth = require('../../utils/auth.js')

Page({
  data: {
    tabs: [
      { status: 'UNPAID', label: '待支付' },
      { status: 'PREPARING', label: '待备货' },
      { status: 'READY', label: '待取货' },
      { status: 'DELIVERING', label: '配送中' },
      { status: 'COMPLETED', label: '已完成' }
    ],
    activeStatus: 'UNPAID',
    orders: [],
    current: 1,
    size: 10,
    noMore: false,
    loading: false
  },

  onLoad(options) {
    if (options.status) {
      this.setData({ activeStatus: options.status })
    }
    this.loadOrders()
  },

  onPullDownRefresh() {
    this.setData({ orders: [], current: 1, noMore: false })
    this.loadOrders().then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (this.data.noMore || this.data.loading) return
    this.setData({ current: this.data.current + 1 })
    this.loadOrders(true)
  },

  onTabTap(e) {
    const status = e.currentTarget.dataset.status
    if (status === this.data.activeStatus) return
    this.setData({ activeStatus: status, orders: [], current: 1, noMore: false })
    this.loadOrders()
  },

  loadOrders(append) {
    this.setData({ loading: true })
    const memberId = auth.getMemberId()
    return request.get('/public/orders', {
      memberId: memberId,
      status: this.data.activeStatus,
      current: this.data.current,
      size: this.data.size
    })
      .then(res => {
        const list = format.pageList(res).map(o => this.decorate(o))
        this.setData({
          orders: append ? this.data.orders.concat(list) : list,
          loading: false,
          noMore: list.length < this.data.size
        })
      })
      .catch(() => {
        this.setData({ loading: false, noMore: true })
      })
  },

  decorate(o) {
    return Object.assign({}, o, {
      statusText: format.orderStatus(o.status),
      statusClass: format.orderStatusClass(o.status),
      amountText: format.money(o.payAmount != null ? o.payAmount : o.totalAmount),
      createdText: format.dateTime(o.createTime || o.createdAt),
      itemCount: (o.items && o.items.length) || o.itemCount || 0,
      firstItem: (o.items && o.items[0]) || null
    })
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/order/detail?orderNo=' + e.currentTarget.dataset.no })
  },

  goIndex() {
    wx.switchTab({ url: '/pages/index/index' })
  },

  /** 待支付 -> 演示：提示去支付（真实项目对接微信支付） */
  payOrder(e) {
    const orderNo = e.currentTarget.dataset.no
    wx.showModal({
      title: '支付',
      content: '订单 ' + orderNo + ' 需要支付，请在收银台完成支付',
      showCancel: false
    })
  }
})
