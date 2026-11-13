<template>
  <div class="page detail-page">
    <!-- 面包屑 -->
    <div class="crumb-bar">
      <div class="container crumb-bar__inner">
        <router-link to="/">首页</router-link>
        <span>/</span>
        <router-link to="/products">产品展示</router-link>
        <span>/</span>
        <router-link :to="`/products?bizType=${route.query.bizType || product?.bizType || ''}`">
          {{ bizTypeLabel }}
        </router-link>
        <span>/</span>
        <em>{{ product?.name || '商品详情' }}</em>
      </div>
    </div>

    <div class="container">
      <!-- 加载 / 异常 -->
      <div v-if="loading" class="state-tip">加载中…</div>
      <div v-else-if="!product" class="state-tip empty">
        <p>商品不存在或已下架</p>
        <router-link to="/products" class="btn btn-primary" style="margin-top: 16px">返回产品展示</router-link>
      </div>

      <!-- 主信息区 -->
      <template v-else>
        <div class="detail-main">
          <!-- 图片区 -->
          <div class="gallery">
            <div class="gallery__main">
              <img
                v-if="activeImage && !imageFailed"
                :src="activeImage"
                :alt="product.name"
                @error="imageFailed = true"
              />
              <div v-else class="thumb-placeholder">{{ product.name.charAt(0) }}</div>
              <span v-if="product.reservable === 1" class="gallery__flag">支持鲜肉预订</span>
            </div>

            <div v-if="gallery.length > 1" class="gallery__thumbs">
              <button
                v-for="(img, index) in gallery"
                :key="index"
                class="gallery__thumb"
                :class="{ active: img === activeImage }"
                @click="selectImage(img)"
              >
                <img :src="img" :alt="`${product.name}-${index + 1}`" />
              </button>
            </div>
          </div>

          <!-- 信息区 -->
          <div class="info">
            <div class="info__tags">
              <span v-for="tag in tagList" :key="tag" class="tag">{{ tag }}</span>
              <span class="tag tag-gold">{{ bizTypeLabel }}</span>
            </div>

            <h1 class="info__name">{{ product.name }}</h1>
            <p class="info__sub">{{ product.subTitle }}</p>

            <!-- 价格 -->
            <div class="price-box">
              <span class="price-box__currency">¥</span>
              <strong class="price-box__value">{{ selectedSku ? selectedSku.price : '--' }}</strong>
              <span class="price-box__unit">/ {{ selectedSku?.unit || product.unit || '份' }}</span>
              <del v-if="selectedSku?.marketPrice" class="price-box__market">¥{{ selectedSku.marketPrice }}</del>
              <span class="price-box__sales">已售 {{ product.sales || 0 }}</span>
            </div>

            <!-- 规格选择 -->
            <div class="spec">
              <span class="spec__label">规格</span>
              <div class="spec__list">
                <button
                  v-for="sku in skus"
                  :key="sku.id"
                  class="spec__item"
                  :class="{ active: selectedSku && sku.id === selectedSku.id }"
                  :disabled="sku.stock <= 0"
                  @click="selectedSku = sku"
                >
                  <strong>{{ sku.skuName }}</strong>
                  <span>¥{{ sku.price }}</span>
                  <em v-if="sku.stock <= 0">缺货</em>
                </button>
              </div>
            </div>

            <!-- 数量 -->
            <div class="quantity">
              <span class="spec__label">数量</span>
              <div class="stepper">
                <button :disabled="qty <= 1" @click="qty = Math.max(1, qty - 1)">−</button>
                <input v-model.number="qty" type="number" min="1" :max="maxQty" />
                <button :disabled="qty >= maxQty" @click="qty = Math.min(maxQty, qty + 1)">＋</button>
              </div>
              <span class="quantity__stock">库存 {{ selectedSku?.stock ?? 0 }} {{ selectedSku?.unit || '份' }}</span>
            </div>

            <!-- 商品属性 -->
            <ul class="attrs">
              <li v-if="product.origin"><span>产地</span>{{ product.origin }}</li>
              <li v-if="product.shelfLife"><span>保质期</span>{{ product.shelfLife }}</li>
              <li v-if="product.storageCond"><span>储存条件</span>{{ product.storageCond }}</li>
              <li v-if="product.cookTip"><span>烹饪提示</span>{{ product.cookTip }}</li>
              <li><span>计量单位</span>{{ product.unit || '份' }}</li>
              <li v-if="product.splitEnabled === 1">
                <span>分割加工</span>支持切块 / 绞肉 / 切片（加工费 ¥{{ product.splitFee || 0 }}）
              </li>
            </ul>

            <!-- 操作按钮 -->
            <div class="actions">
              <button class="btn btn-ghost" :disabled="!selectedSku" @click="handleAddCart">
                加入购物车
              </button>
              <button class="btn btn-primary" :disabled="!selectedSku" @click="handleReserve">
                {{ product.reservable === 1 ? '立即预订' : '咨询客服' }}
              </button>
            </div>

            <p class="actions__tip">
              提示：官网下单暂未开放，可加入购物车后到店核销，或拨打
              {{ servicePhone }} 咨询。
            </p>
          </div>
        </div>

        <!-- 详情 + 资质 -->
        <div class="detail-blocks">
          <!-- 商品详情 -->
          <section class="block">
            <h2 class="block__title">商品详情</h2>
            <div v-if="product.detail" class="rich-text" v-html="product.detail"></div>
            <div v-else class="block__empty">
              <p>
                {{ product.name }}（{{ product.subTitle || '当日冷链直供' }}），产地
                {{ product.origin || '—' }}，{{ product.storageCond || '冷链储存' }}，保质期
                {{ product.shelfLife || '—' }}。
              </p>
              <p>
                门店支持免费分割加工，可切块、绞肉或切片；如需鲜肉预订，请提前在门店下单，
                当日到店自提或选择 3 公里内配送。
              </p>
            </div>
          </section>

          <!-- 检疫资质证明 -->
          <section class="block">
            <h2 class="block__title">
              检疫资质证明
              <small>两证两章 · 来源可溯</small>
            </h2>

            <div v-if="qualifications.length" class="qual-list">
              <div v-for="qual in qualifications" :key="qual.id" class="qual-card">
                <div class="qual-card__head">
                  <span class="qual-card__type">{{ qualTypeLabel(qual.qualType) }}</span>
                  <span class="tag tag-gold">有效</span>
                </div>
                <ul class="qual-card__body">
                  <li v-if="qual.qualNo"><span>证书编号</span>{{ qual.qualNo }}</li>
                  <li v-if="qual.issuer"><span>发证机构</span>{{ qual.issuer }}</li>
                  <li v-if="qual.issueDate"><span>发证日期</span>{{ qual.issueDate }}</li>
                  <li v-if="qual.expireDate"><span>有效期至</span>{{ qual.expireDate }}</li>
                </ul>
                <a
                  v-if="qual.fileUrl"
                  class="qual-card__file"
                  :href="qual.fileUrl"
                  target="_blank"
                  rel="noopener"
                >
                  查看证明文件 →
                </a>
                <span v-else class="qual-card__file qual-card__file--muted">证明文件以门店公示为准</span>
              </div>
            </div>

            <div v-else class="block__empty">
              <p>该商品的检疫与品质证明正在同步中，可到门店查看纸质公示件。</p>
              <p>
                猪事大吉承诺：每一批猪肉均随附《动物产品检疫合格证明》与《肉品品质检验合格证》，
                胴体加盖检疫验讫印章与肉品品质检验印章。
                <router-link to="/qualification">查看公司资质证照 →</router-link>
              </p>
            </div>
          </section>
        </div>
      </template>
    </div>

    <!-- 轻提示 -->
    <transition name="fade-slide">
      <div v-if="toast" class="toast">{{ toast }}</div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  getProductDetail,
  type Product,
  type ProductSku,
  type Qualification
} from '@/api'
import { addToCart } from '@/store/cart'
import { siteValue } from '@/store/site'

