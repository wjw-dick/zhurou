<script setup lang="ts">
/**
 * 单商品分享落地页
 * 详情：GET /public/products/{id} → { product, skus, qualifications }
 * 底部为分享引导条（「分享给好友」占位按钮）
 */
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ShareBar from '@/components/ShareBar.vue'
import { getProductDetail, toast, type ProductItem, type QualificationItem, type SkuItem } from '@/api'

const route = useRoute()
const router = useRouter()

const product = ref<ProductItem | null>(null)
const skus = ref<SkuItem[]>([])
const qualifications = ref<QualificationItem[]>([])
const activeSku = ref<SkuItem | null>(null)
const loading = ref(true)

// 资质类型中文名（与后端字典 qualType 对应）
const QUAL_TYPE_LABEL: Record<string, string> = {
  QUARANTINE: '动物产品检疫合格证明',
  QUALITY: '肉品品质检验合格证',
  SC: '食品生产许可',
  INSPECTION: '检测报告',
  BUSINESS: '营业执照'
}

const shareTitle = computed(() => product.value?.name || '猪事大吉')
const shareDesc = computed(() => product.value?.subTitle || '新鲜现切，火锅到家')

/** 图片集：cover + images（逗号分隔） */
const gallery = computed(() => {
  const imgs: string[] = []
  if (product.value?.cover) imgs.push(product.value.cover)
  if (product.value?.images) {
    product.value.images
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean)
      .forEach((s) => {
        if (s !== product.value?.cover) imgs.push(s)
      })
  }
  return imgs
})

async function load() {
  loading.value = true
  try {
    const data = await getProductDetail(String(route.params.id))
    product.value = data?.product || null
    skus.value = data?.skus || []
    qualifications.value = data?.qualifications || []
    activeSku.value = skus.value.find((s) => s.status !== 0) || skus.value[0] || null
  } catch {
    product.value = null
  } finally {
    loading.value = false
  }
}

/** 直接购买：跳转商城（下单在商城/小程序内完成） */
function goBuy() {
  toast('请进入商城选择门店与数量后下单')
  router.push('/combo')
}

onMounted(load)
</script>

<template>
  <div class="product">
    <p v-if="loading" class="zs-empty">加载中…</p>
    <p v-else-if="!product" class="zs-empty">商品不存在或已下架</p>

    <template v-else>
      <!-- 图片 -->
      <img class="main-img" :src="gallery[0]" :alt="product.name" />
      <div v-if="gallery.length > 1" class="thumbs">
        <img v-for="(img, i) in gallery" :key="i" class="thumb" :src="img" :alt="product.name" />
      </div>

      <!-- 基本信息 -->
      <div class="info">
        <p class="name">{{ product.name }}</p>
        <p class="sub" v-if="product.subTitle">{{ product.subTitle }}</p>
        <div class="price-row">
          <span class="zs-price price">{{ activeSku?.price ?? product.price ?? '—' }}</span>
          <span class="sales" v-if="product.sales">已售 {{ product.sales }}</span>
        </div>
      </div>

      <!-- 规格 -->
      <div class="zs-card" v-if="skus.length">
        <p class="card-title">商品规格</p>
        <div class="sku-list">
          <div
            v-for="s in skus"
            :key="s.id"
            class="sku-item"
            :class="{ active: activeSku?.id === s.id }"
            @click="activeSku = s"
          >
            <span class="sku-name">{{ s.skuName || s.spec }}</span>
            <span class="sku-price zs-price">{{ s.price }}</span>
          </div>
        </div>
      </div>

      <!-- 商品参数 -->
      <div class="zs-card">
        <p class="card-title">商品参数</p>
        <div class="param-row" v-if="product.bizType"><span>品类</span><em>{{ product.bizType }}</em></div>
        <div class="param-row" v-if="product.unit"><span>规格单位</span><em>{{ product.unit }}</em></div>
        <div class="param-row" v-if="product.origin"><span>产地</span><em>{{ product.origin }}</em></div>
        <div class="param-row" v-if="product.shelfLife"><span>保质期</span><em>{{ product.shelfLife }}</em></div>
        <div class="param-row" v-if="product.storageCond"><span>储存条件</span><em>{{ product.storageCond }}</em></div>
        <div class="param-row" v-if="product.cookTip"><span>烹饪建议</span><em>{{ product.cookTip }}</em></div>
      </div>

      <!-- 资质证明 -->
      <div class="zs-card" v-if="qualifications.length">
        <p class="card-title">检疫与资质</p>
        <div v-for="q in qualifications" :key="q.id" class="qual-row">
          <span class="qual-type">{{ QUAL_TYPE_LABEL[q.qualType] || q.qualType }}</span>
          <span class="qual-no">{{ q.qualNo || '' }}</span>
          <img v-if="q.fileUrl" class="qual-img" :src="q.fileUrl" alt="资质证明" />
        </div>
      </div>

      <!-- 图文详情 -->
      <div class="zs-card" v-if="product.detail">
        <p class="card-title">商品详情</p>
        <div class="detail" v-html="product.detail"></div>
      </div>

      <!-- 底部：下单占位 + 分享引导 -->
      <div class="bottom-holder"></div>
      <ShareBar :title="shareTitle" :desc="shareDesc" :offset="54">
        <button class="buy-btn" @click="goBuy">去下单</button>
      </ShareBar>
    </template>
  </div>
</template>

<style scoped>
.main-img {
  width: 100%;
  height: 260px;
  object-fit: cover;
  background: #f2f2f2;
}

.thumbs {
  display: flex;
  gap: 8px;
  padding: 8px 12px 0;
  overflow-x: auto;
}

.thumb {
  flex: none;
  width: 62px;
  height: 62px;
  border-radius: 6px;
  object-fit: cover;
}

.info {
  padding: 12px;
}

.name {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
}

.sub {
  margin: 6px 0 0;
  font-size: 12px;
  color: var(--zs-text-gray);
}

.price-row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-top: 10px;
}

.price {
  font-size: 22px;
}

.sales {
  font-size: 12px;
  color: var(--zs-text-gray);
}

.card-title {
  margin: 0 0 8px;
  font-size: 14px;
  font-weight: 600;
}

.sku-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.sku-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  border: 1px solid var(--zs-border);
  border-radius: 16px;
  font-size: 12px;
}

.sku-item.active {
  color: var(--zs-primary);
  border-color: var(--zs-primary);
  background: #fdf1f1;
}

.sku-price {
  font-size: 12px;
}

.param-row {
  display: flex;
  justify-content: space-between;
  padding: 7px 0;
  font-size: 13px;
  border-bottom: 1px solid #f7f7f7;
}

.param-row:last-child {
  border-bottom: none;
}

.param-row span {
  color: var(--zs-text-gray);
}

.param-row em {
  font-style: normal;
}

.qual-row {
  padding: 6px 0;
  border-bottom: 1px solid #f7f7f7;
  font-size: 12px;
}

.qual-row:last-child {
  border-bottom: none;
}

.qual-type {
  font-weight: 600;
}

.qual-no {
  margin-left: 8px;
  color: var(--zs-text-gray);
}

.qual-img {
  width: 100%;
  margin-top: 6px;
  border-radius: 6px;
}

.detail {
  font-size: 13px;
  line-height: 1.7;
  word-break: break-all;
}

.detail :deep(img) {
  max-width: 100%;
}

.bottom-holder {
  height: 62px;
}

.buy-btn {
  flex: none;
  height: 36px;
  padding: 0 18px;
  border-radius: 18px;
  color: #fff;
  font-size: 14px;
  background: linear-gradient(90deg, #e8434a, var(--zs-primary));
}
</style>
