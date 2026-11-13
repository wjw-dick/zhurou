<template>
  <div class="page notfound">
    <div class="container notfound__inner">
      <div class="notfound__code">404</div>
      <h1 class="notfound__title">这口肉没找到</h1>
      <p class="notfound__desc">
        页面可能已下架或链接有误。<br />
        不如回首页看看今天的鲜肉，或者直接去产品展示逛逛？
      </p>

      <div class="notfound__actions">
        <router-link to="/" class="btn btn-primary">返回首页</router-link>
        <router-link to="/products" class="btn btn-ghost">产品展示</router-link>
        <router-link to="/contact" class="btn btn-ghost">联系我们</router-link>
      </div>

      <p class="notfound__phone">
        客服电话：<a :href="`tel:${servicePhone}`">{{ servicePhone }}</a>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { siteValue } from '@/store/site'

const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))
</script>

<style scoped>
.notfound__inner {
  padding: 90px 20px 110px;
  text-align: center;
}

.notfound__code {
  font-size: 120px;
  font-weight: 900;
  line-height: 1;
  letter-spacing: 8px;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-gold));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.notfound__title {
  margin: 18px 0 14px;
  font-size: 28px;
  font-weight: 800;
  letter-spacing: 2px;
}

.notfound__desc {
  color: var(--text-sub);
  line-height: 2;
}

.notfound__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 14px;
  margin: 32px 0 24px;
}

.notfound__phone {
  font-size: 13.5px;
  color: var(--text-muted);
}

.notfound__phone a {
  font-weight: 700;
  color: var(--brand-red);
}

@media (max-width: 768px) {
  .notfound__code {
    font-size: 78px;
    letter-spacing: 4px;
  }

  .notfound__title {
    font-size: 21px;
  }

  .notfound__inner {
    padding: 56px 14px 72px;
  }
}
</style>