const route = useRoute()
const router = useRouter()

const product = ref<Product | null>(null)
const skus = ref<ProductSku[]>([])
const qualifications = ref<Qualification[]>([])
const selectedSku = ref<ProductSku | null>(null)
const activeImage = ref('')
const imageFailed = ref(false)
const qty = ref(1)
const loading = ref(true)
const toast = ref('')

const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))

/** 品类中文名 */
const bizTypeMap: Record<string, string> = {
  PORK: '鲜猪肉',
  HOTPOT: '火锅食材',
  PROCESSED: '肉制品',
  BASE: '底料蘸料',
  SET: '套餐礼盒'
}

/** 资质类型中文名 */
const qualTypeMap: Record<string, string> = {
  QUARANTINE: '动物产品检疫合格证明',
  QUALITY: '肉品品质检验合格证',
  SC: '食品生产许可（SC）',
  INSPECTION: '检测报告',
  BUSINESS: '营业执照'
}

const bizTypeLabel = computed(() =>
  product.value ? bizTypeMap[product.value.bizType] || '商品' : '商品'
)

/** 标签列表 */
const tagList = computed(() =>
  (product.value?.tags || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
)

/** 图集（封面 + 轮播图，去重） */
const gallery = computed(() => {
  if (!product.value) return []
  const list = [product.value.cover, ...(product.value.images || '').split(',')]
    .map((s) => (s || '').trim())
    .filter(Boolean)
  return Array.from(new Set(list))
})

const maxQty = computed(() => Math.max(1, selectedSku.value?.stock || 1))

function qualTypeLabel(type: string) {
  return qualTypeMap[type] || type
}

function selectImage(img: string) {
  activeImage.value = img
  imageFailed.value = false
}

/** 拉取商品详情 */
async function fetchDetail(id: string | string[]) {
  loading.value = true
  try {
    const data = await getProductDetail(id as string)
    product.value = data?.product || null
    skus.value = data?.skus || []
    qualifications.value = data?.qualifications || []
    selectedSku.value = skus.value.find((sku) => (sku.stock || 0) > 0) || skus.value[0] || null
    activeImage.value = gallery.value[0] || ''
    imageFailed.value = false
    qty.value = 1
  } catch (e) {
    product.value = null
    skus.value = []
    qualifications.value = []
  } finally {
    loading.value = false
  }
}

function showToast(message: string) {
  toast.value = message
  window.setTimeout(() => {
    toast.value = ''
  }, 2200)
}

/** 加入购物车 */
function handleAddCart() {
  if (!product.value || !selectedSku.value) return
  addToCart(
    {
      productId: product.value.id,
      productName: product.value.name,
      skuId: selectedSku.value.id,
      skuName: selectedSku.value.skuName,
      price: selectedSku.value.price,
      cover: product.value.cover
    },
    qty.value
  )
  showToast(`已加入购物车：${product.value.name} × ${qty.value}`)
}

/** 立即预订 / 咨询 */
function handleReserve() {
  if (!product.value) return
  if (product.value.reservable === 1) {
    showToast('请选择门店后完成鲜肉预订')
    router.push({ path: '/stores', query: { productId: String(product.value.id) } })
  } else {
    showToast(`该商品暂不支持预订，请拨打 ${servicePhone.value} 咨询`)
  }
}

watch(
  () => route.params.id,
  (id) => {
    if (route.path.startsWith('/products/') && id) fetchDetail(id)
  },
  { immediate: true }
)
</script>

<style scoped>
.crumb-bar {
  background: #fff;
  border-bottom: 1px solid var(--border-color);
}

.crumb-bar__inner {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  padding-top: 16px;
  padding-bottom: 16px;
  font-size: 13.5px;
  color: var(--text-muted);
}

.crumb-bar__inner a:hover {
  color: var(--brand-red);
}

.crumb-bar__inner em {
  font-style: normal;
  color: var(--text-main);
  font-weight: 600;
}

/* ---------------- 主信息 ---------------- */
.detail-main {
  display: grid;
  grid-template-columns: 480px 1fr;
  gap: 44px;
  padding: 34px 0 10px;
}

.gallery__main {
  position: relative;
  aspect-ratio: 1 / 1;
  overflow: hidden;
  border-radius: var(--radius);
  background: var(--bg-soft);
  border: 1px solid var(--border-color);
}

.gallery__main img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.gallery__flag {
  position: absolute;
  left: 14px;
  top: 14px;
  padding: 5px 14px;
  border-radius: 999px;
  font-size: 12.5px;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.28);
}

