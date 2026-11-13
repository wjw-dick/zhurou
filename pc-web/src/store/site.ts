import { ref } from 'vue'
import { getSiteConfig, type SiteConfigMap } from '@/api'

/* =========================================================
 * 站点配置（GET /public/config 返回 key-value）
 * 全站只请求一次，供页头 / 页脚 / 首页使用
 * ========================================================= */

export const siteConfig = ref<SiteConfigMap>({})

let loaded = false

/** 加载站点配置（幂等） */
export async function loadSiteConfig() {
  if (loaded) return
  loaded = true
  try {
    siteConfig.value = (await getSiteConfig()) || {}
  } catch (e) {
    siteConfig.value = {}
  }
}

/** 读取站点配置项，带兜底值 */
export function siteValue(key: string, fallback = ''): string {
  return siteConfig.value[key] || fallback
}
