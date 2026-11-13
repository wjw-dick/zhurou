import axios from 'axios'

/* =========================================================
 * 统一响应结构：{ code, msg, data }
 * code === 200 时返回 data，否则抛出 Error(msg)
 * ========================================================= */

export interface R<T> {
  code: number
  msg: string
  data: T
}

/** 统一分页结构（后端 PageResult） */
export interface PageResult<T> {
  records: T[]
  total: number
  current: number
  size: number
}

/* ------------------------- 业务实体类型 ------------------------- */

/** 站点配置，后端返回为 key-value 映射 */
export type SiteConfigMap = Record<string, string>

/** 导航菜单（sys_menu，platform = PC） */
export interface MenuItem {
  id: number
  parentId: number
  platform: string
  menuType: string
  name: string
  nameEn?: string
  path: string
  component?: string
  icon?: string
  sort?: number
  visible?: number
  status?: number
  children?: MenuItem[]
}

/** Banner */
export interface Banner {
  id: number
  title?: string
  titleEn?: string
  image: string
  linkUrl?: string
  position: string
  sort?: number
}

/** 商品分类 */
export interface ProductCategory {
  id: number
  parentId: number
  name: string
  nameEn?: string
  bizType: string
  icon?: string
  sort?: number
}

/** 商品 */
export interface Product {
  id: number
  categoryId: number
  name: string
  subTitle?: string
  bizType: string
  cover?: string
  images?: string
  detail?: string
  unit?: string
  origin?: string
  shelfLife?: string
  storageCond?: string
  cookTip?: string
  reservable?: number
  splitEnabled?: number
  splitFee?: number
  tags?: string
  sales?: number
  status?: number
}

/** 商品规格 SKU */
export interface ProductSku {
  id: number
  productId: number
  skuName: string
  spec?: string
  price: number
  marketPrice?: number
  weight?: number
  unit?: string
  stock?: number
}

/** 检疫 / 资质证明 */
export interface Qualification {
  id: number
  productId: number
  qualType: string
  qualNo?: string
  issuer?: string
  issueDate?: string
  expireDate?: string
  fileUrl?: string
  status?: number
}

/** 商品详情聚合 */
export interface ProductDetail {
  product: Product
  skus: ProductSku[]
  qualifications: Qualification[]
}

/** 门店 */
export interface Store {
  id: number
  code: string
  name: string
  contact?: string
  phone?: string
  province?: string
  city?: string
  district?: string
  address?: string
  lng?: number
  lat?: number
  businessHours?: string
  deliveryRadiusKm?: number
  deliveryFee?: number
  freeDeliveryAmount?: number
  minOrderAmount?: number
  images?: string
  intro?: string
  status?: number
}

/** CMS 文章 */
export interface Article {
  id: number
  categoryId?: number
  title: string
  titleEn?: string
  summary?: string
  summaryEn?: string
  content?: string
  contentEn?: string
  cover?: string
  author?: string
  source?: string
  articleType: string
  views?: number
  isTop?: number
  status?: number
  publishTime?: string
  createTime?: string
}

/** CMS 栏目 */
export interface CmsCategory {
  id: number
  name: string
  nameEn?: string
  code?: string
  sort?: number
}

/** 留言 / 团购咨询提交体 */
export interface MessagePayload {
  msgType: 'CONTACT' | 'GROUP'
  name?: string
  phone?: string
  company?: string
  content?: string
  city?: string
}

/* ------------------------- axios 实例 ------------------------- */

const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || '/api',
  timeout: 15000,
  headers: { 'Content-Type': 'application/json' }
})

// 响应拦截：剥离统一响应外壳，直接返回 data
http.interceptors.response.use(
  (response) => {
    const body = response.data
    if (body && typeof body === 'object' && 'code' in body) {
      if (body.code === 200) return body.data
      return Promise.reject(new Error(body.msg || '请求失败'))
    }
    return body
  },
  (error) => {
    const msg = error?.response?.data?.msg || error?.message || '网络异常，请稍后重试'
    return Promise.reject(new Error(msg))
  }
)

function get<T>(url: string, params?: Record<string, any>): Promise<T> {
  return http.get(url, { params }) as unknown as Promise<T>
}

function post<T>(url: string, data?: any): Promise<T> {
  return http.post(url, data) as unknown as Promise<T>
}

/* =========================================================
 * 站点与导航
 * ========================================================= */

/** 站点配置（站名 / logo / ICP / 客服电话等） */
export const getSiteConfig = () => get<SiteConfigMap>('/public/config')

/** 导航菜单，platform = PC / WECHAT / MINIAPP / H5 */
export const getMenus = (platform: string) => get<MenuItem[]>(`/public/menus/${platform}`)

/** Banner 列表，position = PC_HOME 等 */
export const getBanners = (position?: string) => get<Banner[]>('/public/banners', { position })

/** 多语言词条包 */
export const getI18nBundle = (langCode: string) =>
  get<Record<string, string>>(`/public/i18n/${langCode}`)

/* =========================================================
 * 商品
 * ========================================================= */

/** 商品分类（平铺） */
export const getCategories = (bizType?: string) =>
  get<ProductCategory[]>('/public/categories', bizType ? { bizType } : undefined)

/** 商品分页 */
export const getProducts = (params?: {
  categoryId?: number
  bizType?: string
  keyword?: string
  reservable?: number
  current?: number
  size?: number
}) => get<PageResult<Product>>('/public/products', params)

/** 商品详情：{ product, skus, qualifications } */
export const getProductDetail = (id: number | string) =>
  get<ProductDetail>(`/public/products/${id}`)

/** 商品规格 */
export const getProductSkus = (id: number | string) =>
  get<ProductSku[]>(`/public/products/${id}/skus`)

/* =========================================================
 * 门店
 * ========================================================= */

/** 门店列表 */
export const getStores = () => get<Store[]>('/public/stores')

/** 门店详情 */
export const getStore = (id: number | string) => get<Store>(`/public/stores/${id}`)

/* =========================================================
 * 官网 CMS
 * ========================================================= */

/** 文章分页，articleType = NEWS / BRAND / CASE / PAGE */
export const getArticles = (params?: {
  categoryId?: number
  articleType?: string
  current?: number
  size?: number
}) => get<PageResult<Article>>('/public/articles', params)

/** 文章详情（后端自动 +1 浏览量） */
export const getArticleDetail = (id: number | string) => get<Article>(`/public/articles/${id}`)

/** CMS 栏目 */
export const getCmsCategories = () => get<CmsCategory[]>('/public/cms/categories')

/* =========================================================
 * 留言 / 团购咨询
 * ========================================================= */

/** 提交留言或团购咨询 */
export const submitMessage = (payload: MessagePayload) => post<void>('/public/message', payload)

export default http
