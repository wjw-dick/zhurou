<template>
  <header class="site-header">
    <!-- 顶部信息条 -->
    <div class="top-bar">
      <div class="container top-bar__inner">
        <span class="top-bar__slogan">{{ t('common.servicePhone') }}：{{ servicePhone }}</span>
        <div class="top-bar__right">
          <router-link class="top-bar__link" to="/qualification">{{ t('nav.qualification') }}</router-link>
          <div class="lang-switch">
            <button
              class="lang-switch__btn"
              :class="{ active: lang === 'zh-CN' }"
              @click="setLang('zh-CN')"
            >
              中
            </button>
            <span class="lang-switch__split">/</span>
            <button
              class="lang-switch__btn"
              :class="{ active: lang === 'en-US' }"
              @click="setLang('en-US')"
            >
              EN
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 主导航 -->
    <div class="nav-bar">
      <div class="container nav-bar__inner">
        <!-- Logo -->
        <router-link to="/" class="brand">
          <img v-if="logo" :src="logo" class="brand__logo" :alt="siteName" />
          <span v-else class="brand__mark">猪</span>
          <span class="brand__text">
            <strong class="brand__name">{{ siteName }}</strong>
            <small class="brand__slogan">{{ slogan }}</small>
          </span>
        </router-link>

        <!-- 桌面端菜单 -->
        <nav class="nav" :class="{ 'nav--open': mobileOpen }">
          <router-link
            v-for="menu in menus"
            :key="menu.path"
            :to="menu.path"
            class="nav__item"
            @click="mobileOpen = false"
          >
            {{ menuLabel(menu) }}
          </router-link>

          <!-- 移动端附带的语言切换 -->
          <div class="nav__mobile-lang">
            <button :class="{ active: lang === 'zh-CN' }" @click="setLang('zh-CN')">中文</button>
            <button :class="{ active: lang === 'en-US' }" @click="setLang('en-US')">English</button>
          </div>
        </nav>

        <div class="nav-bar__tools">
          <router-link to="/products" class="cart">
            <span class="cart__icon">🛒</span>
            <span class="cart__text">购物车</span>
            <em v-if="cartCount > 0" class="cart__badge">{{ cartCount }}</em>
          </router-link>
          <button class="hamburger" :class="{ 'is-open': mobileOpen }" @click="mobileOpen = !mobileOpen">
            <i></i><i></i><i></i>
          </button>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { getMenus, type MenuItem } from '@/api'
import { isEn, lang, setLang, t } from '@/store/lang'
import { siteValue } from '@/store/site'
import { cartCount } from '@/store/cart'

/** 本地兜底菜单（与后端 PC 平台菜单一致） */
const fallbackMenus: MenuItem[] = [
  { id: 90001, parentId: 0, platform: 'PC', menuType: 'LINK', name: '首页', nameEn: 'Home', path: '/' },
  { id: 90002, parentId: 0, platform: 'PC', menuType: 'LINK', name: '品牌故事', nameEn: 'Brand', path: '/brand' },
  { id: 90003, parentId: 0, platform: 'PC', menuType: 'LINK', name: '产品展示', nameEn: 'Products', path: '/products' },
  { id: 90004, parentId: 0, platform: 'PC', menuType: 'LINK', name: '门店导航', nameEn: 'Stores', path: '/stores' },
  { id: 90005, parentId: 0, platform: 'PC', menuType: 'LINK', name: '新闻资讯', nameEn: 'News', path: '/news' },
  { id: 90006, parentId: 0, platform: 'PC', menuType: 'LINK', name: '联系我们', nameEn: 'Contact', path: '/contact' }
]

const menus = ref<MenuItem[]>([...fallbackMenus])
const mobileOpen = ref(false)

const siteName = computed(() => siteValue('site.name', '猪事大吉'))
const logo = computed(() => siteValue('site.logo', ''))
const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))
const slogan = computed(() =>
  isEn.value ? 'Fresh Meat & Hotpot' : '社区鲜肉 · 火锅食材 · 肉制品'
)

/** 菜单文案：英文语言优先取后端 nameEn */
function menuLabel(menu: MenuItem) {
  return isEn.value && menu.nameEn ? menu.nameEn : menu.name
}

onMounted(async () => {
  try {
    const list = await getMenus('PC')
    if (list && list.length) {
      // 只保留可见的链接型菜单，并按 sort 排序
      menus.value = list
        .filter((m) => m.status !== 0 && m.visible !== 0 && m.path)
        .sort((a, b) => (a.sort || 0) - (b.sort || 0))
    }
  } catch (e) {
    // 拉取失败保留本地兜底菜单
    menus.value = [...fallbackMenus]
  }
})
</script>

