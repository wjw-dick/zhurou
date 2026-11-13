<script setup lang="ts">
/**
 * 火锅套餐页
 * 列表：GET /public/products?bizType=SET
 */
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getProducts, type ProductItem } from '@/api'

const router = useRouter()

const list = ref<ProductItem[]>([])
const loading = ref(false)
const finished = ref(false)
const current = ref(1)
const size = 10

async function load(reset = false) {
  if (loading.value) return
  if (reset) {
    current.value = 1
    finished.value = false
    list.value = []
  }
  loading.value = true
  try {
    const page = await getProducts({ bizType: 'SET', current: current.value, size })
    const records = page?.records || []
    list.value = reset ? records : [...list.value, ...records]
    if (records.length < size) finished.value = true
    else current.value += 1
  } catch {
    finished.value = true
  } finally {
    loading.value = false
  }
}

onMounted(() => load(true))
</script>

<template>
  <div class="combo">
    <div class="page-head">
      <h1 class="page-title">火锅套餐</h1>
      <p class="page-desc">精选套餐组合，荤素搭配，一键到家</p>
    </div>

    <div class="combo-list">
      <div v-for="p in list" :key="p.id" class="combo-card" @click="router.push(`/product/${p.id}`)">
        <img class="combo-img" :src="p.cover" :alt="p.name" />
        <div class="combo-info">
          <p class="combo-name">{{ p.name }}</p>
          <p class="combo-sub">{{ p.subTitle || '套餐礼盒 · 冷链配送' }}</p>
          <p class="combo-meta" v-if="p.tags">{{ p.tags }}</p>
          <div class="combo-foot">
            <span class="zs-price">{{ p.price ?? '—' }}</span>
            <span class="combo-btn">去看看</span>
          </div>
        </div>
      </div>
    </div>

    <p v-if="!loading && !list.length" class="zs-empty">暂无套餐</p>
    <p v-if="finished && list.length" class="zs-empty">— 已经到底啦 —</p>
  </div>
</template>

<style scoped>
.page-head {
  padding: 16px 12px 4px;
}

.page-title {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
}

.page-desc {
  margin: 6px 0 0;
  font-size: 12px;
  color: var(--zs-text-gray);
}

.combo-list {
  padding: 8px 10px;
}

.combo-card {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  padding: 10px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.combo-img {
  flex: none;
  width: 100px;
  height: 100px;
  border-radius: 8px;
  object-fit: cover;
  background: #f2f2f2;
}

.combo-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.combo-name {
  margin: 0;
  font-size: 15px;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.combo-sub {
  margin: 5px 0 0;
  font-size: 12px;
  color: var(--zs-text-gray);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.combo-meta {
  margin: 5px 0 0;
  font-size: 11px;
  color: #ff8f1f;
}

.combo-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: auto;
}

.combo-foot .zs-price {
  font-size: 16px;
}

.combo-btn {
  padding: 4px 12px;
  border-radius: 14px;
  font-size: 12px;
  color: #fff;
  background: var(--zs-primary);
}
</style>
