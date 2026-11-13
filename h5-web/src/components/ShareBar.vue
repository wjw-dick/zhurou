<script setup lang="ts">
/**
 * 分享引导条：用于分享落地页（商品详情等）
 * 「分享给好友」为占位按钮：微信内使用 JS-SDK 分享，其余环境复制当前链接
 */
import { toast } from '@/api'

const props = withDefaults(
  defineProps<{
    title?: string
    desc?: string
    link?: string
    /** 底部偏移（px），当页面同时存在底部导航时传入 54 避免遮挡 */
    offset?: number
  }>(),
  { title: '猪事大吉', desc: '', link: '', offset: 0 }
)

async function onShare() {
  const link = props.link || window.location.href
  const nav = navigator as any
  if (nav.share) {
    try {
      await nav.share({ title: props.title, text: props.desc, url: link })
      return
    } catch {
      // 用户取消或分享失败，走复制逻辑
    }
  }
  try {
    await navigator.clipboard.writeText(link)
    toast('链接已复制，快去分享给好友吧')
  } catch {
    toast('请点击浏览器右上角「分享」发送给好友')
  }
}
</script>

<template>
  <div class="share-bar" :style="{ bottom: `${props.offset}px` }">
    <div class="share-info">
      <p class="share-title">{{ props.title || '猪事大吉' }}</p>
      <p class="share-desc">{{ props.desc || '好肉好汤，火锅到家' }}</p>
    </div>
    <slot />
    <button class="share-btn" @click="onShare">分享给好友</button>
  </div>
</template>

<style scoped>
.share-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 110;
  display: flex;
  align-items: center;
  gap: 10px;
  max-width: 750px;
  margin: 0 auto;
  padding: 8px 12px calc(8px + env(safe-area-inset-bottom));
  background: #fff;
  border-top: 1px solid var(--zs-border);
}

.share-info {
  flex: 1;
  min-width: 0;
}

.share-title {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.share-desc {
  margin: 2px 0 0;
  font-size: 11px;
  color: var(--zs-text-gray);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.share-btn {
  flex: none;
  height: 36px;
  padding: 0 18px;
  border-radius: 18px;
  color: #fff;
  font-size: 14px;
  background: var(--zs-primary);
}
</style>
