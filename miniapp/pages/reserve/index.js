/**
 * 鲜肉预订页（tabBar）
 * 接口：
 *   GET  /public/stores                     门店列表
 *   GET  /public/reserve/config?storeId=    预订配置（可预订天数/截止时间/分割加工费）
 *   GET  /public/reserve/stocks             备货量查询（storeId + reserveDate）
 *   GET  /public/products?reservable=true   可选预订商品
 *   GET  /public/products/{id}/skus         规格
 *   POST /public/reserve/booking            提交预订（Redis 锁防超卖）
 */
const request = require('../../utils/request.js')
const config = require('../../config.js')
const format = require('../../utils/format.js')

Page({
  data: {
    store: null,
    stores: [],
    showStorePopup: false,

    reserveDates: [],
    reserveDate: '',
    reserveConfig: null,
    stocks: null,          // 备货量信息

    products: [],          // 可预订商品
    loading: false,

    // 选择面板
    showSheet: false,
    current: null,         // 当前选中商品
    skus: [],
    selectedSkuIndex: 0,
    selectedSku: null,
    splitTypes: [
      { value: 'CUBE', label: '切块', fee: 0 },
      { value: 'MINCED', label: '绞肉', fee: 0 },
      { value: 'SLICED', label: '切片', fee: 0 },
      { value: 'NONE', label: '不分割', fee: 0 }
    ],
    splitType: 'NONE',
    quantity: 1
  },

  onLoad() {
    this.setData({ store: wx.getStorageSync(config.storageKeys.store) || null })
    this.loadStores()
    this.loadProducts()
  },

  onShow() {
    const store = wx.getStorageSync(config.storageKeys.store) || null
    // 门店在首页被切换后同步
    if (!this.data.store || (store && store.id !== this.data.store.id)) {
      this.setData({ store: store })
      if (store) {
        this.loadReserveConfig()
      }
    }
  },

  onPullDownRefresh() {
    Promise.all([this.loadProducts(), this.loadReserveConfig()])
      .then(() => wx.stopPullDownRefresh())
  },

  /** 门店列表 */
  loadStores() {
    return request.get('/public/stores')
      .then(res => {
        const list = Array.isArray(res) ? res : format.pageList(res)
        this.setData({ stores: list })
        if (!this.data.store && list.length) {
          this.selectStore(list[0])
        } else if (this.data.store) {
          this.loadReserveConfig()
        }
      })
      .catch(() => {})
  },

  /** 预订配置：可预订天数 / 截止时间 / 分割加工费 */
  loadReserveConfig() {
    const store = this.data.store || {}
    return request.get('/public/reserve/config', { storeId: store.id })
      .then(cfg => {
        const splitTypes = this.parseSplitTypes(cfg)
        this.setData({ reserveConfig: cfg || null, splitTypes: splitTypes })
        this.buildReserveDates(cfg)
        this.loadStocks()
      })
      .catch(() => {
        this.buildReserveDates(null)
      })
  },

  parseSplitTypes(cfg) {
    const base = [
      { value: 'CUBE', label: '切块', fee: 0 },
      { value: 'MINCED', label: '绞肉', fee: 0 },
      { value: 'SLICED', label: '切片', fee: 0 },
      { value: 'NONE', label: '不分割', fee: 0 }
    ]
    if (!cfg) return base
    const raw = cfg.splitFees || cfg.splitTypes || cfg.splitFeeConfig
    if (!raw) return base
    return base.map(s => {
      let fee = 0
      if (Array.isArray(raw)) {
        const hit = raw.find(r => (r.splitType || r.type || r.value) === s.value)
        fee = hit ? Number(hit.fee || hit.splitFee || 0) : 0
      } else if (typeof raw === 'object') {
        fee = Number(raw[s.value] || 0)
      }
      return Object.assign({}, s, { fee: fee })
    })
  },

  /** 生成可预订日期（当天/次日） */
  buildReserveDates(cfg) {
    const days = Number((cfg && (cfg.reserveDays || cfg.days)) || 2)
    const maxDays = days > 0 ? days : 2
    const list = []
    const now = new Date()
    for (let i = 0; i < maxDays; i++) {
      const d = new Date(now.getTime() + i * 86400000)
      const value = format.formatYmd(d)
      let label = value
      if (i === 0) label = '今天'
      else if (i === 1) label = '明天'
      list.push({ value: value, label: label, date: value })
    }
    const keep = this.data.reserveDate && list.some(d => d.value === this.data.reserveDate)
    this.setData({
      reserveDates: list,
      reserveDate: keep ? this.data.reserveDate : (list.length ? list[0].value : '')
    })
  },

  /** 备货量查询 */
  loadStocks() {
    const store = this.data.store || {}
    if (!store.id || !this.data.reserveDate) return Promise.resolve()
    return request.get('/public/reserve/stocks', {
      storeId: store.id,
      reserveDate: this.data.reserveDate
    }, { hideError: true })
      .then(res => this.setData({ stocks: res || null }))
      .catch(() => this.setData({ stocks: null }))
  },

  /** 可预订商品列表 */
  loadProducts() {
    this.setData({ loading: true })
    const store = this.data.store || {}
    return request.get('/public/products', {
      reservable: true,
      size: 20,
      storeId: store.id
    })
      .then(res => {
        const list = format.pageList(res).map(p => Object.assign({}, p, {
          displayName: p.productName || p.name || '商品',
          displayImage: p.mainImage || p.image || p.coverImage || '',
          displayPrice: format.money(p.salePrice != null ? p.salePrice : p.price)
        }))
        this.setData({ products: list, loading: false })
      })
      .catch(() => this.setData({ loading: false }))
  },

  /** 门店选择 */
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
    this.loadReserveConfig()
  },

  /** 选择日期 */
  onDateTap(e) {
    this.setData({ reserveDate: e.currentTarget.dataset.value })
    this.loadStocks()
  },

  /** 打开商品选择面板 */
  openSheet(e) {
    const product = e.currentTarget.dataset.item
    this.setData({
      showSheet: true,
      current: product,
      quantity: 1,
      selectedSku: null,
      selectedSkuIndex: 0,
      skus: []
    })
    if (product.id) {
      request.get('/public/products/' + product.id + '/skus')
        .then(res => {
          const arr = Array.isArray(res) ? res : format.pageList(res)
          this.setData({
            skus: arr,
            selectedSku: arr.length ? arr[0] : null,
            selectedSkuIndex: 0
          })
        })
        .catch(() => {})
    }
  },

  closeSheet() {
    this.setData({ showSheet: false })
  },
  noop() {},

  onSkuTap(e) {
    const index = e.currentTarget.dataset.index
    this.setData({ selectedSkuIndex: index, selectedSku: this.data.skus[index] })
  },
  onSplitTap(e) {
    this.setData({ splitType: e.currentTarget.dataset.value })
  },
  minus() {
    if (this.data.quantity <= 1) return
    this.setData({ quantity: this.data.quantity - 1 })
  },
  plus() {
    this.setData({ quantity: this.data.quantity + 1 })
  },
  onQuantityInput(e) {
    let v = parseInt(e.detail.value, 10)
    if (isNaN(v) || v < 1) v = 1
    this.setData({ quantity: v })
  },

  /** 提交预订 */
  submit() {
    const store = this.data.store || {}
    const product = this.data.current || {}
    const sku = this.data.selectedSku || {}
    const fee = (this.data.splitTypes.find(s => s.value === this.data.splitType) || {}).fee || 0

    if (!store.id) {
      wx.showToast({ title: '请先选择门店', icon: 'none' })
      return
    }
    if (!this.data.reserveDate) {
      wx.showToast({ title: '请选择预订日期', icon: 'none' })
      return
    }

    const body = {
      storeId: store.id,
      productId: product.id,
      skuId: sku.id || null,
      reserveDate: this.data.reserveDate,
      quantity: this.data.quantity,
      // 以下为非必填扩展字段，后端未定义时可忽略
      splitType: this.data.splitType,
      splitFee: fee
    }

    request.post('/public/reserve/booking', body, { loading: true })
      .then(() => {
        this.setData({ showSheet: false })
        wx.showToast({ title: '预订成功', icon: 'success' })
        setTimeout(() => {
          wx.navigateTo({ url: '/pages/order/list?status=PREPARING' })
        }, 800)
      })
      .catch(() => {})
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/detail/index?id=' + e.currentTarget.dataset.id })
  }
})
