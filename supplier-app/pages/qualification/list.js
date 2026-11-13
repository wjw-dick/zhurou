/**
 * 资质与检疫证明列表
 * GET /api/supplier/qualification/page?current=&size=&auditStatus=&supplierId=
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_OPTIONS = [
  { label: '全部', value: '' },
  { label: '待审核', value: 'PENDING' },
  { label: '已通过', value: 'APPROVED' },
  { label: '已驳回', value: 'REJECTED' }
]

const STATUS_LABEL = {
  PENDING: '待审核',
  APPROVED: '已通过',
  REJECTED: '已驳回'
}

// 资质类型（与后端字典 qualType 对应）
const QUAL_TYPE_LABEL = {
  QUARANTINE: '动物产品检疫合格证明',
  QUALITY: '肉品品质检验合格证',
  SC: '食品生产许可',
  BUSINESS: '营业执照',
  INSPECTION: '检测报告'
}

Page({
  data: {
    statusOptions: STATUS_OPTIONS,
    statusLabel: STATUS_LABEL,
    qualTypeLabel: QUAL_TYPE_LABEL,
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
    this.load()
  },

  refresh() {
    this.setData({ list: [], current: 1, finished: false, total: 0 })
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
    if (this.data.activeStatus) params.auditStatus = this.data.activeStatus

    return http
      .get('/supplier/qualification/page', params)
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
  },

  /** 预览证照图片 */
  onPreview(e) {
    const url = e.currentTarget.dataset.url
    if (url) wx.previewImage({ urls: [url], current: url })
  },

  goAdd() {
    wx.navigateTo({ url: '/pages/qualification/edit' })
  },

  goEdit(e) {
    wx.navigateTo({ url: '/pages/qualification/edit?id=' + e.currentTarget.dataset.id })
  }
})
