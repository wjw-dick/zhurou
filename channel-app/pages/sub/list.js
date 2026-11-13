/**
 * 下级渠道管理
 * GET /api/channel/info/page?current=&size=&parentId=<我的渠道ID>
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const CHANNEL_TYPE_LABEL = {
  GROUP: '团购',
  DISTRIBUTOR: '分销',
  FRANCHISE: '加盟'
}

Page({
  data: {
    channelTypeLabel: CHANNEL_TYPE_LABEL,
    list: [],
    current: 1,
    size: 10,
    total: 0,
    loading: false,
    finished: false,
    channelId: ''
  },

  onShow() {
    if (!auth.requireLogin()) return
    this.setData({ channelId: auth.getChannelId() })
    this.refresh()
  },

  onPullDownRefresh() {
    this.refresh().then(() => wx.stopPullDownRefresh())
  },

  onReachBottom() {
    if (this.data.finished || this.data.loading) return
    this.load()
  },

  refresh() {
    this.setData({ list: [], current: 1, finished: false, total: 0 })
    return this.load()
  },

  load() {
    if (this.data.loading) return Promise.resolve()
    this.setData({ loading: true })
    return http
      .get('/channel/info/page', {
        current: this.data.current,
        size: this.data.size,
        parentId: this.data.channelId
      })
      .then((page) => {
        const records = (page && page.records) || []
        const list = this.data.list.concat(records)
        const total = page && page.total ? page.total : list.length
        this.setData({
          list,
          total,
          current: this.data.current + 1,
          finished: list.length >= total || records.length < this.data.size
        })
      })
      .catch(() => this.setData({ finished: true }))
      .then(() => this.setData({ loading: false }))
  }
})
