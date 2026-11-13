/**
 * 供货单详情
 * 详情：GET  /api/supplier/purchase/{id}
 * 明细：GET  /api/supplier/purchase/{id}/items
 * 确认送货：PUT /api/supplier/purchase/{id}/receive（后端「收货入库」，供应商侧即确认已送达）
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const STATUS_LABEL = {
  CREATED: '待发货',
  DELIVERING: '配送中',
  RECEIVED: '已入库',
  CHECKING: '对账中',
  SETTLED: '已结算'
}

Page({
  data: {
    id: '',
    statusLabel: STATUS_LABEL,
    detail: {},
    items: [],
    loading: true,
    submitting: false
  },

  onLoad(options) {
    if (!auth.requireLogin()) return
    this.setData({ id: options.id || '' })
    this.loadDetail()
    this.loadItems()
  },

  loadDetail() {
    return http
      .get('/supplier/purchase/' + this.data.id, {}, { loading: true, loadingText: '加载中' })
      .then((detail) => this.setData({ detail: detail || {} }))
      .catch(() => this.setData({ detail: {} }))
      .then(() => this.setData({ loading: false }))
  },

  loadItems() {
    return http
      .get('/supplier/purchase/' + this.data.id + '/items', {}, { showError: false })
      .then((items) => this.setData({ items: items || [] }))
      .catch(() => this.setData({ items: [] }))
  },

  /** 确认送货 */
  onConfirmDelivery() {
    wx.showModal({
      title: '确认送货',
      content: '确认该供货单已送货并入库？',
      confirmColor: '#c8161d',
      success: (res) => {
        if (!res.confirm) return
        this.setData({ submitting: true })
        http
          .put(
            '/supplier/purchase/' + this.data.id + '/receive',
            {},
            { loading: true, loadingText: '提交中' }
          )
          .then(() => {
            wx.showToast({ title: '已确认送货', icon: 'success' })
            this.loadDetail()
          })
          .catch(() => {})
          .then(() => this.setData({ submitting: false }))
      }
    })
  }
})
