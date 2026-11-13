/**
 * 网络请求封装
 *
 * 统一响应体：{ code, msg, data }
 * - code === 200：resolve(data)
 * - code !== 200：wx.showToast 弹出 msg，并 reject(整个响应体)
 * - HTTP 非 200 / 网络失败：同样 toast 提示并 reject
 *
 * 自动携带 token：请求头 Authorization: Bearer <token>（从本地缓存读取）
 *
 * 用法：
 *   const request = require('../../utils/request.js')
 *   request.get('/public/products', { size: 6 }).then(data => { ... })
 *   request.post('/public/orders', body).then(data => { ... })
 */
const config = require('../config.js')

/** 读取本地 token */
function getToken() {
  try {
    return wx.getStorageSync(config.storageKeys.token) || ''
  } catch (e) {
    return ''
  }
}

/** 统一 toast（默认 icon=none，避免图标缺失） */
function toast(msg) {
  wx.showToast({
    title: msg || '操作失败',
    icon: 'none',
    duration: 2000
  })
}

/**
 * 核心请求方法
 * @param {string} method  HTTP 方法
 * @param {string} url     以 / 开头的接口路径（不含 baseURL）
 * @param {object} data    请求参数
 * @param {object} options 可选：{ header, loading, hideError }
 * @returns {Promise<any>}
 */
function request(method, url, data, options) {
  const opts = options || {}

  return new Promise((resolve, reject) => {
    if (opts.loading) {
      wx.showLoading({ title: '加载中', mask: true })
    }

    const header = Object.assign(
      { 'Content-Type': 'application/json' },
      opts.header || {}
    )
    const token = getToken()
    if (token) {
      header.Authorization = 'Bearer ' + token
    }

    wx.request({
      url: config.baseURL + url,
      method: method,
      data: data || {},
      header: header,
      timeout: 15000,
      success(res) {
        if (opts.loading) wx.hideLoading()

        // HTTP 层异常
        if (res.statusCode !== 200) {
          if (!opts.hideError) toast('网络异常(' + res.statusCode + ')')
          reject(res)
          return
        }

        const body = res.data || {}

        // 业务层统一响应 { code, msg, data }
        if (body.code === 200) {
          resolve(body.data)
        } else {
          if (!opts.hideError) toast(body.msg || '请求失败')
          reject(body)
        }
      },
      fail(err) {
        if (opts.loading) wx.hideLoading()
        if (!opts.hideError) toast('网络连接失败，请检查网络')
        reject(err)
      }
    })
  })
}

module.exports = {
  get(url, data, options) {
    return request('GET', url, data, options)
  },
  post(url, data, options) {
    return request('POST', url, data, options)
  },
  put(url, data, options) {
    return request('PUT', url, data, options)
  },
  del(url, data, options) {
    return request('DELETE', url, data, options)
  },
  toast: toast
}
