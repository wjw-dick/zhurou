/**
 * 统一网络请求（渠道商端，所有接口均需登录）
 *
 * 鉴权说明：
 *   1. 登录接口为 POST /api/auth/login，body { username, password }，返回 { token, expiresIn, userInfo, roles, perms }
 *      账号密码由后台「系统管理 - 用户管理」创建并绑定渠道商（userInfo.channelId），渠道商端不支持自助注册。
 *   2. 除登录外所有内部接口都需要在请求头带上 token：
 *      Authorization: Bearer <token>
 *   3. 统一响应体 { code, msg, data }，code === 200 表示成功；401 / 未登录时清除登录态并回到登录页。
 */
const config = require('../config')
const auth = require('./auth')

function request(options) {
  const {
    url,
    method = 'GET',
    data = {},
    loading = false,
    loadingText = '加载中',
    showError = true
  } = options

  if (loading) wx.showLoading({ title: loadingText, mask: true })

  // 鉴权头：登录后统一携带 Bearer token
  const header = { 'Content-Type': 'application/json' }
  const token = auth.getToken()
  if (token) header.Authorization = 'Bearer ' + token

  return new Promise((resolve, reject) => {
    wx.request({
      url: config.baseUrl + url,
      method,
      data,
      header,
      success(res) {
        const body = res.data || {}
        if (res.statusCode === 401 || body.code === 401) {
          handleUnauthorized()
          reject(new Error(body.msg || '登录已失效'))
          return
        }
        if (body.code === 200) {
          resolve(body.data)
          return
        }
        if (showError) {
          wx.showToast({ title: body.msg || '请求失败', icon: 'none' })
        }
        reject(new Error(body.msg || '请求失败'))
      },
      fail(err) {
        if (showError) {
          wx.showToast({ title: '网络异常，请稍后重试', icon: 'none' })
        }
        reject(err)
      },
      complete() {
        if (loading) wx.hideLoading()
      }
    })
  })
}

/** 登录态失效：清理并回到登录页 */
function handleUnauthorized() {
  auth.clearAuth()
  wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' })
  setTimeout(() => auth.toLogin(), 800)
}

module.exports = {
  request,
  get: (url, data, options) => request(Object.assign({ url, method: 'GET', data }, options)),
  post: (url, data, options) => request(Object.assign({ url, method: 'POST', data }, options)),
  put: (url, data, options) => request(Object.assign({ url, method: 'PUT', data }, options)),
  del: (url, data, options) => request(Object.assign({ url, method: 'DELETE', data }, options))
}