.gallery__thumbs {
  display: flex;
  gap: 10px;
  margin-top: 14px;
}

.gallery__thumb {
  width: 78px;
  height: 78px;
  padding: 0;
  overflow: hidden;
  border-radius: 10px;
  border: 2px solid transparent;
  background: var(--bg-soft);
  transition: var(--transition);
}

.gallery__thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.gallery__thumb.active {
  border-color: var(--brand-red);
}

/* ---------------- 信息 ---------------- */
.info__tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.info__name {
  margin: 14px 0 8px;
  font-size: 30px;
  font-weight: 800;
  letter-spacing: 1px;
}

.info__sub {
  color: var(--text-muted);
}

.price-box {
  display: flex;
  align-items: baseline;
  flex-wrap: wrap;
  gap: 6px;
  margin: 20px 0;
  padding: 18px 22px;
  border-radius: var(--radius);
  background: linear-gradient(120deg, #fff6f6, #fdf3e8);
  border: 1px solid rgba(200, 22, 29, 0.12);
}

.price-box__currency {
  font-size: 20px;
  font-weight: 700;
  color: var(--brand-red);
}

.price-box__value {
  font-size: 38px;
  font-weight: 900;
  line-height: 1;
  color: var(--brand-red);
}

.price-box__unit {
  font-size: 14px;
  color: var(--text-sub);
}

.price-box__market {
  margin-left: 8px;
  font-size: 14px;
  color: var(--text-muted);
}

.price-box__sales {
  margin-left: auto;
  font-size: 13px;
  color: var(--text-muted);
}

/* ---------------- 规格 / 数量 ---------------- */
.spec,
.quantity {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 18px;
}

.spec__label {
  flex-shrink: 0;
  width: 58px;
  padding-top: 10px;
  font-size: 14px;
  color: var(--text-muted);
}

.spec__list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.spec__item {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
  padding: 9px 16px;
  border-radius: 10px;
  border: 1px solid var(--border-color);
  background: #fff;
  transition: var(--transition);
}

.spec__item strong {
  font-size: 14px;
  font-weight: 700;
}

.spec__item span {
  font-size: 12.5px;
  color: var(--brand-red);
  font-weight: 700;
}

.spec__item em {
  position: absolute;
  right: 6px;
  top: 6px;
  font-size: 10px;
  font-style: normal;
  color: var(--text-muted);
}

.spec__item:hover:not(:disabled) {
  border-color: var(--brand-red);
}

.spec__item.active {
  border-color: var(--brand-red);
  background: rgba(200, 22, 29, 0.05);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.12);
}

