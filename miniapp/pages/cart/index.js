/**
 * 购物车页（tabBar）
 * 数据来源：本地 storage（utils/cart.js），不调用后端接口。
 * 结算时把商品写入本地中转缓存，跳到确认下单页。
 */
const config = require('../../config.js')
const format = require('../../utils/format.js')
const cart = require('../../utils/cart.js')

Page({
  data: {
    items: [],
    totalAmount: '0.00',
    totalCount: 0,
    editMode: false
  },

  onShow() {
    this.refresh()
  },

  /** 从本地缓存刷新列表与合计 */
  refresh() {
    const items = cart.list().map(it => Object.assign({}, it, {
      key: [it.productId, it.skuId || 0, it.splitType || 'NONE'].join('_'),
      splitLabel: format.splitType(it.splitType)
    }))
    this.setData({
      items: items,
      totalCount: cart.totalCount(),
      totalAmount: format.money(cart.totalAmount())
    })
    cart.updateTabBarBadge()
  },

  /** 数量 -1 */
  minus(e) {
    const it = e.currentTarget.dataset.item
    cart.updateQuantity(it.productId, it.skuId, it.splitType, (it.quantity || 1) - 1)
    this.refresh()
  },

  /** 数量 +1 */
  plus(e) {
    const it = e.currentTarget.dataset.item
    cart.updateQuantity(it.productId, it.skuId, it.splitType, (it.quantity || 1) + 1)
    this.refresh()
  },

  /** 手动输入数量 */
  onQuantityInput(e) {
    const it = e.currentTarget.dataset.item
    let v = parseInt(e.detail.value, 10)
    if (isNaN(v)) v = 1
    if (v < 1) v = 1
    cart.updateQuantity(it.productId, it.skuId, it.splitType, v)
    this.refresh()
  },

  /** 删除单项 */
  removeItem(e) {
    const it = e.currentTarget.dataset.item
    wx.showModal({
      title: '提示',
      content: '确认移除该商品？',
      success: res => {
        if (res.confirm) {
          cart.remove(it.productId, it.skuId, it.splitType)
          this.refresh()
        }
      }
    })
  },

  /** 清空购物车 */
  clearCart() {
    if (!this.data.items.length) return
    wx.showModal({
      title: '提示',
      content: '确认清空购物车？',
      success: res => {
        if (res.confirm) {
          cart.clear()
          this.refresh()
        }
      }
    })
  },

  toggleEdit() {
    this.setData({ editMode: !this.data.editMode })
  },

  /** 去结算 */
  checkout() {
    if (!this.data.items.length) {
      wx.showToast({ title: '购物车是空的', icon: 'none' })
      return
    }
    const store = wx.getStorageSync(config.storageKeys.store) || {}
    if (!store.id) {
      wx.showToast({ title: '请先选择门店', icon: 'none' })
      return
    }
    // 中转给确认下单页
    wx.setStorageSync(config.storageKeys.confirmItems, cart.list())
    wx.navigateTo({ url: '/pages/order/confirm?orderType=NORMAL&from=cart' })
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/detail/index?id=' + e.currentTarget.dataset.id })
  },

  goIndex() {
    wx.switchTab({ url: '/pages/index/index' })
  }
})
