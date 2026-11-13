/**
 * 通用格式化工具
 */

/** 金额格式化：保留两位小数 */
function money(val) {
  const n = Number(val)
  if (isNaN(n)) return '0.00'
  return n.toFixed(2)
}

/** 日期格式化：支持 Date / 时间戳 / 日期字符串 -> yyyy-MM-dd */
function date(val) {
  if (!val) return ''
  const d = val instanceof Date ? val : new Date(String(val).replace(/-/g, '/'))
  if (isNaN(d.getTime())) return String(val)
  return formatYmd(d)
}

/** 格式化为 yyyy-MM-dd */
function formatYmd(d) {
  const y = d.getFullYear()
  const m = ('0' + (d.getMonth() + 1)).slice(-2)
  const day = ('0' + d.getDate()).slice(-2)
  return y + '-' + m + '-' + day
}

/** 日期时间格式化：yyyy-MM-dd HH:mm */
function dateTime(val) {
  if (!val) return ''
  const d = val instanceof Date ? val : new Date(String(val).replace(/-/g, '/'))
  if (isNaN(d.getTime())) return String(val)
  const hh = ('0' + d.getHours()).slice(-2)
  const mm = ('0' + d.getMinutes()).slice(-2)
  return formatYmd(d) + ' ' + hh + ':' + mm
}

/** 兼容后端分页对象（MyBatis-Plus Page: { records, total, current, size }）与纯数组 */
function pageList(res) {
  if (!res) return []
  if (Array.isArray(res)) return res
  return res.records || res.list || res.rows || []
}

/** 分页总数 */
function pageTotal(res) {
  if (!res || Array.isArray(res)) return 0
  return res.total || 0
}

/** 订单状态中文 */
const ORDER_STATUS = {
  UNPAID: '待支付',
  PREPARING: '待备货',
  READY: '待取货',
  DELIVERING: '配送中',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
  AFTERSALE: '售后中'
}

function orderStatus(status) {
  return ORDER_STATUS[status] || status || ''
}

/** 订单状态对应标签颜色类 */
function orderStatusClass(status) {
  if (status === 'UNPAID') return 'tag-red'
  if (status === 'DELIVERING') return 'tag-gold'
  if (status === 'COMPLETED') return 'tag-gray'
  if (status === 'CANCELLED') return 'tag-gray'
  if (status === 'AFTERSALE') return 'tag-red'
  return 'tag-green'
}

/** 分割方式中文 */
const SPLIT_TYPE = {
  NONE: '不分割',
  CUBE: '切块',
  MINCED: '绞肉',
  SLICED: '切片'
}

function splitType(type) {
  return SPLIT_TYPE[type] || '不分割'
}

/** 配送方式中文 */
function deliveryType(type) {
  if (type === 'DELIVERY') return '门店配送'
  if (type === 'SELF_PICKUP') return '到店自提'
  return type || ''
}

/** 商品品类中文 */
const BIZ_TYPE = {
  PORK: '鲜猪肉',
  HOTPOT: '火锅食材',
  PROCESSED: '肉制品',
  BASE: '底料蘸料',
  SET: '套餐礼盒'
}

function bizType(type) {
  return BIZ_TYPE[type] || type || ''
}

/** 资质类型中文 */
const QUAL_TYPE = {
  QUARANTINE: '动物产品检疫合格证明',
  QUALITY: '肉品品质检验合格证',
  SC: '食品生产许可',
  INSPECTION: '检测报告',
  BUSINESS: '营业执照'
}

function qualType(type) {
  return QUAL_TYPE[type] || type || ''
}

/** 资质类型短标签 */
function qualTypeShort(type) {
  const map = {
    QUARANTINE: '检疫合格',
    QUALITY: '品质检验',
    SC: '生产许可',
    INSPECTION: '检测报告',
    BUSINESS: '营业执照'
  }
  return map[type] || '资质'
}

module.exports = {
  money,
  date,
  dateTime,
  formatYmd,
  pageList,
  pageTotal,
  orderStatus,
  orderStatusClass,
  splitType,
  deliveryType,
  bizType,
  qualType,
  qualTypeShort,
  ORDER_STATUS,
  SPLIT_TYPE,
  BIZ_TYPE,
  QUAL_TYPE
}
