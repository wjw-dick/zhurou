<template>
  <el-sub-menu v-if="hasChildren" :index="item.path">
    <template #title>
      <el-icon v-if="item.meta?.icon"><component :is="resolveIcon(item.meta.icon)" /></el-icon>
      <span>{{ item.meta?.title }}</span>
    </template>
    <SidebarItem v-for="child in visibleChildren" :key="child.path" :item="child" />
  </el-sub-menu>

  <el-menu-item v-else :index="item.path">
    <el-icon v-if="item.meta?.icon"><component :is="resolveIcon(item.meta.icon)" /></el-icon>
    <template #title>{{ item.meta?.title }}</template>
  </el-menu-item>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ item: any }>()

const visibleChildren = computed(() =>
  (props.item.children || []).filter((c: any) => !c.meta?.hidden)
)

const hasChildren = computed(() => visibleChildren.value.length > 0)

/** 图标支持 ep:xxx 形式（Element Plus 图标） */
function resolveIcon(icon?: string) {
  if (!icon) return 'Menu'
  const name = icon.startsWith('ep:') ? icon.slice(3) : icon
  const map: Record<string, string> = {
    'home-filled': 'HomeFilled',
    user: 'User',
    avatar: 'Avatar',
    menu: 'Menu',
    tools: 'Tools',
    notebook: 'Notebook',
    document: 'Document',
    files: 'Files',
    shop: 'Shop',
    goods: 'Goods',
    grid: 'Grid',
    dish: 'Dish',
    stamp: 'Stamp',
    timer: 'Timer',
    list: 'List',
    box: 'Box',
    'set-up': 'SetUp',
    tickets: 'Tickets',
    'document-copy': 'DocumentCopy',
    'refresh-left': 'RefreshLeft',
    'user-filled': 'UserFilled',
    star: 'Star',
    medal: 'Medal',
    discount: 'Discount',
    wallet: 'Wallet',
    coin: 'Coin',
    truck: 'Truck',
    'office-building': 'OfficeBuilding',
    'document-checked': 'DocumentChecked',
    calendar: 'Calendar',
    'shopping-cart': 'ShoppingCart',
    van: 'Van',
    money: 'Money',
    warning: 'Warning',
    share: 'Share',
    connection: 'Connection',
    'edit-pen': 'EditPen',
    'price-tag': 'PriceTag',
    postcard: 'Postcard',
    finished: 'Finished',
    scissor: 'Scissor',
    'scale-to-original': 'ScaleToOriginal',
    'trend-charts': 'TrendCharts',
    collection: 'Collection',
    folder: 'Folder',
    reading: 'Reading',
    picture: 'Picture',
    message: 'Message',
    'chat-line-round': 'ChatLineRound',
    bell: 'Bell',
    'data-analysis': 'DataAnalysis',
    'chat-dot-square': 'ChatDotSquare',
    setting: 'Setting'
  }
  const resolved = map[name] || name
  return resolved.charAt(0).toUpperCase() + resolved.slice(1).replace(/-([a-z])/g, (_, c) => c.toUpperCase())
}
</script>
