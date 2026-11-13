<template>
  <section class="page-banner">
    <div class="container page-banner__inner">
      <h1 class="page-banner__title">{{ title }}</h1>
      <p v-if="subtitle" class="page-banner__sub">{{ subtitle }}</p>

      <!-- 面包屑 -->
      <nav class="crumbs">
        <router-link to="/">首页</router-link>
        <template v-for="crumb in crumbs" :key="crumb.label">
          <span class="crumbs__sep">/</span>
          <router-link v-if="crumb.path" :to="crumb.path">{{ crumb.label }}</router-link>
          <span v-else class="crumbs__current">{{ crumb.label }}</span>
        </template>
      </nav>
    </div>
  </section>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  subtitle?: string
  crumbs?: { label: string; path?: string }[]
}>()
</script>

<style scoped>
.page-banner {
  position: relative;
  overflow: hidden;
  color: #fff;
  background: linear-gradient(120deg, #241012 0%, var(--brand-red-dark) 55%, var(--brand-red) 100%);
}

.page-banner::after {
  content: '';
  position: absolute;
  right: -60px;
  bottom: -80px;
  width: 260px;
  height: 260px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(212, 163, 91, 0.35), transparent 70%);
}

.page-banner__inner {
  position: relative;
  z-index: 1;
  padding: 54px 20px 46px;
}

.page-banner__title {
  font-size: 34px;
  font-weight: 800;
  letter-spacing: 3px;
}

.page-banner__sub {
  margin-top: 10px;
  font-size: 15px;
  color: rgba(255, 255, 255, 0.78);
  letter-spacing: 1px;
}

.crumbs {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-top: 18px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.72);
}

.crumbs a:hover {
  color: var(--brand-gold-light);
}

.crumbs__sep {
  color: rgba(255, 255, 255, 0.35);
}

.crumbs__current {
  color: var(--brand-gold-light);
}

@media (max-width: 768px) {
  .page-banner__inner {
    padding: 36px 14px 30px;
  }

  .page-banner__title {
    font-size: 24px;
    letter-spacing: 2px;
  }
}
</style>
