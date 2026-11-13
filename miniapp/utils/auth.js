/**
 * 登录与会员信息管理
 *
 * 【微信登录真实流程（上线必读）】
 * 1) 小程序调用 wx.login() 获取临时登录凭证 code（有效期 5 分钟、一次性）。
 * 2) 小程序把 code 发送给「自己的后端」。
 * 3) 后端拿 code + appid + appSecret 调
 *    https://api.weixin.qq.com/sns/jscode2session?appid=&secret=&js_code=&grant_type=authorization_code
 *    换取 openid / unionid / session_key（appSecret 严禁放在小程序端）。
 * 4) 后端用 openid 查询会员，不存在则自动注册，然后把会员信息（含业务 token）返回小程序。
 *
 * 【本项目现状】
 * 后端公开接口 /public/login 的契约是直接接收 { openid, unionid, nickname, avatar, phone }。
 * 小程序端无法自行把 code 换成 openid，因此这里用 code 作为 openid 的「占位值」，
 * 仅用于前后端联调跑通链路。
 * ⚠️ 上线前请由后端改造为「接收 code -> 服务端换 openid」，小程序端不要再传 code 当 openid。
 */
const request = require('./request.js')
const config = require('../config.js')

/** 读取本地缓存的会员 */
function getMember() {
  try {
    return wx.getStorageSync(config.storageKeys.member) || null
  } catch (e) {
    return null
  }
}

/** 写入本地缓存的会员 */
function setMember(member) {
  try {
    wx.setStorageSync(config.storageKeys.member, member || null)
    if (member && member.id) {
      wx.setStorageSync(config.storageKeys.memberId, member.id)
    }
    if (member && member.token) {
      wx.setStorageSync(config.storageKeys.token, member.token)
    }
  } catch (e) {}
}

/** 获取会员 ID */
function getMemberId() {
  const member = getMember()
  if (member && member.id) return member.id
  try {
    return wx.getStorageSync(config.storageKeys.memberId) || null
  } catch (e) {
    return null
  }
}

/** 清除登录态 */
function clearLogin() {
  try {
    wx.removeStorageSync(config.storageKeys.member)
    wx.removeStorageSync(config.storageKeys.memberId)
    wx.removeStorageSync(config.storageKeys.token)
  } catch (e) {}
}

/** 获取 wx.login 的 code（Promise 化） */
function wxLogin() {
  return new Promise((resolve, reject) => {
    wx.login({
      success(res) {
        if (res && res.code) resolve(res.code)
        else reject(new Error('wx.login 未返回 code'))
      },
      fail: reject
    })
  })
}

/**
 * 登录：wx.login 拿 code -> 调后端 /public/login -> 缓存会员
 * @param {object} profile 可选，用户授权信息 { nickname, avatar, phone }
 * @returns {Promise<Object>} Member
 */
function login(profile) {
  const extra = profile || {}
  return wxLogin().then(code => {
    // ⚠️ 占位：真实项目应改为 request.post('/public/wx/login', { code })
    const body = {
      openid: code,             // TODO 上线改为由后端用 code 换取 openid
      unionid: '',
      nickname: extra.nickname || '微信用户',
      avatar: extra.avatar || '',
      phone: extra.phone || ''
    }
    return request.post('/public/login', body, { hideError: true }).then(member => {
      setMember(member)
      return member
    })
  })
}

/**
 * 确保已登录：有缓存会员直接返回，否则触发登录
 * @returns {Promise<Object>}
 */
function ensureLogin() {
  const cached = getMember()
  if (cached && cached.id) {
    return Promise.resolve(cached)
  }
  return login()
}

/**
 * 刷新会员信息：GET /public/member/{id}
 */
function refreshMember() {
  const id = getMemberId()
  if (!id) return Promise.reject(new Error('未登录'))
  return request.get('/public/member/' + id).then(member => {
    // 合并 token，避免覆盖
    const old = getMember() || {}
    setMember(Object.assign({}, old, member))
    return member
  })
}

module.exports = {
  getMember,
  setMember,
  getMemberId,
  clearLogin,
  login,
  ensureLogin,
  refreshMember
}
