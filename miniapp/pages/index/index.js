/**
 * 首页
 * 接口：
 *   GET /public/banners?position=MINIAPP_HOME  首页 Banner 轮播
 *   GET /public/categories                     分类九宫格
 *   GET /public/products?size=6                热销商品
 *   GET /public/stores                         门店列表（用于门店切换）
 */
const request = require('../../utils/request.js')
const config = require('../../config.js')
const format = require('../../utils/format.js')

Page({
  data: {
    store: null,        // 当前门店
    banners: [],        // Banner
    categories: [],     // 分类九宫格
    hotProducts: [],    // 热销商品
    stores: [],         // 门店列表
    showStorePopup: false, // 门店选择弹层
    loading: true
  },

  onLoad() {
    this.setData({ store: wx.getStorageSync(config.storageKeys.store) || null })
    this.loadBanners()
    this.loadCategories()
    this.loadHotProducts()
    this.loadStores()
  },

  onShow() {
    // 门店可能在其它页面被切换
    this.setData({ store: wx.getStorageSync(config.storageKeys.store) || null })
  },

  onPullDownRefresh() {
    Promise.all([
      this.loadBanners(),
      this.loadCategories(),
      this.loadHotProducts()
    ]).then(() => wx.stopPullDownRefresh())
  },

  /** Banner 轮播 */
  loadBanners() {
    return request.get('/public/banners', { position: 'MINIAPP_HOME' })
      .then(res => {
        this.setData({ banners: Array.isArray(res) ? res : (res && res.records) || [] })
      })
      .catch(() => {})
  },

  /** 分类九宫格 */
  loadCategories() {
    return request.get('/public/categories')
      .then(res => {
        const list = Array.isArray(res) ? res : (res && res.records) || []
        this.setData({ categories: list.slice(0, 10) })
      })
      .catch(() => {})
  },

  /** 热销商品 */
  loadHotProducts() {
    return request.get('/public/products', { size: 6 })
      .then(res => {
        const list = format.pageList(res).map(p => this.decorate(p))
        this.setData({ hotProducts: list, loading: false })
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  /** 门店列表 */
  loadStores() {
    return request.get('/public/stores')
      .then(res => {
        const list = Array.isArray(res) ? res : (res && res.records) || []
        this.setData({ stores: list })
        // 若尚未选择门店，默认选第一家
        if (!this.data.store && list.length) {
          this.selectStore(list[0])
        }
      })
      .catch(() => {})
  },

  /** 商品展示字段预处理 */
  decorate(p) {
    return Object.assign({}, p, {
      displayName: p.productName || p.name || '商品',
      displayImage: p.mainImage || p.image || p.coverImage || '',
      displayPrice: format.money(p.salePrice != null ? p.salePrice : p.price)
    })
  },

  /** 切换门店弹层 */
  openStorePopup() {
    this.setData({ showStorePopup: true })
  },
  closeStorePopup() {
    this.setData({ showStorePopup: false })
  },
  onStoreTap(e) {
    this.selectStore(e.currentTarget.dataset.item)
    this.setData({ showStorePopup: false })
  },
  selectStore(store) {
    wx.setStorageSync(config.storageKeys.store, store)
    this.setData({ store: store })
  },

  onBannerTap(e) {
    const item = e.currentTarget.dataset.item || {}
    // Banner 可配置跳转链接：优先站内商品/网页
    if (item.linkType === 'PRODUCT' && item.linkValue) {
      wx.navigateTo({ url: '/pages/detail/index?id=' + item.linkValue })
    } else if (item.linkUrl) {
      wx.navigateTo({ url: '/pages/webview/index?url=' + encodeURIComponent(item.linkUrl) })
    }
  },

  goCategory(e) {
    const id = e.currentTarget.dataset.id
    wx.switchTab({
      url: '/pages/category/index',
      success: () => {
        // tabBar 页无法带参，用全局变量中转
        getApp().globalData.pendingCategoryId = id
      }
    })
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/detail/index?id=' + e.currentTarget.dataset.id })
  },

  goCombo() {
    wx.navigateTo({ url: '/pages/combo/index' })
  },

  goReserve() {
    wx.switchTab({ url: '/pages/reserve/index' })
  },

  /** 阻止弹层内部点击冒泡关闭 */
  noop() {}
})
