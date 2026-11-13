/**
 * 我的佣金规则（只读）
 * GET /api/channel/rule/page?current=&size=&channelId=<我的渠道ID>
 * 字段：name / bizType 适用品类 / ruleType RATE按比例 FIXED固定金额 / rate 比例(%) / fixedAmount 固定佣金
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const BIZ_TYPE_LABEL = {
  PORK: '鲜猪肉',
  HOTPOT: '火锅食材',
  PROCESSED: '肉制品',
  BASE: '底料蘸料',
  SET: '套餐礼盒'
}

Page({
  data: {
    list: [],
    loading: false
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.load()
  },

  onPullDownRefresh() {
    this.load().then(() => wx.stopPullDownRefresh())
  },

  load() {
    this.setData({ loading: true })
    return http
      .get('/channel/rule/page', { current: 1, size: 50, channelId: auth.getChannelId() })
      .then((page) => {
        const records = (page && page.records) || []
        // WXML 不支持方法调用，这里先加工好展示文本
        const list = records.map((item) => ({
          id: item.id,
          name: item.name || '佣金规则',
          bizTypeText: item.bizType ? BIZ_TYPE_LABEL[item.bizType] || item.bizType : '全部品类',
          ruleTypeText: item.ruleType === 'FIXED' ? '固定金额' : '按比例',
          ruleText: item.ruleType === 'FIXED' ? '¥' + (item.fixedAmount || 0) : (item.rate || 0) + '%',
          levelText: item.level ? '第' + item.level + '级' : '不限层级',
          statusText: item.status === 0 ? '已停用' : '生效中'
        }))
        this.setData({ list })
      })
      .catch(() => this.setData({ list: [] }))
      .then(() => this.setData({ loading: false }))
  }
})
