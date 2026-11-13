<script setup lang="ts">
/**
 * 底部导航
 * 优先从后端动态菜单拉取：GET /public/menus/H5
 * 拉取失败或无数据时使用本地兜底：首页 / 火锅套餐 / 我的
 */
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getMenus, type MenuItem } from '@/api'

interface NavItem {
  name: string
  path: string
  icon: string
}

// 本地兜底导航（与后端 H5 菜单一致）
const FALLBACK: NavItem[] = [
  { name: '首页', path: '/', icon: '🏠' },
  { name: '火锅套餐', path: '/combo', icon: '🍲' },
  { name: '我的', path: '/mine', icon: '👤' }
]

const items = ref<NavItem[]>(FALLBACK)
const route = useRoute()

/** 菜单 path 规范化：后端可能配置 'combo' 这类相对路径 */
function normalizePath(path?: string): string {
  if (!path) return '/'
  return path.startsWith('/') ? path : `/${path}`
}

function isActive(path: string): boolean {
  if (path === '/') return route.path === '/'
  return route.path === path || route.path.startsWith(`${path}/`)
}

async function loadMenus() {
  try {
    const list: MenuItem[] = await getMenus('H5')
    const menus = (list || [])
      .filter((m) => m && m.path && m.menuType !== 'BUTTON')
      .map((m) => ({ name: m.name, path: normalizePath(m.path), icon: m.icon || '•' }))
    items.value = menus.length ? menus : FALLBACK
  } catch {
    // 接口异常不影响浏览，使用本地兜底
    items.value = FALLBACK
  }
}

onMounted(loadMenus)
</script>

<template>
  <nav class="bottom-nav">
    <div class="bottom-nav-inner">
      <router-link v-for="item in items" :key="item.path" :to="item.path" class="nav-item" :class="{ active: isActive(item.path) }">
        <span class="nav-icon">{{ item.icon }}</span>
        <span class="nav-text">{{ item.name }}</span>
      </router-link>
    </div>
  </nav>
</template>

<style scoped>
.bottom-nav {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  background: #fff;
  border-top: 1px solid var(--zs-border);
  padding-bottom: env(safe-area-inset-bottom);
}

.bottom-nav-inner {
  display: flex;
  max-width: 750px;
  margin: 0 auto;
}

.nav-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 54px;
  color: var(--zs-text-gray);
  font-size: 11px;
}

.nav-item.active {
  color: var(--zs-primary);
}

.nav-icon {
  font-size: 18px;
  line-height: 22px;
}

.nav-text {
  line-height: 16px;
}
</style>
