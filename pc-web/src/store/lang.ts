import { computed, ref } from 'vue'
import { getI18nBundle } from '@/api'

/* =========================================================
 * 多语言（轻量响应式，不依赖 pinia）
 * 词条包来自 GET /public/i18n/{langCode}，失败时使用内置兜底文案
 * ========================================================= */

export type LangCode = 'zh-CN' | 'en-US'

const STORAGE_KEY = 'zhushi_pc_lang'

/** 内置兜底词条（后端词条包不可用时的兜底，主要为导航与首页文案） */
const fallbackMessages: Record<LangCode, Record<string, string>> = {
  'zh-CN': {
    'nav.home': '首页',
    'nav.brand': '品牌故事',
    'nav.products': '产品展示',
    'nav.stores': '门店导航',
    'nav.news': '新闻资讯',
    'nav.contact': '联系我们',
    'nav.qualification': '资质证照',
    'common.lang': '语言',
    'common.zh': '中',
    'common.en': 'EN',
    'common.more': '查看更多',
    'common.detail': '查看详情',
    'common.loading': '加载中…',
    'common.empty': '暂无数据',
    'common.back': '返回',
    'common.servicePhone': '客服电话',
    'home.bannerTitle': '猪事大吉 · 诸事大吉',
    'home.bannerSub': '社区一站式鲜肉与火锅食材超市',
    'home.aboutTitle': '关于猪事大吉',
    'home.aboutText':
      '「猪事大吉」取「诸事大吉」之谐音，愿每一次下厨与相聚都顺顺利利。我们以社区门店为触点，坚持当日冷链直供的鲜肉理念：每一批猪肉均附动物产品检疫合格证明与肉品品质检验合格证，两证两章，来源可溯。',
    'home.categoryTitle': '产品分类',
    'home.categorySub': '鲜猪肉 · 火锅食材 · 肉制品 · 底料蘸料 · 套餐礼盒',
    'home.hotTitle': '热销商品',
    'home.hotSub': '街坊回头率最高的那一口',
    'home.storeTitle': '门店导航',
    'home.storeSub': '到店自提 · 门店配送 · 鲜肉预订',
    'home.newsTitle': '最新资讯',
    'home.newsSub': '品牌动态与行业资讯'
  },
  'en-US': {
    'nav.home': 'Home',
    'nav.brand': 'Brand',
    'nav.products': 'Products',
    'nav.stores': 'Stores',
    'nav.news': 'News',
    'nav.contact': 'Contact',
    'nav.qualification': 'Qualifications',
    'common.lang': 'Language',
    'common.zh': '中',
    'common.en': 'EN',
    'common.more': 'View More',
    'common.detail': 'Details',
    'common.loading': 'Loading…',
    'common.empty': 'No Data',
    'common.back': 'Back',
    'common.servicePhone': 'Hotline',
    'home.bannerTitle': 'ZhuShi DaJi · All the Best',
    'home.bannerSub': 'Community fresh meat & hotpot ingredients store',
    'home.aboutTitle': 'About ZhuShi DaJi',
    'home.aboutText':
      '"ZhuShi DaJi" sounds like "everything goes well" in Chinese. We keep the promise of same-day cold-chain fresh meat: every batch comes with animal quarantine and meat quality inspection certificates, fully traceable.',
    'home.categoryTitle': 'Categories',
    'home.categorySub': 'Fresh Pork · Hotpot · Processed Meat · Base & Sauce · Gift Sets',
    'home.hotTitle': 'Best Sellers',
    'home.hotSub': 'The favourites of our neighbours',
    'home.storeTitle': 'Our Stores',
    'home.storeSub': 'Self pick-up · Store delivery · Fresh meat reservation',
    'home.newsTitle': 'Latest News',
    'home.newsSub': 'Brand updates and industry news'
  }
}

function readStoredLang(): LangCode {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved === 'zh-CN' || saved === 'en-US') return saved
  } catch (e) {
    /* 忽略隐私模式下的存储异常 */
  }
  return 'zh-CN'
}

/** 当前语言（响应式） */
export const lang = ref<LangCode>(readStoredLang())

/** 当前词条包（响应式） */
export const messages = ref<Record<string, string>>({ ...fallbackMessages[lang.value] })

/** 是否英文 */
export const isEn = computed(() => lang.value === 'en-US')

/** 拉取词条包，失败则回退内置词条 */
export async function loadMessages(code: LangCode) {
  try {
    const bundle = await getI18nBundle(code)
    messages.value = { ...fallbackMessages[code], ...(bundle || {}) }
  } catch (e) {
    messages.value = { ...fallbackMessages[code] }
  }
}

/** 切换语言 */
export function setLang(code: LangCode) {
  if (code === lang.value) return
  lang.value = code
  try {
    localStorage.setItem(STORAGE_KEY, code)
  } catch (e) {
    /* ignore */
  }
  document.documentElement.setAttribute('lang', code)
  loadMessages(code)
}

/** 翻译：优先取后端词条包，其次内置兜底，最后返回默认值或 key */
export function t(key: string, defaultValue?: string): string {
  return messages.value[key] || fallbackMessages[lang.value][key] || defaultValue || key
}

/** 初始化（应用启动时调用一次） */
export function initLang() {
  document.documentElement.setAttribute('lang', lang.value)
  loadMessages(lang.value)
}
