/**
 * 订单详情页
 * 接口：GET /public/orders/{orderNo}  -> { order, items }
 */
const request = require('../../utils/request.js')
const format = require('../../utils/format.js')

Page({
  data: {
    orderNo: '',
    order: null,
    items: [],
    loading: true
  },

  onLoad(options) {
    const orderNo = options.orderNo
    this.setData({ orderNo: orderNo })
    this.loadDetail(orderNo)
  },

  loadDetail(orderNo) {
    return request.get('/public/orders/' + orderNo)
      .then(res => {
        const order = (res && res.order) || res || {}
        const items = (res && res.items) || order.items || []
        this.setData({
          order: this.decorate(order),
          items: items.map(it => Object.assign({}, it, {
            key: [it.productId, it.skuId || 0, it.splitType || 'NONE'].join('_'),
            splitLabel: format.splitType(it.splitType)
          })),
          loading: false
        })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  decorate(o) {
    return Object.assign({}, o, {
      statusText: format.orderStatus(o.status),
      statusClass: format.orderStatusClass(o.status),
      deliveryText: format.deliveryType(o.deliveryType),
      amountText: format.money(o.payAmount != null ? o.payAmount : o.totalAmount),
      totalAmountText: format.money(o.totalAmount),
      deliveryFeeText: format.money(o.deliveryFee || 0),
      createdText: format.dateTime(o.createTime || o.createdAt)
    })
  },

  copyOrderNo() {
    wx.setClipboardData({ data: this.data.orderNo })
  },

  previewImage(e) {
    const url = e.currentTarget.dataset.src
    if (url) wx.previewImage({ current: url, urls: [url] })
  },

  contact() {
    wx.showToast({ title: '请联系门店客服', icon: 'none' })
  },

  pay() {
    wx.showModal({
      title: '支付',
      content: '订单 ' + this.data.orderNo + ' 需要支付，请在收银台完成支付',
      showCancel: false
    })
  }
})
