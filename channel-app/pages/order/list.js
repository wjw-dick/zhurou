/**
 * 关联订单（我的渠道订单）
 * GET /api/order/info/page?current=&size=&channelId=<我的渠道ID>
 * 说明：channelId 用于标识订单归属渠道商（后端 buildQuery 暂未按该字段过滤，如需支持请后端补充）。
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_LABEL = {
  UNPAID: '待支付',
  PREPARING: '待备货',
  READY: '待取货',
  DELIVERING: '配送中',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
  AFTERSALE: '售后'
}

const ORDER_TYPE_LABEL = {
  NORMAL: '普通订单',
  RESERVE: '鲜肉预订',
  SET: '火锅套餐',
  GIFT: '礼盒'
}

Page({
  data: {
    statusLabel: STATUS_LABEL,
    orderTypeLabel: ORDER_TYPE_LABEL,
    list: [],
    current: 1,
    size: 10,
    total: 0,
    loading: false,
    finished: false
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.refresh()
  },

  onPullDownRefresh() {
    this.refresh().then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (this.data.finished || this.data.loading) return
    this.load()
  },

  refresh() {
    this.setData({ list: [], current: 1, finished: false, total: 0 })
    return this.load()
  },

  load() {
    if (this.data.loading) return Promise.resolve()
    this.setData({ loading: true })
    return http
      .get('/order/info/page', {
        current: this.data.current,
        size: this.data.size,
        channelId: auth.getChannelId()
      })
      .then((page) => {
        const records = (page && page.records) || []
        const list = this.data.list.concat(records)
        const total = page && page.total ? page.total : list.length
        this.setData({
          list,
          total,
          current: this.data.current + 1,
          finished: list.length >= total || records.length < this.data.size
        })
      })
      .catch(() => this.setData({ finished: true }))
      .then(() => this.setData({ loading: false }))
  }
})
