/**
 * 报单
 * 提交：POST /api/channel/order
 * body：{ channelId, storeId, amount, remark }
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

Page({
  data: {
    form: {
      amount: '',
      storeId: '',
      remark: ''
    },
    submitting: false
  },

  onLoad() {
    if (!auth.requireLogin()) return
  },

  onInput(e) {
    const field = e.currentTarget.dataset.field
    this.setData({ ['form.' + field]: e.detail.value })
  },

  onAmountInput(e) {
    this.setData({ 'form.amount': e.detail.value })
  },

  onSubmit() {
    const form = this.data.form
    const amount = Number(form.amount)
    if (!form.amount || isNaN(amount) || amount <= 0) {
      wx.showToast({ title: '请输入正确的报单金额', icon: 'none' })
      return
    }
    if (!form.storeId) {
      wx.showToast({ title: '请输入门店ID', icon: 'none' })
      return
    }
    if (this.data.submitting) return
    this.setData({ submitting: true })

    http
      .post(
        '/channel/order',
        {
          channelId: auth.getChannelId(),
          storeId: form.storeId,
          amount: amount,
          remark: form.remark,
          // 提交后进入待审核
          status: 'SUBMITTED'
        },
        { loading: true, loadingText: '提交中' }
      )
      .then(() => {
        wx.showToast({ title: '报单提交成功', icon: 'success' })
        setTimeout(() => wx.navigateBack(), 800)
      })
      .catch(() => {})
      .then(() => this.setData({ submitting: false }))
  }
})
