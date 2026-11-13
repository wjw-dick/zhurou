/**
 * 火锅套餐 / 礼盒专区
 * 接口：
 *   GET /public/products?bizType=SET&current=&size=   套餐礼盒商品
 *   GET /public/categories/tree?bizType=SET          套餐内二级分类（可选筛选）
 */
const request = require('../../utils/request.js')
const format = require('../../utils/format.js')

Page({
  data: {
    bizType: 'SET',
    categories: [],
    activeCategoryId: null,
    products: [],
    current: 1,
    size: 10,
    noMore: false,
    loading: false
  },

  onLoad() {
    this.loadCategories()
    this.loadProducts()
  },

  onPullDownRefresh() {
    this.setData({ products: [], current: 1, noMore: false })
    this.loadProducts().then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (this.data.noMore || this.data.loading) return
    this.setData({ current: this.data.current + 1 })
    this.loadProducts(true)
  },

  /** 套餐下的分类（兜底失败则忽略） */
  loadCategories() {
    return request.get('/public/categories/tree', { bizType: 'SET' }, { hideError: true })
      .then(res => {
        const tree = Array.isArray(res) ? res : format.pageList(res)
        const list = [{ id: null, name: '全部' }].concat(tree.map(t => ({
          id: t.id,
          name: t.categoryName || t.name
        })))
        this.setData({ categories: list })
      })
      .catch(() => {})
  },

  onCategoryTap(e) {
    const id = e.currentTarget.dataset.id
    this.setData({ activeCategoryId: id, products: [], current: 1, noMore: false })
    this.loadProducts()
  },

  /** 商品列表 */
  loadProducts(append) {
    this.setData({ loading: true })
    const params = {
      bizType: this.data.bizType,
      current: this.data.current,
      size: this.data.size
    }
    if (this.data.activeCategoryId) {
      params.categoryId = this.data.activeCategoryId
    }
    return request.get('/public/products', params)
      .then(res => {
        const list = format.pageList(res).map(p => Object.assign({}, p, {
          displayName: p.productName || p.name || '商品',
          displayImage: p.mainImage || p.image || p.coverImage || '',
          displayPrice: format.money(p.salePrice != null ? p.salePrice : p.price)
        }))
        this.setData({
          products: append ? this.data.products.concat(list) : list,
          loading: false,
          noMore: list.length < this.data.size
        })
      })
      .catch(() => this.setData({ loading: false, noMore: true }))
  },

  goDetail(e) {
    wx.navigateTo({ url: '/pages/detail/index?id=' + e.currentTarget.dataset.id })
  }
})
