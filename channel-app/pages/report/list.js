/**
 * 报单列表
 * GET /api/channel/order/page?current=&size=&status=&channelId=
 * status：SUBMITTED 待审核 / APPROVED 已通过 / REJECTED 已驳回 / SETTLED 已结算
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_OPTIONS = [
  { label: '全部', value: '' },
  { label: '待审核', value: 'SUBMITTED' },
  { label: '已通过', value: 'APPROVED' },
  { label: '已驳回', value: 'REJECTED' },
  { label: '已结算', value: 'SETTLED' }
]

const STATUS_LABEL = {
  SUBMITTED: '待审核',
  APPROVED: '已通过',
  REJECTED: '已驳回',
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
    finished: false,
    amountSum: '0.00'
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
    this.setData({ list: [], current: 1, finished: false, total: 0, amountSum: '0.00' })
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
      channelId: auth.getChannelId()
    }
    if (this.data.activeStatus) params.status = this.data.activeStatus

    return http
      .get('/channel/order/page', params)
      .then((page) => {
        const records = (page && page.records) || []
        const list = this.data.list.concat(records)
        const total = page && page.total ? page.total : list.length
        let amount = 0
        list.forEach((item) => {
          amount += Number(item.amount || 0)
        })
        this.setData({
          list,
          total,
          amountSum: amount.toFixed(2),
          current: this.data.current + 1,
          finished: list.length >= total || records.length < this.data.size
        })
      })
      .catch(() => this.setData({ finished: true }))
      .then(() => this.setData({ loading: false }))
  },

  goCreate() {
    wx.navigateTo({ url: '/pages/report/create' })
  }
})
