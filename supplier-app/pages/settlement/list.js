/**
 * 对账结算
 * GET /api/supplier/settlement/page?current=&size=&status=&supplierId=
 * 字段：amount 应付金额 / paidAmount 已付金额 / status PENDING待对账 CONFIRMED已对账 PAID已付款
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_OPTIONS = [
  { label: '全部', value: '' },
  { label: '待对账', value: 'PENDING' },
  { label: '已对账', value: 'CONFIRMED' },
  { label: '已付款', value: 'PAID' }
]

const STATUS_LABEL = {
  PENDING: '待对账',
  CONFIRMED: '已对账',
  PAID: '已付款'
}

Page({
  data: {
    statusOptions: STATUS_OPTIONS,
    statusLabel: STATUS_LABEL,
    activeStatus: '',
    list: [],
    current: 1,
    size: 10,
    total: 0,
    loading: false,
    finished: false,
    // 汇总
    amountSum: '0.00',
    paidSum: '0.00'
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
    this.setData({ list: [], current: 1, finished: false, total: 0, amountSum: '0.00', paidSum: '0.00' })
    return this.load()
  },

  onStatusTap(e) {
    const value = e.currentTarget.dataset.value
    if (value === this.data.activeStatus) return
    this.setData({ activeStatus: value })
    this.refresh()
  },

  load() {
    if (this.data.loading) return Promise.resolve()
    this.setData({ loading: true })
    const params = {
      current: this.data.current,
      size: this.data.size,
      supplierId: auth.getSupplierId()
    }
    if (this.data.activeStatus) params.status = this.data.activeStatus

    return http
      .get('/supplier/settlement/page', params)
      .then((page) => {
        const records = (page && page.records) || []
        const list = this.data.list.concat(records)
        const total = page && page.total ? page.total : list.length
        let amount = 0
        let paid = 0
        list.forEach((item) => {
          amount += Number(item.amount || 0)
          paid += Number(item.paidAmount || 0)
        })
        this.setData({
          list,
          total,
          amountSum: amount.toFixed(2),
          paidSum: paid.toFixed(2),
          current: this.data.current + 1,
          finished: list.length >= total || records.length < this.data.size
        })
      })
      .catch(() => this.setData({ finished: true }))
      .then(() => this.setData({ loading: false }))
  }
})
