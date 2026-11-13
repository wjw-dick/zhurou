<script setup lang="ts">
/**
 * 首页（活动落地页）
 * Banner：GET /public/banners?position=H5
 * 热销商品：GET /public/products?current=1&size=6
 */
import { onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getBanners, getProducts, type BannerItem, type ProductItem } from '@/api'

const router = useRouter()

const banners = ref<BannerItem[]>([])
const products = ref<ProductItem[]>([])
const loading = ref(false)
const bannerIndex = ref(0)
let timer: number | undefined

function goProduct(id: number) {
  router.push(`/product/${id}`)
}

async function loadBanners() {
  try {
    banners.value = (await getBanners('H5')) || []
  } catch {
    banners.value = []
  }
}

async function loadProducts() {
  loading.value = true
  try {
    const page = await getProducts({ current: 1, size: 6 })
    products.value = page?.records || []
  } catch {
    products.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadBanners()
  loadProducts()
  timer = window.setInterval(() => {
    if (banners.value.length > 1) {
      bannerIndex.value = (bannerIndex.value + 1) % banners.value.length
    }
  }, 4000)
})

onUnmounted(() => {
  if (timer) window.clearInterval(timer)
})
</script>

<template>
  <div class="home">
    <!-- Banner 轮播 -->
    <div class="banner">
      <div class="banner-track" :style="{ transform: `translateX(-${bannerIndex * 100}%)` }">
        <img v-for="b in banners" :key="b.id" class="banner-img" :src="b.image" :alt="b.title" />
        <div v-if="!banners.length" class="banner-img banner-placeholder">猪事大吉 · 火锅到家</div>
      </div>
      <div v-if="banners.length > 1" class="dots">
        <span v-for="(b, i) in banners" :key="b.id" class="dot" :class="{ active: i === bannerIndex }" />
      </div>
    </div>

    <!-- 商城入口 -->
    <div class="entry">
      <button class="zs-btn" @click="router.push('/combo')">进入商城</button>
      <p class="entry-tip">新鲜现切 · 冷链直送 · 火锅套餐一站式配齐</p>
    </div>

    <!-- 热销商品 -->
    <p class="zs-section-title">热销商品</p>
    <div class="goods-grid">
      <div v-for="p in products" :key="p.id" class="goods-card" @click="goProduct(p.id)">
        <img class="goods-img" :src="p.cover" :alt="p.name" />
        <p class="goods-name">{{ p.name }}</p>
        <p class="goods-sub">{{ p.subTitle || p.unit || '' }}</p>
        <p class="goods-sales" v-if="p.sales">已售 {{ p.sales }}</p>
      </div>
    </div>
    <p v-if="!loading && !products.length" class="zs-empty">暂无商品，稍后再来看看吧</p>
  </div>
</template>

<style scoped>
.banner {
  position: relative;
  overflow: hidden;
  background: #f0f0f0;
}

.banner-track {
  display: flex;
  transition: transform 0.4s ease;
}

.banner-img {
  flex: none;
  width: 100%;
  height: 180px;
  object-fit: cover;
}

.banner-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  letter-spacing: 2px;
  background: linear-gradient(135deg, var(--zs-primary), #f06a3c);
}

.dots {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 8px;
  display: flex;
  justify-content: center;
  gap: 5px;
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.6);
}

.dot.active {
  width: 14px;
  background: #fff;
}

.entry {
  padding: 12px;
}

.entry-tip {
  margin: 8px 0 0;
  text-align: center;
  font-size: 12px;
  color: var(--zs-text-gray);
}

.goods-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  padding: 0 10px;
}

.goods-card {
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.goods-img {
  width: 100%;
  height: 140px;
  object-fit: cover;
  background: #f2f2f2;
}

.goods-name {
  margin: 8px 8px 0;
  font-size: 14px;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.goods-sub {
  margin: 4px 8px 0;
  font-size: 12px;
  color: var(--zs-text-gray);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.goods-sales {
  margin: 6px 8px 10px;
  font-size: 12px;
  color: #ff8f1f;
}
</style>
