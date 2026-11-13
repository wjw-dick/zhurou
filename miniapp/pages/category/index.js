/**
 * 分类页
 * 接口：
 *   GET /public/categories/tree        左侧品类/分类树
 *   GET /public/products               右侧商品列表（categoryId / bizType / keyword / current / size）
 */
const request = require('../../utils/request.js')
const format = require('../../utils/format.js')

Page({
  data: {
    tree: [],            // 分类树 [{ id, categoryName, children: [] }]
    topList: [],         // 左侧一级品类
    subList: [],         // 左侧二级分类
    activeTopIndex: 0,
    activeSubId: null,
    keyword: '',
    products: [],
    current: 1,
    size: 10,
    total: 0,
    loading: false,
    noMore: false
  },

  onLoad() {
    this.loadTree()
  },

  onShow() {
    // 首页点分类跳转时通过全局变量中转 categoryId
    const app = getApp()
    const pending = app.globalData && app.globalData.pendingCategoryId
    if (pending) {
      app.globalData.pendingCategoryId = null
      this.pendingCategoryId = pending
      // 若树已加载则直接定位，否则等待 loadTree 完成
      if (this.data.tree.length) this.locateCategory(pending)
    }
  },

  onPullDownRefresh() {
    this.loadTree(true).then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (this.data.noMore || this.data.loading) return
    this.setData({ current: this.data.current + 1 })
    this.loadProducts(true)
  },

  /** 分类树 */
  loadTree(isRefresh) {
    return request.get('/public/categories/tree')
      .then(res => {
        const tree = Array.isArray(res) ? res : format.pageList(res)
        const topList = tree.map(t => ({
          id: t.id,
          name: t.categoryName || t.name,
          bizType: t.bizType
        }))
        const first = tree[0] || {}
        const subList = this.normalizeSub(first)
        this.tree = tree
        this.setData({
          tree: tree,
          topList: topList,
          subList: subList,
          activeTopIndex: 0,
          activeSubId: null,
          products: [],
          current: 1,
          noMore: false
        })
        this.queryParams = { categoryId: first.id, bizType: first.bizType }
        // 处理首页中转的分类
        if (this.pendingCategoryId) {
          this.locateCategory(this.pendingCategoryId)
          this.pendingCategoryId = null
        } else {
          this.loadProducts()
        }
      })
      .catch(() => {
        if (isRefresh) wx.stopPullDownRefresh()
      })
  },

  /** 一级分类下的二级分类 */
  normalizeSub(top) {
    if (!top) return []
    const children = top.children || top.childList || []
    // 一级自身也是一个分类（"全部"）
    return [{
      id: top.id,
      name: '全部',
      bizType: top.bizType
    }].concat(children.map(c => ({
      id: c.id,
      name: c.categoryName || c.name,
      bizType: c.bizType || top.bizType
    })))
  },

  /** 切换一级品类 */
  onTopTap(e) {
    const index = e.currentTarget.dataset.index
    const top = this.tree[index] || {}
    const subList = this.normalizeSub(top)
    this.setData({
      activeTopIndex: index,
      subList: subList,
      activeSubId: null,
      products: [],
      current: 1,
      noMore: false
    })
    this.queryParams = { categoryId: top.id, bizType: top.bizType }
    this.loadProducts()
  },

  /** 切换二级分类 */
  onSubTap(e) {
    const item = e.currentTarget.dataset.item
    this.setData({
      activeSubId: item.id,
      products: [],
      current: 1,
      noMore: false
    })
    this.queryParams = { categoryId: item.id, bizType: item.bizType }
    this.loadProducts()
  },

  /** 定位到指定分类（首页跳转） */
  locateCategory(categoryId) {
    for (let i = 0; i < this.tree.length; i++) {
      const top = this.tree[i] || {}
      const children = top.children || top.childList || []
      if (top.id === categoryId) {
        this.onTopTap({ currentTarget: { dataset: { index: i } } })
        return
      }
      const hit = children.find(c => c.id === categoryId)
      if (hit) {
        this.setData({
          activeTopIndex: i,
          subList: this.normalizeSub(top),
          activeSubId: categoryId,
          products: [],
          current: 1,
          noMore: false
        })
        this.queryParams = { categoryId: categoryId, bizType: hit.bizType || top.bizType }
        this.loadProducts()
        return
      }
    }
  },

  /** 商品列表 */
  loadProducts(append) {
    if (this.data.loading) return
    this.setData({ loading: true })
    const params = Object.assign(
      { current: this.data.current, size: this.data.size },
      this.queryParams || {},
      this.data.keyword ? { keyword: this.data.keyword } : {}
    )
    return request.get('/public/products', params)
      .then(res => {
        const list = format.pageList(res).map(p => this.decorate(p))
        const total = format.pageTotal(res)
        const products = append ? this.data.products.concat(list) : list
        this.setData({
          products: products,
          total: total || products.length,
          loading: false,
          noMore: list.length < this.data.size
        })
      })
      .catch(() => {
        this.setData({ loading: false, noMore: true })
      })
  },

  decorate(p) {
    return Object.assign({}, p, {
      displayName: p.productName || p.name || '商品',
      displayImage: p.mainImage || p.image || p.coverImage || '',
      displayPrice: format.money(p.salePrice != null ? p.salePrice : p.price)
    })
  },

  onKeywordInput(e) {
    this.setData({ keyword: e.detail.value })
  },

  onSearch() {
    this.setData({ products: [], current: 1, noMore: false })
    this.loadProducts()
  },

  clearSearch() {
    this.setData({ keyword: '', products: [], current: 1, noMore: false })
    this.loadProducts()
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/detail/index?id=' + e.currentTarget.dataset.id })
  }
})
