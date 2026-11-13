/**
 * 新增 / 编辑资质与检疫证明
 * 详情：GET  /api/supplier/qualification/{id}（编辑时）
 * 保存：POST /api/supplier/qualification（新增） / PUT /api/supplier/qualification（修改）
 * 图片：POST /api/oss/file/upload（字段名 file，返回 url），上传后回填 fileUrl
 */
const http = require('../../utils/request')
const auth = require('../../utils/auth')

const QUAL_TYPES = [
  { label: '动物产品检疫合格证明', value: 'QUARANTINE' },
  { label: '肉品品质检验合格证', value: 'QUALITY' },
  { label: '食品生产许可（SC）', value: 'SC' },
  { label: '营业执照', value: 'BUSINESS' },
  { label: '检测报告', value: 'INSPECTION' }
]

Page({
  data: {
    id: '',
    isEdit: false,
    qualTypes: QUAL_TYPES,
    qualTypeIndex: 0,
    form: {
      qualType: 'QUARANTINE',
      qualNo: '',
      fileUrl: '',
      issueDate: '',
      expireDate: ''
    },
    submitting: false
  },

  onLoad(options) {
    if (!auth.requireLogin()) return
    if (options.id) {
      this.setData({ id: options.id, isEdit: true })
      wx.setNavigationBarTitle({ title: '编辑资质' })
      this.loadDetail()
    } else {
      wx.setNavigationBarTitle({ title: '新增资质' })
    }
  },

  loadDetail() {
    http
      .get('/supplier/qualification/' + this.data.id, {}, { loading: true, loadingText: '加载中' })
      .then((detail) => {
        if (!detail) return
        const index = QUAL_TYPES.findIndex((t) => t.value === detail.qualType)
        this.setData({
          qualTypeIndex: index < 0 ? 0 : index,
          form: {
            qualType: detail.qualType || 'QUARANTINE',
            qualNo: detail.qualNo || '',
            fileUrl: detail.fileUrl || '',
            issueDate: detail.issueDate || '',
            expireDate: detail.expireDate || ''
          }
        })
      })
      .catch(() => {})
  },

  onQualTypeChange(e) {
    const index = Number(e.detail.value)
    this.setData({
      qualTypeIndex: index,
      'form.qualType': QUAL_TYPES[index].value
    })
  },

  onInput(e) {
    const field = e.currentTarget.dataset.field
    this.setData({ ['form.' + field]: e.detail.value })
  },

  onDateChange(e) {
    const field = e.currentTarget.dataset.field
    this.setData({ ['form.' + field]: e.detail.value })
  },

  /** 选择图片并上传到 OSS，回填 fileUrl */
  onChooseImage() {
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sourceType: ['album', 'camera'],
      success: (res) => {
        const filePath = res.tempFiles[0].tempFilePath
        http
          .uploadFile(filePath, 'supplier-qualification')
          .then((file) => {
            // 后端返回 { url, filePath, fileName ... }
            this.setData({ 'form.fileUrl': file.url || file.filePath || '' })
            wx.showToast({ title: '上传成功', icon: 'success' })
          })
          .catch(() => {})
      }
    })
  },

  onPreviewImage() {
    if (this.data.form.fileUrl) {
      wx.previewImage({ urls: [this.data.form.fileUrl], current: this.data.form.fileUrl })
    }
  },

  onSave() {
    const form = this.data.form
    if (!form.qualType) {
      wx.showToast({ title: '请选择资质类型', icon: 'none' })
      return
    }
    if (!form.fileUrl) {
      wx.showToast({ title: '请上传资质图片', icon: 'none' })
      return
    }
    if (this.data.submitting) return
    this.setData({ submitting: true })

    const payload = Object.assign({}, form, { supplierId: auth.getSupplierId() })
    const req = this.data.isEdit
      ? http.put('/supplier/qualification', Object.assign({ id: this.data.id }, payload))
      : http.post('/supplier/qualification', payload)

    req
      .then(() => {
        wx.showToast({ title: '保存成功', icon: 'success' })
        setTimeout(() => wx.navigateBack(), 700)
      })
      .catch(() => {})
      .then(() => this.setData({ submitting: false }))
  }
})
