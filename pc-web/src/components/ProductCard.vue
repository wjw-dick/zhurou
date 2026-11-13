<template>
  <router-link :to="`/products/${product.id}`" class="product-card card card-hover">
    <!-- 封面 -->
    <div class="product-card__cover">
      <img
        v-if="product.cover && !coverFailed"
        :src="product.cover"
        :alt="product.name"
        @error="coverFailed = true"
      />
      <div v-else class="thumb-placeholder">{{ firstChar }}</div>

      <!-- 标签 -->
      <div class="product-card__tags">
        <span v-if="tags.length" class="tag">{{ tags[0] }}</span>
        <span v-if="product.reservable === 1" class="tag tag-gold">可预订</span>
      </div>
    </div>

    <!-- 信息 -->
    <div class="product-card__body">
      <h3 class="product-card__name">{{ product.name }}</h3>
      <p class="product-card__sub">{{ product.subTitle || '当日冷链 · 门店直供' }}</p>

      <div class="product-card__meta">
        <span v-if="product.origin">产地 {{ product.origin }}</span>
        <span v-if="product.unit">/ {{ product.unit }}</span>
      </div>

      <div class="product-card__foot">
        <span class="product-card__sales">已售 {{ product.sales || 0 }}</span>
        <span class="product-card__more">查看详情 →</span>
      </div>
    </div>
  </router-link>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import type { Product } from '@/api'

const props = defineProps<{ product: Product }>()

/** 封面加载失败时回退为品牌渐变占位 */
const coverFailed = ref(false)

/** 无封面时取名称首字作为占位 */
const firstChar = computed(() => (props.product.name || '猪').charAt(0))

/** 标签（逗号分隔） */
const tags = computed(() =>
  (props.product.tags || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
)
</script>

<style scoped>
.product-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border: 1px solid var(--border-color);
}

.product-card__cover {
  position: relative;
  aspect-ratio: 4 / 3;
  overflow: hidden;
  background: var(--bg-soft);
}

.product-card__cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.45s ease;
}

.product-card:hover .product-card__cover img {
  transform: scale(1.06);
}

.product-card__tags {
  position: absolute;
  top: 10px;
  left: 10px;
  display: flex;
  gap: 6px;
}

.product-card__tags .tag {
  background: rgba(255, 255, 255, 0.92);
}

.product-card__body {
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: 6px;
  padding: 16px 16px 18px;
}

.product-card__name {
  font-size: 17px;
  font-weight: 700;
  color: var(--text-main);
  transition: var(--transition);
}

.product-card:hover .product-card__name {
  color: var(--brand-red);
}

.product-card__sub {
  font-size: 13px;
  color: var(--text-muted);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-card__meta {
  display: flex;
  gap: 6px;
  font-size: 12.5px;
  color: var(--text-sub);
}

.product-card__foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: auto;
  padding-top: 12px;
  border-top: 1px dashed var(--border-color);
  font-size: 13px;
}

.product-card__sales {
  color: var(--text-muted);
}

.product-card__more {
  font-weight: 600;
  color: var(--brand-red);
}

@media (max-width: 768px) {
  .product-card__body {
    padding: 14px;
  }
}
</style>
