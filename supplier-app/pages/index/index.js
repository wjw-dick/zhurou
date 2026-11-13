/**
 * 工作台
 * 汇总数据（内部接口，需 token）：
 *   待处理供货单：GET /supplier/purchase/page?status=CREATED&current=1&size=1 → data.total
 *   待上传资质：  GET /supplier/qualification/page?auditStatus=PENDING&current=1&size=1 → data.total
 *   本月结算：    GET /supplier/settlement/page?current=1&size=100 → 汇总当月金额
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

Page({
  data: {
    user: {},
    supplierId: '',
    loading: false,
    // 汇总卡片
    pendingPurchase: 0,
    pendingQualification: 0,
    monthSettleAmount: '0.00',
    monthPaidAmount: '0.00'
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.setData({
      user: auth.getUserInfo() || {},
      supplierId: auth.getSupplierId()
    })
    this.loadStats()
  },

  onPullDownRefresh() {
    this.loadStats().then(() => wx.stopPullDownRefresh())
  },

  /** 待处理供货单数量 */
  loadPurchaseCount() {
    return http
      .get(
        '/supplier/purchase/page',
        { current: 1, size: 1, status: 'CREATED', supplierId: this.data.supplierId },
        { showError: false }
      )
      .then((page) => page && page.total ? page.total : 0)
      .catch(() => 0)
  },

  /** 待审核 / 待上传资质数量 */
  loadQualificationCount() {
    return http
      .get(
        '/supplier/qualification/page',
        { current: 1, size: 1, auditStatus: 'PENDING', supplierId: this.data.supplierId },
        { showError: false }
      )
      .then((page) => page && page.total ? page.total : 0)
      .catch(() => 0)
  },

  /** 本月结算金额：按对账期间与当前月份有交集汇总 amount / paidAmount */
  loadSettlement() {
    return http
      .get(
        '/supplier/settlement/page',
        { current: 1, size: 100, supplierId: this.data.supplierId },
        { showError: false }
      )
      .then((page) => {
        const records = (page && page.records) || []
        const now = new Date()
        const monthStart = new Date(now.getFullYear(), now.getMonth(), 1)
        const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0)
        let amount = 0
        let paid = 0
        records.forEach((item) => {
          const start = item.periodStart ? new Date(item.periodStart) : null
          const end = item.periodEnd ? new Date(item.periodEnd) : null
          const inMonth = (!start || start <= monthEnd) && (!end || end >= monthStart)
          if (inMonth) {
            amount += Number(item.amount || 0)
            paid += Number(item.paidAmount || 0)
          }
        })
        return { amount: amount.toFixed(2), paid: paid.toFixed(2) }
      })
      .catch(() => ({ amount: '0.00', paid: '0.00' }))
  },

  loadStats() {
    this.setData({ loading: true })
    return Promise.all([this.loadPurchaseCount(), this.loadQualificationCount(), this.loadSettlement()])
      .then((res) => {
        this.setData({
          pendingPurchase: res[0],
          pendingQualification: res[1],
          monthSettleAmount: res[2].amount,
          monthPaidAmount: res[2].paid
        })
      })
      .then(() => this.setData({ loading: false }))
  },

  goPurchase() {
    wx.switchTab({ url: '/pages/purchase/list' })
  },

  goDelivery() {
    wx.switchTab({ url: '/pages/delivery/list' })
  },

  goSettlement() {
    wx.switchTab({ url: '/pages/settlement/list' })
  },

  goQualification() {
    wx.navigateTo({ url: '/pages/qualification/list' })
  }
})
