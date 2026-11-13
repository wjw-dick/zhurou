/**
 * 通用网页容器（web-view）
 * 用途：公众号菜单跳转、关于我们、活动落地页、文章详情等。
 *
 * 使用方式：/pages/webview/index?url=<encodeURIComponent 后的完整地址>&title=标题
 *
 * ⚠️ 说明：
 * 1. web-view 只能加载 https 页面，且域名必须在「微信公众平台 -> 开发管理 ->
 *    业务域名」中配置并上传校验文件，否则真机无法打开。
 * 2. 开发者工具中可在「本地设置」勾选「不校验合法域名…」临时放行。
 * 3. 页面内如需与小程序通信，可使用 wx.miniProgram.postMessage（需在 H5 侧引入 JSSDK）。
 */
const config = require('../../config.js')

Page({
  data: {
    url: ''
  },

  onLoad(options) {
    let url = options.url ? decodeURIComponent(options.url) : ''
    if (!url) {
      url = config.defaultWebUrl
    }
    this.setData({ url: url })

    if (options.title) {
      wx.setNavigationBarTitle({ title: decodeURIComponent(options.title) })
    }

    // 非 https 时给出提示（真机 web-view 仅支持 https）
    if (url && url.indexOf('https://') !== 0) {
      wx.showToast({ title: 'web-view 需使用 https 地址', icon: 'none' })
    }
  },

  /** 接收网页消息（可选） */
  onMessage(e) {
    console.log('web-view message:', e.detail && e.detail.data)
  }
})
