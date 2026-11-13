import { computed, ref } from 'vue'

/* =========================================================
 * 本地购物车（浏览器 localStorage 持久化）
 * 官网仅做加购/预订引导，结算由小程序或门店完成
 * ========================================================= */

export interface CartItem {
  productId: number
  productName: string
  skuId: number
  skuName: string
  price: number
  cover?: string
  quantity: number
}

const STORAGE_KEY = 'zhushi_pc_cart'

function readCart(): CartItem[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? (JSON.parse(raw) as CartItem[]) : []
  } catch (e) {
    return []
  }
}

export const cartItems = ref<CartItem[]>(readCart())

/** 购物车商品总件数 */
export const cartCount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + (item.quantity || 0), 0)
)

/** 购物车合计金额 */
export const cartAmount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + (item.price || 0) * (item.quantity || 0), 0)
)

function persist() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(cartItems.value))
  } catch (e) {
    /* ignore */
  }
}

/** 加入购物车（同商品同规格累加数量） */
export function addToCart(item: Omit<CartItem, 'quantity'>, quantity = 1) {
  const target = cartItems.value.find(
    (row) => row.productId === item.productId && row.skuId === item.skuId
  )
  if (target) {
    target.quantity += quantity
  } else {
    cartItems.value.push({ ...item, quantity })
  }
  persist()
}

/** 移除 */
export function removeFromCart(productId: number, skuId: number) {
  cartItems.value = cartItems.value.filter(
    (row) => !(row.productId === productId && row.skuId === skuId)
  )
  persist()
}

/** 清空 */
export function clearCart() {
  cartItems.value = []
  persist()
}
