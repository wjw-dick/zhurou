<script setup lang="ts">
/** 404 页面 */
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<template>
  <div class="not-found">
    <p class="code">404</p>
    <p class="tip">页面走丢了，看看首页的好肉吧</p>
    <button class="zs-btn back" @click="router.replace('/')">返回首页</button>
  </div>
</template>

<style scoped>
.not-found {
  padding: 100px 40px 0;
  text-align: center;
}

.code {
  margin: 0;
  font-size: 64px;
  font-weight: 700;
  color: var(--zs-primary);
}

.tip {
  margin: 10px 0 30px;
  font-size: 13px;
  color: var(--zs-text-gray);
}

.back {
  max-width: 200px;
  margin: 0 auto;
}
</style>
