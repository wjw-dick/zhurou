/**
 * 供货单列表
 * GET /api/supplier/purchase/page?current=&size=&status=&supplierId=
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_OPTIONS = [
  { label: '全部', value: '' },
  { label: '待发货', value: 'CREATED' },
  { label: '配送中', value: 'DELIVERING' },
  { label: '已入库', value: 'RECEIVED' },
  { label: '对账中', value: 'CHECKING' },
  { label: '已结算', value: 'SETTLED' }
]

const STATUS_LABEL = {
  CREATED: '待发货',
  DELIVERING: '配送中',
  RECEIVED: '已入库',
  CHECKING: '对账中',
  SETTLED: '已结算'
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
    this.load(false)
  },

  refresh() {
    this.setData({ list: [], current: 1, finished: false, total: 0 })
    return this.load(true)
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
      .get('/supplier/purchase/page', params)
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
      .catch(() => {
        this.setData({ finished: true })
      })
      .then(() => this.setData({ loading: false }))
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/purchase/detail?id=' + e.currentTarget.dataset.id })
  }
})
