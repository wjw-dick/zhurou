/**
 * 购物车工具（基于本地 storage，无需登录）
 * 同一商品 + 同一规格 + 同一分割方式 视为同一条记录。
 */
const config = require('../config.js')

const KEY = config.storageKeys.cart

/** 读取购物车 */
function list() {
  try {
    const arr = wx.getStorageSync(KEY)
    return Array.isArray(arr) ? arr : []
  } catch (e) {
    return []
  }
}

/** 写入购物车 */
function save(items) {
  try {
    wx.setStorageSync(KEY, items || [])
  } catch (e) {}
  updateTabBarBadge()
}

/** 生成条目唯一键 */
function itemKey(it) {
  return [it.productId, it.skuId || 0, it.splitType || 'NONE'].join('_')
}

/**
 * 加入购物车
 * @param {object} item 商品条目
 * @returns {Array} 新的购物车
 */
function add(item) {
  const items = list()
  const key = itemKey(item)
  const exist = items.find(it => itemKey(it) === key)
  if (exist) {
    exist.quantity = (exist.quantity || 0) + (item.quantity || 1)
  } else {
    items.push(Object.assign({}, item, { quantity: item.quantity || 1 }))
  }
  save(items)
  return items
}

/** 修改数量（数量 <= 0 时删除） */
function updateQuantity(productId, skuId, splitType, quantity) {
  const items = list()
  const key = itemKey({ productId: productId, skuId: skuId, splitType: splitType })
  const target = items.find(it => itemKey(it) === key)
  if (!target) return items
  if (quantity <= 0) {
    return remove(productId, skuId, splitType)
  }
  target.quantity = quantity
  save(items)
  return items
}

/** 删除条目 */
function remove(productId, skuId, splitType) {
  const key = itemKey({ productId: productId, skuId: skuId, splitType: splitType })
  const items = list().filter(it => itemKey(it) !== key)
  save(items)
  return items
}

/** 清空 */
function clear() {
  save([])
}

/** 商品总件数 */
function totalCount() {
  return list().reduce((sum, it) => sum + (it.quantity || 0), 0)
}

/** 合计金额（含分割加工费） */
function totalAmount() {
  return list().reduce((sum, it) => {
    const price = Number(it.price) || 0
    const fee = Number(it.splitFee) || 0
    return sum + (price + fee) * (it.quantity || 0)
  }, 0)
}

/** 同步购物车 tabBar 角标 */
function updateTabBarBadge() {
  const count = totalCount()
  try {
    if (count > 0) {
      wx.setTabBarBadge({ index: 3, text: String(count > 99 ? '99+' : count) })
    } else {
      wx.removeTabBarBadge({ index: 3 })
    }
  } catch (e) {}
}

module.exports = {
  KEY,
  list,
  save,
  add,
  remove,
  clear,
  updateQuantity,
  totalCount,
  totalAmount,
  updateTabBarBadge
}
