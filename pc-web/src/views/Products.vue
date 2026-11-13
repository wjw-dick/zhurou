<template>
  <div class="page products-page">
    <PageBanner
      title="产品展示"
      subtitle="鲜猪肉 · 火锅食材 · 肉制品 · 底料蘸料 · 套餐礼盒"
      :crumbs="[{ label: '产品展示' }]"
    />

    <div class="container products-body">
      <!-- 品类 Tab -->
      <div class="tabs">
        <div class="tabs__list">
          <button
            v-for="tab in tabs"
            :key="tab.value"
            class="tabs__item"
            :class="{ active: bizType === tab.value }"
            @click="changeBizType(tab.value)"
          >
            {{ tab.label }}
          </button>
        </div>

        <!-- 关键词搜索 -->
        <form class="search" @submit.prevent="doSearch">
          <input v-model="keywordInput" class="search__input" type="text" placeholder="搜索商品名称，如：五花肉" />
          <button class="btn btn-primary search__btn" type="submit">搜索</button>
        </form>
      </div>

      <!-- 结果统计 -->
      <div class="result-bar">
        <span>
          共
          <strong>{{ total }}</strong>
          件商品
        </span>
        <span v-if="activeTabLabel" class="tag tag-gold">{{ activeTabLabel }}</span>
        <button v-if="keyword" class="result-bar__clear" @click="clearKeyword">
          清除搜索「{{ keyword }}」 ✕
        </button>
      </div>

      <!-- 商品列表 -->
      <div v-if="loading" class="state-tip">加载中…</div>

      <template v-else>
        <div v-if="products.length" class="product-grid">
          <ProductCard v-for="product in products" :key="product.id" :product="product" />
        </div>
        <div v-else class="state-tip empty">该品类下暂无商品</div>

        <Pagination
          :current="current"
          :size="size"
          :total="total"
          @change="changePage"
        />
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import PageBanner from '@/components/PageBanner.vue'
import ProductCard from '@/components/ProductCard.vue'
import Pagination from '@/components/Pagination.vue'
import { getProducts, type Product } from '@/api'

const route = useRoute()
const router = useRouter()

/** 品类 Tab（bizType） */
const tabs = [
  { label: '全部商品', value: '' },
  { label: '鲜猪肉', value: 'PORK' },
  { label: '火锅食材', value: 'HOTPOT' },
  { label: '肉制品', value: 'PROCESSED' },
  { label: '底料蘸料', value: 'BASE' },
  { label: '套餐礼盒', value: 'SET' }
]

const bizType = ref((route.query.bizType as string) || '')
const keyword = ref((route.query.keyword as string) || '')
const keywordInput = ref(keyword.value)
const current = ref(Number(route.query.current) || 1)
const size = ref(12)
const total = ref(0)
const products = ref<Product[]>([])
const loading = ref(true)

const activeTabLabel = computed(
  () => tabs.find((tab) => tab.value === bizType.value)?.label || ''
)

/** 拉取商品分页 */
async function fetchProducts() {
  loading.value = true
  try {
    const page = await getProducts({
      bizType: bizType.value || undefined,
      keyword: keyword.value || undefined,
      current: current.value,
      size: size.value
    })
    products.value = page?.records || []
    total.value = page?.total || 0
  } catch (e) {
    products.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

/** 同步筛选条件到地址栏，便于刷新/分享 */
function syncQuery() {
  router.replace({
    path: '/products',
    query: {
      ...(bizType.value ? { bizType: bizType.value } : {}),
      ...(keyword.value ? { keyword: keyword.value } : {}),
      ...(current.value > 1 ? { current: String(current.value) } : {})
    }
  })
}

function changeBizType(value: string) {
  if (bizType.value === value) return
  bizType.value = value
  current.value = 1
  syncQuery()
  fetchProducts()
}

function changePage(page: number) {
  current.value = page
  syncQuery()
  fetchProducts()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function doSearch() {
  keyword.value = keywordInput.value.trim()
  current.value = 1
  syncQuery()
  fetchProducts()
}

function clearKeyword() {
  keywordInput.value = ''
  keyword.value = ''
  current.value = 1
  syncQuery()
  fetchProducts()
}

// 支持从页脚等入口跳转时带参数变化
watch(
  () => route.query,
  (query) => {
    if (route.path !== '/products') return
    const nextBiz = (query.bizType as string) || ''
    const nextKeyword = (query.keyword as string) || ''
    if (nextBiz === bizType.value && nextKeyword === keyword.value) return
    bizType.value = nextBiz
    keyword.value = nextKeyword
    keywordInput.value = nextKeyword
    current.value = Number(query.current) || 1
    fetchProducts()
  }
)

onMounted(fetchProducts)
</script>

<style scoped>
.products-body {
  padding-top: 34px;
}

/* ---------------- 筛选区 ---------------- */
.tabs {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  padding: 20px 24px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-sm);
}

.tabs__list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.tabs__item {
  padding: 9px 20px;
  border-radius: 999px;
  font-size: 14.5px;
  font-weight: 600;
  color: var(--text-sub);
  background: var(--bg-page);
  border: 1px solid transparent;
  transition: var(--transition);
}

.tabs__item:hover {
  color: var(--brand-red);
  border-color: rgba(200, 22, 29, 0.3);
}

.tabs__item.active {
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.26);
}

.search {
  display: flex;
  gap: 10px;
}

.search__input {
  width: 260px;
  padding: 10px 16px;
  border-radius: 999px;
  border: 1px solid var(--border-color);
  background: var(--bg-page);
  outline: none;
  transition: var(--transition);
}

.search__input:focus {
  border-color: var(--brand-red);
  background: #fff;
}

.search__btn {
  padding: 10px 22px;
}

/* ---------------- 结果条 ---------------- */
.result-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
  margin: 22px 0 20px;
  font-size: 14px;
  color: var(--text-muted);
}

.result-bar strong {
  color: var(--brand-red);
  font-size: 17px;
}

.result-bar__clear {
  font-size: 13px;
  color: var(--brand-red);
}

/* ---------------- 商品网格 ---------------- */
.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 22px;
}

@media (max-width: 1200px) {
  .product-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 992px) {
  .product-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .tabs {
    flex-direction: column;
    align-items: stretch;
  }

  .search__input {
    flex: 1;
    width: auto;
  }
}

@media (max-width: 768px) {
  .product-grid {
    grid-template-columns: 1fr;
  }
}
</style>
