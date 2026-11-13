<template>
  <div class="page stores-page">
    <PageBanner
      title="门店导航"
      subtitle="到店自提 · 3 公里当日配送 · 鲜肉预订"
      :crumbs="[{ label: '门店导航' }]"
    />

    <div class="container">
      <!-- 服务说明 -->
      <div class="service-bar">
        <div v-for="item in services" :key="item.title" class="service-bar__item">
          <span class="service-bar__icon">{{ item.icon }}</span>
          <div>
            <strong>{{ item.title }}</strong>
            <p>{{ item.desc }}</p>
          </div>
        </div>
      </div>

      <!-- 门店列表 -->
      <div v-if="loading" class="state-tip">加载中…</div>

      <template v-else>
        <div v-if="stores.length" class="store-list">
          <article v-for="store in stores" :key="store.id" class="store-item card">
            <div class="store-item__cover">
              <img
                v-if="coverOf(store) && !failed[store.id]"
                :src="coverOf(store)"
                :alt="store.name"
                @error="failed[store.id] = true"
              />
              <div v-else class="thumb-placeholder">{{ store.name.charAt(0) }}</div>
            </div>

            <div class="store-item__body">
              <div class="store-item__head">
                <h3 class="store-item__name">{{ store.name }}</h3>
                <span class="tag" :class="{ 'tag-gold': store.status === 0 }">
                  {{ store.status === 0 ? '暂停营业' : '营业中' }}
                </span>
              </div>

              <p v-if="store.intro" class="store-item__intro">{{ store.intro }}</p>

              <ul class="store-item__list">
                <li>
                  <span>门店地址</span>
                  <p>{{ fullAddress(store) }}</p>
                </li>
                <li>
                  <span>联系电话</span>
                  <p>
                    <a v-if="store.phone" class="store-item__phone" :href="`tel:${store.phone}`">
                      {{ store.phone }}
                    </a>
                    <em v-else>—</em>
                    <small v-if="store.contact">（{{ store.contact }}）</small>
                  </p>
                </li>
                <li>
                  <span>营业时间</span>
                  <p>{{ store.businessHours || '—' }}</p>
                </li>
                <li>
                  <span>配送范围</span>
                  <p>
                    {{ store.deliveryRadiusKm ?? '—' }} km 内 · 配送费
                    {{ money(store.deliveryFee) }} 元 · 满 {{ money(store.freeDeliveryAmount) }} 元免配送费
                  </p>
                </li>
                <li>
                  <span>起送金额</span>
                  <p>{{ money(store.minOrderAmount) }} 元</p>
                </li>
              </ul>

              <div class="store-item__actions">
                <a
                  v-if="store.lng && store.lat"
                  class="btn btn-primary"
                  :href="mapUrl(store)"
                  target="_blank"
                  rel="noopener"
                >
                  查看地图导航
                </a>
                <a v-if="store.phone" class="btn btn-ghost" :href="`tel:${store.phone}`">
                  拨打电话
                </a>
                <router-link class="btn btn-ghost" to="/products?bizType=PORK">选购鲜肉</router-link>
              </div>
            </div>
          </article>
        </div>

        <div v-else class="state-tip empty">暂无门店信息，敬请期待</div>
      </template>

      <!-- 鲜肉预订流程 -->
      <section class="reserve">
        <h2 class="section-title">鲜肉预订流程</h2>
        <p class="section-sub">提前锁定当日好肉，下班顺路带走</p>

        <div class="reserve__steps">
          <div v-for="(step, index) in reserveSteps" :key="step.title" class="reserve__step">
            <span class="reserve__index">{{ index + 1 }}</span>
            <strong>{{ step.title }}</strong>
            <p>{{ step.desc }}</p>
          </div>
        </div>

        <div class="reserve__tip">
          <span>※</span>
          <p>
            预订支持当日与次日取货，具体截止时间与分割加工费以所选门店配置为准；
            如需整猪分割、宴席用肉，请拨打客服电话
            <a :href="`tel:${servicePhone}`">{{ servicePhone }}</a> 预约。
          </p>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import PageBanner from '@/components/PageBanner.vue'
import { getStores, type Store } from '@/api'
import { siteValue } from '@/store/site'

const stores = ref<Store[]>([])
const loading = ref(true)
/** 记录图片加载失败的门店 */
const failed = reactive<Record<number, boolean>>({})

const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))

const services = [
  { icon: '🏪', title: '到店自提', desc: '线上下单，到店免排队取货' },
  { icon: '🚚', title: '门店配送', desc: '3 公里内当日送达' },
  { icon: '🔪', title: '免费分割', desc: '切块 / 绞肉 / 切片' },
  { icon: '📅', title: '鲜肉预订', desc: '提前预订当日鲜肉' }
]

