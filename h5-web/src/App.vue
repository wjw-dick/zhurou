<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import BottomNav from '@/components/BottomNav.vue'

const route = useRoute()

// 404 等页面不显示底部导航
const showNav = computed(() => route.meta.hideNav !== true)
</script>

<template>
  <div class="app">
    <!-- 移动端优先：内容区最大宽度 750px 居中 -->
    <div class="app-body" :class="{ 'with-nav': showNav }">
      <router-view v-slot="{ Component }">
        <component :is="Component" />
      </router-view>
    </div>
    <BottomNav v-if="showNav" />
  </div>
</template>

<style>
:root {
  /* 主色：中国红 */
  --zs-primary: #c8161d;
  --zs-primary-light: #e8434a;
  --zs-text: #222;
  --zs-text-gray: #888;
  --zs-bg: #f6f6f8;
  --zs-border: #eee;
}

* {
  box-sizing: border-box;
  -webkit-tap-highlight-color: transparent;
}

html,
body {
  margin: 0;
  padding: 0;
  background: var(--zs-bg);
  color: var(--zs-text);
  font-size: 14px;
  font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', 'Helvetica Neue', 'Microsoft YaHei', sans-serif;
}

a {
  color: inherit;
  text-decoration: none;
}

img {
  display: block;
  max-width: 100%;
}

button {
  font-family: inherit;
  border: none;
  outline: none;
  background: none;
}

.app {
  min-height: 100vh;
}

/* 750px 居中容器 */
.app-body {
  max-width: 750px;
  margin: 0 auto;
  min-height: 100vh;
  background: #fff;
  padding-bottom: 8px;
}

.app-body.with-nav {
  padding-bottom: 62px;
}

/* 通用卡片 / 标题 / 按钮 */
.zs-card {
  background: #fff;
  border-radius: 10px;
  padding: 12px;
  margin: 10px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.zs-section-title {
  display: flex;
  align-items: center;
  font-size: 16px;
  font-weight: 600;
  margin: 14px 12px 8px;
}

.zs-section-title::before {
  content: '';
  width: 4px;
  height: 15px;
  border-radius: 2px;
  background: var(--zs-primary);
  margin-right: 6px;
}

.zs-btn {
  display: block;
  width: 100%;
  height: 42px;
  line-height: 42px;
  text-align: center;
  border-radius: 21px;
  font-size: 15px;
  color: #fff;
  background: var(--zs-primary);
}

.zs-btn.plain {
  color: var(--zs-primary);
  background: #fff;
  border: 1px solid var(--zs-primary);
}

.zs-empty {
  padding: 40px 0;
  text-align: center;
  color: var(--zs-text-gray);
  font-size: 13px;
}

.zs-price {
  color: var(--zs-primary);
  font-weight: 600;
}

.zs-price::before {
  content: '¥';
  font-size: 0.8em;
  margin-right: 1px;
}

/* 轻量 toast */
.zhushi-toast {
  position: fixed;
  left: 50%;
  top: 45%;
  z-index: 9999;
  transform: translate(-50%, -50%);
  max-width: 70%;
  padding: 9px 14px;
  border-radius: 6px;
  background: rgba(0, 0, 0, 0.75);
  color: #fff;
  font-size: 13px;
  text-align: center;
  word-break: break-all;
}
</style>