<style scoped>
.site-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: #fff;
  box-shadow: 0 2px 12px rgba(24, 28, 35, 0.06);
}

/* ---- 顶部信息条 ---- */
.top-bar {
  background: linear-gradient(90deg, var(--brand-red-dark), var(--brand-red));
  color: rgba(255, 255, 255, 0.9);
  font-size: 13px;
}

.top-bar__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 34px;
}

.top-bar__slogan {
  letter-spacing: 0.5px;
}

.top-bar__right {
  display: flex;
  align-items: center;
  gap: 18px;
}

.top-bar__link {
  transition: var(--transition);
}

.top-bar__link:hover {
  color: var(--brand-gold-light);
}

.lang-switch {
  display: flex;
  align-items: center;
  gap: 6px;
}

.lang-switch__btn {
  padding: 0 6px;
  color: rgba(255, 255, 255, 0.72);
  font-size: 13px;
  border-radius: 4px;
  transition: var(--transition);
}

.lang-switch__btn.active,
.lang-switch__btn:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.18);
}

.lang-switch__split {
  color: rgba(255, 255, 255, 0.4);
}

/* ---- 主导航 ---- */
.nav-bar__inner {
  display: flex;
  align-items: center;
  height: var(--header-height);
  gap: 24px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}

.brand__logo {
  height: 44px;
  width: auto;
}

.brand__mark {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  color: #fff;
  font-size: 22px;
  font-weight: 800;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-gold));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.28);
}

.brand__text {
  display: flex;
  flex-direction: column;
  line-height: 1.15;
}

.brand__name {
  font-size: 19px;
  font-weight: 800;
  letter-spacing: 2px;
  color: var(--text-main);
}

.brand__slogan {
  font-size: 11px;
  color: var(--text-muted);
  letter-spacing: 0.5px;
}

.nav {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-left: auto;
}

.nav__item {
  position: relative;
  padding: 10px 16px;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-sub);
  border-radius: 999px;
  transition: var(--transition);
}

.nav__item:hover {
  color: var(--brand-red);
  background: rgba(200, 22, 29, 0.06);
}

.nav__item.router-link-active {
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.26);
}

.nav__mobile-lang {
  display: none;
}

.nav-bar__tools {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}

.cart {
  position: relative;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 999px;
  font-size: 14px;
  font-weight: 600;
  color: var(--brand-red);
  background: rgba(200, 22, 29, 0.07);
  transition: var(--transition);
}

.cart:hover {
  background: rgba(200, 22, 29, 0.13);
}

.cart__badge {
  min-width: 18px;
  height: 18px;
  padding: 0 4px;
  border-radius: 999px;
  background: var(--brand-red);
  color: #fff;
  font-size: 11px;
  font-style: normal;
  line-height: 18px;
  text-align: center;
}

.hamburger {
  display: none;
  flex-direction: column;
  gap: 5px;
  padding: 8px;
}

.hamburger i {
  display: block;
  width: 22px;
  height: 2px;
  border-radius: 2px;
  background: var(--text-main);
  transition: var(--transition);
}

/* ---- 响应式 ---- */
@media (max-width: 900px) {
  .nav {
    position: absolute;
    left: 0;
    right: 0;
    top: 100%;
    flex-direction: column;
    align-items: stretch;
    gap: 0;
    padding: 10px 14px 16px;
    background: #fff;
    border-top: 1px solid var(--border-color);
    box-shadow: 0 16px 24px rgba(24, 28, 35, 0.1);
    transform: translateY(-12px);
    opacity: 0;
    visibility: hidden;
    transition: var(--transition);
  }

  .nav--open {
    transform: translateY(0);
    opacity: 1;
    visibility: visible;
  }

  .nav__item {
    padding: 13px 10px;
    border-radius: 10px;
    border-bottom: 1px solid var(--border-color);
  }

  .nav__mobile-lang {
    display: flex;
    gap: 10px;
    padding-top: 14px;
  }

  .nav__mobile-lang button {
    flex: 1;
    padding: 9px;
    border-radius: 10px;
    border: 1px solid var(--border-color);
    font-size: 14px;
    color: var(--text-sub);
  }

  .nav__mobile-lang button.active {
    color: #fff;
    border-color: transparent;
    background: var(--brand-red);
  }

  .hamburger {
    display: flex;
  }

  .cart__text {
    display: none;
  }

  .top-bar__slogan {
    max-width: 55vw;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .brand__slogan {
    display: none;
  }
}
</style>