.spec__item:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.stepper {
  display: flex;
  align-items: center;
  border: 1px solid var(--border-color);
  border-radius: 10px;
  overflow: hidden;
}

.stepper button {
  width: 38px;
  height: 38px;
  font-size: 18px;
  color: var(--text-sub);
  background: var(--bg-page);
  transition: var(--transition);
}

.stepper button:hover:not(:disabled) {
  color: #fff;
  background: var(--brand-red);
}

.stepper button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.stepper input {
  width: 62px;
  height: 38px;
  border: none;
  border-left: 1px solid var(--border-color);
  border-right: 1px solid var(--border-color);
  text-align: center;
  outline: none;
  -moz-appearance: textfield;
}

.stepper input::-webkit-outer-spin-button,
.stepper input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.quantity__stock {
  padding-top: 10px;
  font-size: 13px;
  color: var(--text-muted);
}

/* ---------------- 属性 ---------------- */
.attrs {
  padding: 18px 20px;
  border-radius: var(--radius);
  background: var(--bg-page);
}

.attrs li {
  display: flex;
  gap: 14px;
  margin-bottom: 9px;
  font-size: 14px;
  color: var(--text-sub);
}

.attrs li:last-child {
  margin-bottom: 0;
}

.attrs li span {
  flex-shrink: 0;
  width: 72px;
  color: var(--text-muted);
}