const reserveSteps = [
  { title: '选择门店', desc: '在门店导航中选一家离你最近的门店，查看其可预订天数与截止时间。' },
  { title: '选择商品与规格', desc: '在商品详情页选择规格、数量，并按需选择切块、绞肉或切片。' },
  { title: '确认取货时间', desc: '预订当日或次日到店自提，或选择门店配送上门。' },
  { title: '到店核销', desc: '凭订单号到店称重、核销，当场分割加工后带走。' }
]

function coverOf(store: Store) {
  return (store.images || '').split(',')[0]?.trim() || ''
}

function fullAddress(store: Store) {
  return (
    [store.province, store.city, store.district, store.address].filter(Boolean).join(' ') || '—'
  )
}

function money(value?: number) {
  return value === undefined || value === null ? '0.00' : Number(value).toFixed(2)
}

/** 高德地图标记链接 */
function mapUrl(store: Store) {
  const name = encodeURIComponent(store.name)
  return `https://uri.amap.com/marker?position=${store.lng},${store.lat}&name=${name}`
}

onMounted(async () => {
  try {
    stores.value = (await getStores()) || []
    // 默认只展示营业中的门店优先
    stores.value.sort((a, b) => (b.status || 0) - (a.status || 0))
  } catch (e) {
    stores.value = []
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
/* ---------------- 服务说明 ---------------- */
.service-bar {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
  margin-top: 30px;
}

.service-bar__item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 20px 22px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-sm);
}

.service-bar__icon {
  font-size: 28px;
}

.service-bar__item strong {
  display: block;
  font-size: 15.5px;
}

.service-bar__item p {
  font-size: 13px;
  color: var(--text-muted);
}

/* ---------------- 门店卡片 ---------------- */
.store-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-top: 30px;
}

.store-item {
  display: grid;
  grid-template-columns: 220px 1fr;
  border: 1px solid var(--border-color);
}

.store-item__cover {
  position: relative;
  min-height: 100%;
  background: var(--bg-soft);
}

.store-item__cover img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.store-item__body {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 22px 24px;
}

.store-item__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.store-item__name {
  font-size: 18px;
  font-weight: 800;
}

.store-item__intro {
  font-size: 13.5px;
  color: var(--brand-gold-dark);
}

.store-item__list li {
  display: flex;
  gap: 12px;
  margin-bottom: 8px;
  font-size: 14px;
  color: var(--text-sub);
}

.store-item__list li > span {
  flex-shrink: 0;
  width: 66px;
  color: var(--text-muted);
}

.store-item__list p {
  flex: 1;
}

.store-item__list small {
  margin-left: 6px;
  color: var(--text-muted);
}

.store-item__phone {
  font-size: 16px;
  font-weight: 800;
  color: var(--brand-red);
}

.store-item__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 8px;
}

.store-item__actions .btn {
  padding: 9px 18px;
  font-size: 14px;
}

/* ---------------- 预订流程 ---------------- */
.reserve {
  margin-top: 56px;
  padding: 40px 34px;
  border-radius: var(--radius-lg);
  background: #fff;
  box-shadow: var(--shadow-card);
}

.reserve__steps {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 22px;
  margin-top: 30px;
}

.reserve__step {
  position: relative;
  padding: 24px 20px;
  border-radius: var(--radius);
  background: linear-gradient(160deg, #fffdf8, #fdf5ea);
  border: 1px dashed rgba(212, 163, 91, 0.5);
}

.reserve__index {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  margin-bottom: 12px;
  border-radius: 50%;
  font-size: 15px;
  font-weight: 800;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-gold));
}

.reserve__step strong {
  display: block;
  margin-bottom: 8px;
  font-size: 16px;
}

.reserve__step p {
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

.reserve__tip {
  display: flex;
  gap: 10px;
  margin-top: 24px;
  padding: 16px 20px;
  border-radius: var(--radius);
  background: var(--bg-page);
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

.reserve__tip span {
  color: var(--brand-red);
  font-weight: 800;
}

.reserve__tip a {
  color: var(--brand-red);
  font-weight: 700;
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 1200px) {
  .store-list {
    grid-template-columns: 1fr;
  }

  .reserve__steps {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 992px) {
  .service-bar {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .service-bar,
  .reserve__steps {
    grid-template-columns: 1fr;
  }

  .store-item {
    grid-template-columns: 1fr;
  }

  .store-item__cover {
    height: 180px;
  }

  .reserve {
    padding: 26px 18px;
  }
}
</style>
