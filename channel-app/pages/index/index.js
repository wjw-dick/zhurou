/**
 * 工作台
 *   本月报单数 / 待审核：GET /channel/order/page?channelId=（取前 100 条统计）
 *   可提现佣金：已通过审核（APPROVED）未结算的佣金合计
 *   授信额度 / 已用额度：GET /channel/info/{channelId}
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

Page({
  data: {
    user: {},
    channelId: '',
    monthReportCount: 0,
    pendingAuditCount: 0,
    withdrawableCommission: '0.00',
    creditLimit: '0.00',
    usedCredit: '0.00',
    availableCredit: '0.00',
    loading: false,
    channel: {}
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.setData({
      user: auth.getUserInfo() || {},
      channelId: auth.getChannelId()
    })
    this.loadStats()
  },

  onPullDownRefresh() {
    this.loadStats().then(() => wx.stopPullDownRefresh())
  },

  /** 报单汇总 */
  loadReports() {
    return http
      .get(
        '/channel/order/page',
        { current: 1, size: 100, channelId: this.data.channelId },
        { showError: false }
      )
      .then((page) => {
        const records = (page && page.records) || []
        const now = new Date()
        const monthStart = new Date(now.getFullYear(), now.getMonth(), 1)
        let monthCount = 0
        let pendingCount = 0
        let commission = 0
        records.forEach((item) => {
          const created = item.createTime ? new Date(item.createTime) : null
          if (created && created >= monthStart) monthCount += 1
          if (item.status === 'SUBMITTED') pendingCount += 1
          // 已通过审核但未结算的佣金 = 可提现佣金
          if (item.status === 'APPROVED') commission += Number(item.commission || 0)
        })
        return {
          monthCount,
          pendingCount,
          commission: commission.toFixed(2)
        }
      })
      .catch(() => ({ monthCount: 0, pendingCount: 0, commission: '0.00' }))
  },

  /** 渠道信息（授信额度） */
  loadChannel() {
    if (!this.data.channelId) return Promise.resolve(null)
    return http
      .get('/channel/info/' + this.data.channelId, {}, { showError: false })
      .then((channel) => {
        if (!channel) return null
        const creditLimit = Number(channel.creditLimit || 0)
        const usedCredit = Number(channel.usedCredit || 0)
        this.setData({
          channel,
          creditLimit: creditLimit.toFixed(2),
          usedCredit: usedCredit.toFixed(2),
          availableCredit: (creditLimit - usedCredit).toFixed(2)
        })
        return channel
      })
      .catch(() => null)
  },

  loadStats() {
    this.setData({ loading: true })
    return Promise.all([this.loadReports(), this.loadChannel()])
      .then((res) => {
        this.setData({
          monthReportCount: res[0].monthCount,
          pendingAuditCount: res[0].pendingCount,
          withdrawableCommission: res[0].commission
        })
      })
      .then(() => this.setData({ loading: false }))
  },

  goCreate() {
    wx.navigateTo({ url: '/pages/report/create' })
  },

  goReport() {
    wx.switchTab({ url: '/pages/report/list' })
  },

  goOrder() {
    wx.switchTab({ url: '/pages/order/list' })
  },

  goSettlement() {
    wx.switchTab({ url: '/pages/settlement/list' })
  },

  goRule() {
    wx.navigateTo({ url: '/pages/commission/rule' })
  },

  goSub() {
    wx.navigateTo({ url: '/pages/sub/list' })
  }
})
