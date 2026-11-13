/**
 * 商品详情页
 * 接口：
 *   GET /public/products/{id}          商品详情 -> { product, skus, qualifications }
 *   GET /public/products/{id}/skus     规格（详情未带 skus 时兜底拉取）
 *   GET /public/reserve/config         鲜肉预订配置（可预订天数/截止时间/分割加工费）
 *   POST /public/reserve/booking       鲜肉预订扣减
 */
const request = require('../../utils/request.js')
const config = require('../../config.js')
const format = require('../../utils/format.js')
const cart = require('../../utils/cart.js')

Page({
  data: {
    id: null,
    product: null,
    skus: [],
    qualifications: [], // 检疫/品质等资质
    images: [],
    loading: true,

    // 底部弹层
    showSheet: false,
    mode: 'cart',       // cart 加入购物车 / buy 立即购买 / reserve 鲜肉预订
    selectedSku: null,
    selectedSkuIndex: 0,
    quantity: 1,

    // 鲜肉预订
    splitTypes: [
      { value: 'CUBE', label: '切块', fee: 0 },
      { value: 'MINCED', label: '绞肉', fee: 0 },
      { value: 'SLICED', label: '切片', fee: 0 },
      { value: 'NONE', label: '不分割', fee: 0 }
    ],
    splitType: 'NONE',
    reserveDates: [],
    reserveDate: '',
    reserveConfig: null,
    cartCount: 0
  },

  onLoad(options) {
    const id = options.id
    this.setData({ id: id })
    this.loadDetail(id)
    this.setData({ cartCount: cart.totalCount() })
  },

  onShow() {
    this.setData({ cartCount: cart.totalCount() })
  },

  /** 商品详情 */
  loadDetail(id) {
    return request.get('/public/products/' + id)
      .then(res => {
        const product = (res && res.product) || res || {}
        const skus = (res && res.skus) || product.skus || []
        const qualifications = (res && res.qualifications) || []

        // 主图集合：优先 images 数组，其次 mainImage
        let images = product.images || product.imageList || []
        if (typeof images === 'string') {
          images = images.split(',').filter(Boolean)
        }
        if (!images.length) {
          const main = product.mainImage || product.image || product.coverImage
          if (main) images = [main]
        }

        this.setData({
          product: product,
          skus: skus,
          qualifications: qualifications,
          images: images,
          selectedSku: skus.length ? skus[0] : null,
          selectedSkuIndex: 0,
          loading: false
        })

        if (product.productName || product.name) {
          wx.setNavigationBarTitle({ title: product.productName || product.name })
        }

        // 详情未返回规格时兜底拉取
        if (!skus.length) {
          request.get('/public/products/' + id + '/skus').then(list => {
            const arr = Array.isArray(list) ? list : format.pageList(list)
            this.setData({
              skus: arr,
              selectedSku: arr.length ? arr[0] : null,
              selectedSkuIndex: 0
            })
          }).catch(() => {})
        }
      })
      .catch(() => {
        this.setData({ loading: false })
      })
  },

  /** 预览图片 */
  previewImage(e) {
    const current = e.currentTarget.dataset.src
    wx.previewImage({ current: current, urls: this.data.images })
  },

  /** 预览资质证书 */
  previewQual(e) {
    const item = e.currentTarget.dataset.item || {}
    const url = item.fileUrl || item.imageUrl || item.certUrl
    if (!url) {
      wx.showToast({ title: format.qualType(item.qualType), icon: 'none' })
      return
    }
    wx.previewImage({ current: url, urls: [url] })
  },

  /** 打开弹层 */
  openSheet(e) {
    const mode = e.currentTarget.dataset.mode
    this.setData({ showSheet: true, mode: mode, quantity: 1 })
    if (mode === 'reserve') {
      this.loadReserveConfig()
      this.buildReserveDates(this.data.reserveConfig)
    }
  },

  closeSheet() {
    this.setData({ showSheet: false })
  },

  noop() {},

  /** 选择规格 */
  onSkuTap(e) {
    const index = e.currentTarget.dataset.index
    this.setData({
      selectedSkuIndex: index,
      selectedSku: this.data.skus[index]
    })
  },

  /** 数量增减 */
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

  /** 选择分割方式 */
  onSplitTap(e) {
    this.setData({ splitType: e.currentTarget.dataset.value })
  },

  /** 选择预订日期 */
  onDateTap(e) {
    this.setData({ reserveDate: e.currentTarget.dataset.value })
  },

  /** 当前分割方式的加工费 */
  currentSplitFee() {
    const t = this.data.splitType
    const hit = this.data.splitTypes.find(s => s.value === t)
    return hit ? Number(hit.fee) || 0 : 0
  },

  /** 加载预订配置 */
  loadReserveConfig() {
    const store = wx.getStorageSync(config.storageKeys.store) || {}
    return request.get('/public/reserve/config', { storeId: store.id })
      .then(cfg => {
        const splitTypes = this.parseSplitTypes(cfg)
        this.setData({ reserveConfig: cfg || null, splitTypes: splitTypes })
        this.buildReserveDates(cfg)
      })
      .catch(() => {})
  },

  /** 解析后端返回的分割加工费配置 */
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
    // 支持 { CUBE: 2 } 或 [{splitType:'CUBE', fee:2}]
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

  /** 生成可预订日期（当天/次日 …） */
  buildReserveDates(cfg) {
    const days = Number((cfg && (cfg.reserveDays || cfg.days)) || 2)
    const maxDays = days > 0 ? days : 2
    const list = []
    const now = new Date()
    for (let i = 0; i < maxDays; i++) {
      const d = new Date(now.getTime() + i * 86400000)
      const value = format.formatYmd(d)
      let label = value
      if (i === 0) label = '今天 ' + value
      else if (i === 1) label = '明天 ' + value
      else label = value
      list.push({ value: value, label: label })
    }
    this.setData({ reserveDates: list, reserveDate: list.length ? list[0].value : '' })
  },

  /** 组装购物车条目 */
  buildItem() {
    const p = this.data.product || {}
    const sku = this.data.selectedSku || {}
    const store = wx.getStorageSync(config.storageKeys.store) || {}
    return {
      productId: p.id,
      skuId: sku.id || null,
      productName: p.productName || p.name || '商品',
      skuName: sku.skuName || sku.name || p.spec || '默认规格',
      price: Number(sku.price != null ? sku.price : (p.salePrice != null ? p.salePrice : p.price)) || 0,
      quantity: this.data.quantity,
      image: this.data.images[0] || '',
      weight: sku.weight || p.weight || 0,
      unit: p.unit || '份',
      storeId: store.id || null,
      bizType: p.bizType || '',
      reservable: !!p.reservable,
      splitType: 'NONE',
      splitFee: 0
    }
  },

  /** 加入购物车 */
  addToCart() {
    const item = this.buildItem()
    cart.add(item)
    this.setData({ showSheet: false, cartCount: cart.totalCount() })
    wx.showToast({ title: '已加入购物车', icon: 'success' })
  },

  /** 立即购买 */
  buyNow() {
    const item = this.buildItem()
    wx.setStorageSync(config.storageKeys.confirmItems, [item])
    this.setData({ showSheet: false })
    wx.navigateTo({ url: '/pages/order/confirm?orderType=NORMAL&from=buynow' })
  },

  /** 提交鲜肉预订 */
  submitReserve() {
    const p = this.data.product || {}
    const sku = this.data.selectedSku || {}
    const store = wx.getStorageSync(config.storageKeys.store) || {}

    if (!store.id) {
      wx.showToast({ title: '请先选择门店', icon: 'none' })
      return
    }
    if (!this.data.reserveDate) {
      wx.showToast({ title: '请选择预订日期', icon: 'none' })
      return
    }

    const fee = this.currentSplitFee()
    const body = {
      storeId: store.id,
      productId: p.id,
      skuId: sku.id || null,
      reserveDate: this.data.reserveDate,
      quantity: this.data.quantity,
      // 后端预订接口若未定义分割字段，可忽略以下两个字段
      splitType: this.data.splitType,
      splitFee: fee
    }

    request.post('/public/reserve/booking', body, { loading: true })
      .then(() => {
        this.setData({ showSheet: false })
        wx.showToast({ title: '预订成功', icon: 'success' })
        setTimeout(() => {
          wx.navigateTo({ url: '/pages/order/list?status=UNPAID' })
        }, 800)
      })
      .catch(() => {})
  },

  /** 底部弹层确认分发 */
  onSheetConfirm() {
    if (this.data.mode === 'reserve') {
      this.submitReserve()
    } else if (this.data.mode === 'buy') {
      this.buyNow()
    } else {
      this.addToCart()
    }
  },

  /** 跳购物车 */
  goCart() {
    wx.switchTab({ url: '/pages/cart/index' })
  },

  /** 联系客服 */
  contact() {
    wx.showToast({ title: '客服电话见门店信息', icon: 'none' })
  },

  goCombo() {
    wx.navigateTo({ url: '/pages/combo/index' })
  }
})