/* ---------------- 操作 ---------------- */
.actions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin-top: 24px;
}

.actions .btn {
  min-width: 160px;
  padding: 13px 28px;
  font-size: 16px;
}

.actions__tip {
  margin-top: 12px;
  font-size: 13px;
  color: var(--text-muted);
}

/* ---------------- 详情块 ---------------- */
.detail-blocks {
  display: grid;
  gap: 26px;
  margin-top: 34px;
}

.block {
  padding: 30px 34px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-card);
}

.block__title {
  position: relative;
  margin-bottom: 22px;
  padding-left: 16px;
  font-size: 20px;
  font-weight: 800;
}

.block__title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  bottom: 4px;
  width: 5px;
  border-radius: 4px;
  background: linear-gradient(180deg, var(--brand-red), var(--brand-gold));
}

.block__title small {
  margin-left: 10px;
  font-size: 13px;
  font-weight: 500;
  color: var(--text-muted);
}

.block__empty p {
  margin-bottom: 10px;
  color: var(--text-sub);
  line-height: 2;
}

.block__empty a {
  color: var(--brand-red);
  font-weight: 700;
}

/* ---------------- 资质卡片 ---------------- */
.qual-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 18px;
}

.qual-card {
  padding: 20px 22px;
  border-radius: var(--radius);
  background: linear-gradient(160deg, #fffdf8, #fdf6ea);
  border: 1px solid rgba(212, 163, 91, 0.35);
}

.qual-card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 12px;
}

.qual-card__type {
  font-size: 16px;
  font-weight: 800;
  color: var(--brand-gold-dark);
}

.qual-card__body li {
  display: flex;
  gap: 12px;
  margin-bottom: 6px;
  font-size: 13.5px;
  color: var(--text-sub);
}

.qual-card__body li span {
  flex-shrink: 0;
  width: 66px;
  color: var(--text-muted);
}

.qual-card__file {
  display: inline-block;
  margin-top: 10px;
  font-size: 13px;
  font-weight: 700;
  color: var(--brand-red);
}

.qual-card__file--muted {
  color: var(--text-muted);
  font-weight: 500;
}

/* ---------------- 轻提示 ---------------- */
.toast {
  position: fixed;
  left: 50%;
  top: 96px;
  z-index: 999;
  transform: translateX(-50%);
  padding: 12px 26px;
  border-radius: 999px;
  font-size: 14px;
  color: #fff;
  background: rgba(35, 38, 43, 0.9);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.2);
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 992px) {
  .detail-main {
    grid-template-columns: 1fr;
    gap: 26px;
  }

  .qual-list {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .info__name {
    font-size: 22px;
  }

  .price-box__value {
    font-size: 30px;
  }

  .block {
    padding: 22px 18px;
  }

  .actions .btn {
    flex: 1;
    min-width: 0;
  }

  .spec,
  .quantity {
    flex-direction: column;
    gap: 8px;
  }

  .spec__label {
    padding-top: 0;
  }
}
</style>
