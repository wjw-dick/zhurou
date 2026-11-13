import axios from 'axios'

/* ------------------------------------------------------------------ *
 * H5 分享页接口层
 * 后端统一响应：{ code, msg, data }，code === 200 表示成功
 * 对外公开接口（/public/**）无需登录；如需会员信息请自行传入 memberId
 * ------------------------------------------------------------------ */

const TOKEN_KEY = 'zhushi_h5_token'
const MEMBER_KEY = 'zhushi_h5_member_id'

export function getToken(): string {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken(token: string) {
  localStorage.setItem(TOKEN_KEY, token)
}

export function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
}

/** 会员ID：优先取地址栏 ?memberId=xxx（分享链接携带），其次取本地缓存 */
export function getMemberId(): number | null {
  const fromQuery = new URLSearchParams(location.search).get('memberId')
  if (fromQuery) {
    localStorage.setItem(MEMBER_KEY, fromQuery)
    return Number(fromQuery)
  }
  const cached = localStorage.getItem(MEMBER_KEY)
  return cached ? Number(cached) : null
}

export function setMemberId(id: number | string) {
  localStorage.setItem(MEMBER_KEY, String(id))
}

/** 轻量提示（无 UI 库，直接操作 DOM） */
export function toast(msg: string) {
  if (!msg) return
  const el = document.createElement('div')
  el.className = 'zhushi-toast'
  el.textContent = msg
  document.body.appendChild(el)
  setTimeout(() => el.remove(), 2000)
}

export interface ApiResult<T = any> {
  code: number
  msg: string
  data: T
}

export interface PageData<T = any> {
  records: T[]
  total: number
  current: number
  size: number
}

const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || '/api',
  timeout: 30000
})

service.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

service.interceptors.response.use(
  (response) => {
    const res = response.data as ApiResult
    if (res && res.code === 200) {
      // 直接返回业务数据，页面无需再取一层 data
      return res.data as any
    }
    toast(res?.msg || '请求失败')
    return Promise.reject(new Error(res?.msg || '请求失败'))
  },
  (error) => {
    toast(error?.response?.data?.msg || error?.message || '网络异常')
    return Promise.reject(error)
  }
)

/* ----------------------------- 类型定义 ----------------------------- */

export interface MenuItem {
  id: number
  parentId: number
  name: string
  path: string
  icon?: string
  menuType: string
  sort?: number
}

export interface BannerItem {
  id: number
  title: string
  image: string
  linkUrl?: string
  position: string
  sort?: number
}

export interface ProductItem {
  id: number
  categoryId: number
  name: string
  subTitle?: string
  bizType: string
  cover?: string
  images?: string
  /** 富文本详情（HTML） */
  detail?: string
  unit?: string
  origin?: string
  shelfLife?: string
  storageCond?: string
  cookTip?: string
  tags?: string
  sales?: number
  price?: number
}

export interface SkuItem {
  id: number
  skuName: string
  spec?: string
  price: number
  marketPrice?: number
  weight?: number
  unit?: string
  stock?: number
  /** 0 停用 / 1 启用 */
  status?: number
}

export interface QualificationItem {
  id: number
  qualType: string
  qualNo?: string
  issuer?: string
  issueDate?: string
  expireDate?: string
  fileUrl?: string
}

export interface MemberInfo {
  id: number
  nickname?: string
  avatar?: string
  phone?: string
  balance?: number
  points?: number
  levelId?: number
  totalAmount?: number
}

export interface OrderItem {
  id: number
  orderId: number
  productId: number
  productName: string
  skuName?: string
  price: number
  quantity: number
  weight?: number
  splitType?: string
  splitFee?: number
  amount?: number
}

export interface OrderInfo {
  id: number
  orderNo: string
  memberId: number
  storeId?: number
  orderType: string
  status: string
  deliveryType?: string
  appointDate?: string
  receiverName?: string
  receiverPhone?: string
  receiverAddress?: string
  totalAmount?: number
  splitFee?: number
  deliveryFee?: number
  discountAmount?: number
  payAmount?: number
  createTime?: string
  remark?: string
}

/* ----------------------------- 站点与导航 ----------------------------- */

/** 导航菜单：platform = PC / WECHAT / MINIAPP / H5 */
export function getMenus(platform: string) {
  return service.get<any, MenuItem[]>(`/public/menus/${platform}`)
}

/** Banner 列表：position = H5 / PC_HOME / MINIAPP_HOME */
export function getBanners(position: string) {
  return service.get<any, BannerItem[]>('/public/banners', { params: { position } })
}

/** 站点配置（站名 / logo / 客服电话等） */
export function getSiteConfig() {
  return service.get<any, Record<string, any>>('/public/config')
}

/* ------------------------------- 商品 ------------------------------- */

/** 商品分页：categoryId / bizType / keyword / current / size */
export function getProducts(params: {
  bizType?: string
  categoryId?: number | string
  keyword?: string
  current?: number
  size?: number
}) {
  return service.get<any, PageData<ProductItem>>('/public/products', { params })
}

/** 商品详情：返回 { product, skus, qualifications } */
export function getProductDetail(id: number | string) {
  return service.get<any, { product: ProductItem; skus: SkuItem[]; qualifications: QualificationItem[] }>(
    `/public/products/${id}`
  )
}

/* ---------------------------- 会员与订单 ---------------------------- */

/** 会员信息（余额 / 积分 / 等级） */
export function getMember(id: number | string) {
  return service.get<any, MemberInfo>(`/public/member/${id}`)
}

/** 会员订单分页 */
export function getOrders(params: { memberId: number | string; status?: string; current?: number; size?: number }) {
  return service.get<any, PageData<OrderInfo>>('/public/orders', { params })
}

/** 订单详情：返回 { order, items } */
export function getOrderDetail(orderNo: string) {
  return service.get<any, { order: OrderInfo; items: OrderItem[] }>(`/public/orders/${orderNo}`)
}

export default service
