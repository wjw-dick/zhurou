/**
 * 登录态管理（token / 用户信息）
 * 登录接口：POST /api/auth/login（账号密码由后台创建，见 pages/login/index）
 */
const config = require('../config')

function getToken() {
  return wx.getStorageSync(config.tokenKey) || ''
}

function setToken(token) {
  wx.setStorageSync(config.tokenKey, token)
}

/** 登录用户信息：{ userId, username, nickname, userType, supplierId, roles... } */
function getUserInfo() {
  return wx.getStorageSync(config.userKey) || null
}

function setUserInfo(userInfo) {
  wx.setStorageSync(config.userKey, userInfo || null)
  const app = getApp()
  if (app) app.globalData.userInfo = userInfo || null
}

function clearAuth() {
  wx.removeStorageSync(config.tokenKey)
  wx.removeStorageSync(config.userKey)
  const app = getApp()
  if (app) app.globalData.userInfo = null
}

/** 当前登录账号关联的供应商ID（后端登录返回的 userInfo.supplierId） */
function getSupplierId() {
  const user = getUserInfo()
  return user && user.supplierId ? user.supplierId : ''
}

function isLogin() {
  return !!getToken()
}

/** 未登录跳转登录页 */
function toLogin() {
  wx.reLaunch({ url: '/pages/login/index' })
}

/** 页面守卫：未登录时跳登录并返回 false */
function requireLogin() {
  if (isLogin()) return true
  toLogin()
  return false
}

module.exports = {
  getToken,
  setToken,
  getUserInfo,
  setUserInfo,
  clearAuth,
  getSupplierId,
  isLogin,
  toLogin,
  requireLogin
}
