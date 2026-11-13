/**
 * 确认下单页
 * 接口：
 *   GET  /public/stores       门店信息（配送费/自提点）
 *   POST /public/orders       提交订单
 * 数据来源：
 *   上一页（购物车 / 立即购买 / 详情）写入的 storage.confirmItems
 */
const request = require('../../utils/request.js')
const config = require('../../config.js')
const format = require('../../utils/format.js')
const cart = require('../../utils/cart.js')
const auth = require('../../utils/auth.js')

Page({
  data: {
    items: [],
    orderType: 'NORMAL',
    from: '',
    store: null,

    deliveryType: 'SELF_PICKUP', // SELF_PICKUP 到店自提 / DELIVERY 门店配送
    appointDate: '',
    receiverName: '',
    receiverPhone: '',
    receiverAddress: '',
    remark: '',

    goodsAmount: '0.00',
    deliveryFee: '0.00',
    payAmount: '0.00',
    totalWeight: 0,
    submitting: false
  },

  onLoad(options) {
    const orderType = options.orderType || 'NORMAL'
    this.setData({
      orderType: orderType,
      from: options.from || '',
      appointDate: options.appointDate || '',
      store: wx.getStorageSync(config.storageKeys.store) || null
    })
    this.loadItems()
    // 回填上次填写的收货信息
    const last = wx.getStorageSync('zs_last_receiver')
    if (last) {
      this.setData({
        receiverName: last.receiverName || '',
        receiverPhone: last.receiverPhone || '',
        receiverAddress: last.receiverAddress || ''
      })
    }
  },

  /** 读取待下单商品 */
  loadItems() {
    const items = wx.getStorageSync(config.storageKeys.confirmItems) || []
    const list = items.map(it => Object.assign({}, it, {
      key: [it.productId, it.skuId || 0, it.splitType || 'NONE'].join('_'),
      splitLabel: format.splitType(it.splitType)
    }))
    const goodsAmount = items.reduce((sum, it) => {
      return sum + ((Number(it.price) || 0) + (Number(it.splitFee) || 0)) * (it.quantity || 0)
    }, 0)
    const weight = items.reduce((sum, it) => sum + (Number(it.weight) || 0) * (it.quantity || 0), 0)

    this.setData({
      items: list,
      goodsAmount: format.money(goodsAmount),
      totalWeight: Number(weight.toFixed(2))
    })
    this.calcFee()
  },

  /** 计算配送费（满额免配送费按门店配置，前端仅做展示预估） */
  calcFee() {
    const store = this.data.store || {}
    let fee = 0
    if (this.data.deliveryType === 'DELIVERY') {
      const goods = Number(this.data.goodsAmount) || 0
      const freeLimit = Number(store.freeDeliveryAmount || store.freeShippingAmount || 0)
      const base = Number(store.deliveryFee || store.shippingFee || 0)
      fee = (freeLimit > 0 && goods >= freeLimit) ? 0 : base
    }
    const pay = (Number(this.data.goodsAmount) || 0) + fee
    this.setData({
      deliveryFee: format.money(fee),
      payAmount: format.money(pay)
    })
  },

  /** 切换自提/配送 */
  onDeliveryTap(e) {
    this.setData({ deliveryType: e.currentTarget.dataset.value })
    this.calcFee()
  },

  onInput(e) {
    const field = e.currentTarget.dataset.field
    const patch = {}
    patch[field] = e.detail.value
    this.setData(patch)
  },

  /** 选择预约日期 */
  onDateChange(e) {
    this.setData({ appointDate: e.detail.value })
  },

  /** 选择门店 */
  chooseStore() {
    wx.showToast({ title: '请到首页切换门店', icon: 'none' })
  },

  /** 提交订单 */
  submit() {
    if (this.data.submitting) return

    const store = this.data.store || {}
    if (!store.id) {
      wx.showToast({ title: '请先选择门店', icon: 'none' })
      return
    }
    if (!this.data.items.length) {
      wx.showToast({ title: '没有可结算的商品', icon: 'none' })
      return
    }
    if (this.data.deliveryType === 'DELIVERY') {
      if (!this.data.receiverName) {
        wx.showToast({ title: '请填写收货人', icon: 'none' })
        return
      }
      if (!/^1\d{10}$/.test(this.data.receiverPhone)) {
        wx.showToast({ title: '请填写正确的手机号', icon: 'none' })
        return
      }
      if (!this.data.receiverAddress) {
        wx.showToast({ title: '请填写收货地址', icon: 'none' })
        return
      }
    }

    const body = {
      memberId: auth.getMemberId(),
      storeId: store.id,
      orderType: this.data.orderType || 'NORMAL',
      source: 'MINIAPP',
      deliveryType: this.data.deliveryType,
      appointDate: this.data.appointDate || null,
      receiverName: this.data.receiverName,
      receiverPhone: this.data.receiverPhone,
      receiverAddress: this.data.deliveryType === 'DELIVERY' ? this.data.receiverAddress : (this.data.receiverAddress || ''),
      remark: this.data.remark,
      items: this.data.items.map(it => ({
        productId: it.productId,
        skuId: it.skuId,
        productName: it.productName,
        skuName: it.skuName,
        price: it.price,
        quantity: it.quantity,
        weight: it.weight,
        splitType: it.splitType || 'NONE',
        splitFee: it.splitFee || 0
      }))
    }

    this.setData({ submitting: true })
    request.post('/public/orders', body, { loading: true })
      .then(res => {
        // 记住收货信息
        wx.setStorageSync('zs_last_receiver', {
          receiverName: this.data.receiverName,
          receiverPhone: this.data.receiverPhone,
          receiverAddress: this.data.receiverAddress
        })
        // 清空已下单商品
        if (this.data.from === 'cart') {
          cart.clear()
        }
        wx.removeStorageSync(config.storageKeys.confirmItems)

        wx.showToast({ title: '下单成功', icon: 'success' })
        const orderNo = (res && (res.orderNo || (res.order && res.order.orderNo))) || ''
        setTimeout(() => {
          if (orderNo) {
            wx.redirectTo({ url: '/pages/order/detail?orderNo=' + orderNo })
          } else {
            wx.redirectTo({ url: '/pages/order/list?status=UNPAID' })
          }
        }, 800)
      })
      .catch(() => {
        this.setData({ submitting: false })
      })
  }
})
