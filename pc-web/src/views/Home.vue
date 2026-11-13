<template>
  <div class="page home">
    <!-- ==================== Banner 轮播 ==================== -->
    <section class="banner" @mouseenter="pause" @mouseleave="play">
      <div class="banner__track" :style="{ transform: `translateX(-${active * 100}%)` }">
        <div v-for="slide in slides" :key="slide.id" class="banner__slide">
          <img
            v-if="slide.image && !slide.failed"
            class="banner__img"
            :src="slide.image"
            :alt="slide.title"
            @error="slide.failed = true"
          />
          <div v-else class="banner__img banner__img--fallback"></div>
          <div class="banner__mask"></div>

          <div class="banner__caption-wrap">
            <div class="container banner__caption">
              <span class="banner__kicker">猪事大吉 · 诸事大吉</span>
              <h2 class="banner__title">
                {{ isEn && slide.titleEn ? slide.titleEn : slide.title || t('home.bannerTitle') }}
              </h2>
              <p class="banner__sub">{{ t('home.bannerSub') }}</p>
              <div class="banner__actions">
                <router-link :to="slide.linkUrl || '/products'" class="btn btn-gold">
                  立即选购
                </router-link>
                <router-link to="/brand" class="btn btn-outline">品牌故事</router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 左右切换 -->
      <button v-if="slides.length > 1" class="banner__arrow banner__arrow--prev" @click="prev">‹</button>
      <button v-if="slides.length > 1" class="banner__arrow banner__arrow--next" @click="next">›</button>

      <!-- 指示点 -->
      <div v-if="slides.length > 1" class="banner__dots">
        <button
          v-for="(slide, index) in slides"
          :key="slide.id"
          class="banner__dot"
          :class="{ active: index === active }"
          @click="active = index"
        ></button>
      </div>
    </section>

    <!-- ==================== 服务承诺条 ==================== -->
    <section class="promise">
      <div class="container promise__inner">
        <div v-for="item in promises" :key="item.title" class="promise__item">
          <span class="promise__icon">{{ item.icon }}</span>
          <div>
            <strong class="promise__title">{{ item.title }}</strong>
            <p class="promise__desc">{{ item.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ==================== 品牌简介 ==================== -->
    <section class="section about">
      <div class="container about__inner">
        <div class="about__text">
          <h2 class="section-title">{{ t('home.aboutTitle') }}</h2>
          <p class="about__slogan">「猪事大吉」= 「诸事大吉」</p>
          <p class="about__desc">{{ t('home.aboutText') }}</p>
          <ul class="about__points">
            <li v-for="point in brandPoints" :key="point">{{ point }}</li>
          </ul>
          <router-link to="/brand" class="btn btn-primary">了解更多 →</router-link>
        </div>

        <div class="about__visual">
          <div class="about__badge">当日冷链<br /><small>COLD CHAIN</small></div>
          <div class="about__card">
            <span class="about__card-icon">🐖</span>
            <strong>鲜肉理念</strong>
            <p>当日分割 · 当日配送<br />不隔夜 · 不注水 · 不缺斤少两</p>
          </div>
          <div class="about__card about__card--gold">
            <span class="about__card-icon">📜</span>
            <strong>两证两章</strong>
            <p>动物产品检疫合格证明<br />肉品品质检验合格证</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ==================== 分类入口 ==================== -->
    <section class="section categories">
      <div class="container">
        <div class="section-head">
          <div>
            <h2 class="section-title">{{ t('home.categoryTitle') }}</h2>
            <p class="section-sub">{{ t('home.categorySub') }}</p>
          </div>
          <router-link to="/products" class="section-more">{{ t('common.more') }} →</router-link>
        </div>

        <div class="categories__grid">
          <router-link
            v-for="category in categories"
            :key="category.id"
            :to="`/products?bizType=${category.bizType}`"
            class="category-card card card-hover"
          >
            <span class="category-card__icon">{{ categoryIcon(category.bizType) }}</span>
            <strong class="category-card__name">
              {{ isEn && category.nameEn ? category.nameEn : category.name }}
            </strong>
            <span class="category-card__hint">进入选购 →</span>
          </router-link>
        </div>
      </div>
    </section>

    <!-- ==================== 热销商品 ==================== -->
    <section class="section hot">
      <div class="container">
        <div class="section-head">
          <div>
            <h2 class="section-title">{{ t('home.hotTitle') }}</h2>
            <p class="section-sub">{{ t('home.hotSub') }}</p>
          </div>
          <router-link to="/products" class="section-more">{{ t('common.more') }} →</router-link>
        </div>

        <div v-if="loadingProducts" class="state-tip">{{ t('common.loading') }}</div>
        <div v-else-if="hotProducts.length" class="product-grid">
          <ProductCard v-for="product in hotProducts" :key="product.id" :product="product" />
        </div>
        <div v-else class="state-tip empty">{{ t('common.empty') }}</div>
      </div>
    </section>

    <!-- ==================== 门店导航 ==================== -->
    <section class="section stores">
      <div class="container">
        <div class="section-head">
          <div>
            <h2 class="section-title">{{ t('home.storeTitle') }}</h2>
            <p class="section-sub">{{ t('home.storeSub') }}</p>
          </div>
          <router-link to="/stores" class="section-more">{{ t('common.more') }} →</router-link>
        </div>

        <div v-if="stores.length" class="stores__grid">
          <div v-for="store in stores" :key="store.id" class="store-card card">
            <div class="store-card__head">
              <strong class="store-card__name">{{ store.name }}</strong>
              <span class="tag tag-gold">营业中</span>
            </div>
            <ul class="store-card__list">
              <li><span>地址</span>{{ store.address }}</li>
              <li><span>电话</span><a :href="`tel:${store.phone}`">{{ store.phone }}</a></li>
              <li><span>营业</span>{{ store.businessHours }}</li>
              <li>
                <span>配送</span>
                {{ store.deliveryRadiusKm }}km 内 · 满 {{ store.freeDeliveryAmount }} 元免配送费
              </li>
            </ul>
            <router-link to="/stores" class="store-card__link">查看详情 →</router-link>
          </div>
        </div>
        <div v-else class="state-tip empty">暂无门店信息</div>
      </div>
    </section>

    <!-- ==================== 最新资讯 ==================== -->
    <section class="section news">
      <div class="container">
        <div class="section-head">
          <div>
            <h2 class="section-title">{{ t('home.newsTitle') }}</h2>
            <p class="section-sub">{{ t('home.newsSub') }}</p>
          </div>
          <router-link to="/news" class="section-more">{{ t('common.more') }} →</router-link>
        </div>

        <div v-if="articles.length" class="news__grid">
          <router-link
            v-for="article in articles"
            :key="article.id"
            :to="`/news/${article.id}`"
            class="news-card card card-hover"
          >
            <div class="news-card__date">
              <strong>{{ dayOf(article.publishTime) }}</strong>
              <span>{{ monthOf(article.publishTime) }}</span>
            </div>
            <div class="news-card__body">
              <h3 class="news-card__title">{{ article.title }}</h3>
              <p class="news-card__summary">{{ article.summary || '点击查看详情' }}</p>
              <span class="news-card__meta">阅读 {{ article.views || 0 }}</span>
            </div>
          </router-link>
        </div>
        <div v-else class="state-tip empty">暂无资讯</div>
      </div>
    </section>

    <!-- ==================== 底部行动区 ==================== -->
    <section class="cta">
      <div class="container cta__inner">
        <div>
          <h2 class="cta__title">想给公司订一批好肉？</h2>
          <p class="cta__sub">企业团单 · 节日礼盒 · 火锅套餐，专属客服一对一对接</p>
        </div>
        <router-link to="/contact" class="btn btn-gold">团购咨询 →</router-link>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import ProductCard from '@/components/ProductCard.vue'
import {
  getArticles,
  getBanners,
  getCategories,
  getProducts,
  getStores,
  type Article,
  type Banner,
  type Product,
  type ProductCategory,
  type Store
} from '@/api'
import { isEn, t } from '@/store/lang'

/** 轮播项（含图片加载失败标记） */
interface Slide {
  id: number
  title?: string
  titleEn?: string
  image: string
  linkUrl?: string
  failed?: boolean
}

/** 兜底轮播（接口无数据时展示） */
const fallbackSlides: Slide[] = [
  { id: -1, title: '猪事大吉 · 社区鲜肉', titleEn: 'Fresh Meat in Community', image: '', linkUrl: '/products' },
  { id: -2, title: '火锅到家 · 一站备齐', titleEn: 'Hotpot to Your Door', image: '', linkUrl: '/products' }
]

const slides = ref<Slide[]>([...fallbackSlides])
const active = ref(0)
const hotProducts = ref<Product[]>([])
const categories = ref<ProductCategory[]>([])
const stores = ref<Store[]>([])
const articles = ref<Article[]>([])
const loadingProducts = ref(true)

/** 服务承诺 */
const promises = [
  { icon: '🚚', title: '当日冷链', desc: '门店 3km 内极速配送' },
  { icon: '🔖', title: '两证两章', desc: '检疫合格·品质检验' },
  { icon: '🔪', title: '免费分割', desc: '切块 / 绞肉 / 切片' },
  { icon: '📅', title: '鲜肉预订', desc: '提前锁定当日好肉' }
]

/** 品牌要点 */
const brandPoints = [
  '当日冷鲜直供，不卖隔夜肉',
  '每批猪肉随附检疫与品质证明，来源可溯',
  '门店免费分割加工，回家就能下锅',
  '支持到店自提、门店配送与鲜肉预订'
]

/** 轮播定时器 */
let timer: number | undefined

function next() {
  if (!slides.value.length) return
  active.value = (active.value + 1) % slides.value.length
}

function prev() {
  if (!slides.value.length) return
  active.value = (active.value - 1 + slides.value.length) % slides.value.length
}

function play() {
  stop()
  if (slides.value.length > 1) {
    timer = window.setInterval(next, 5000)
  }
}

function stop() {
  if (timer) {
    window.clearInterval(timer)
    timer = undefined
  }
}

/** 品类图标 */
function categoryIcon(bizType: string) {
  const map: Record<string, string> = {
    PORK: '🥩',
    HOTPOT: '🍲',
    PROCESSED: '🌭',
    BASE: '🧂',
    SET: '🎁'
  }
  return map[bizType] || '🐖'
}

function dayOf(time?: string) {
  return time ? time.slice(8, 10) : '--'
}

function monthOf(time?: string) {
  return time ? time.slice(0, 7) : ''
}

onMounted(async () => {
  const [bannerRes, categoryRes, productRes, storeRes, articleRes] = await Promise.allSettled([
    getBanners('PC_HOME'),
    getCategories(),
    getProducts({ size: 8, current: 1 }),
    getStores(),
    getArticles({ size: 3, current: 1 })
  ])

  if (bannerRes.status === 'fulfilled' && bannerRes.value?.length) {
    slides.value = bannerRes.value.map((item: Banner) => ({
      id: item.id,
      title: item.title,
      titleEn: item.titleEn,
      image: item.image,
      linkUrl: item.linkUrl,
      failed: false
    }))
    active.value = 0
  }

  if (categoryRes.status === 'fulfilled') {
    // 只取一级分类作为入口
    categories.value = (categoryRes.value || []).filter((c) => !c.parentId)
  }

  if (productRes.status === 'fulfilled') {
    hotProducts.value = productRes.value?.records || []
  }
  loadingProducts.value = false

  if (storeRes.status === 'fulfilled') {
    stores.value = (storeRes.value || []).slice(0, 3)
  }

  if (articleRes.status === 'fulfilled') {
    articles.value = articleRes.value?.records || []
  }

  play()
})

onBeforeUnmount(stop)
</script>

<style scoped>
/* ---------------- Banner ---------------- */
.banner {
  position: relative;
  height: 460px;
  overflow: hidden;
  background: #241012;
}

.banner__track {
  display: flex;
  height: 100%;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.banner__slide {
  position: relative;
  flex: 0 0 100%;
  height: 100%;
}

.banner__img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner__img--fallback {
  background: linear-gradient(120deg, #2a0d10 0%, var(--brand-red-dark) 50%, var(--brand-red) 100%);
}

.banner__img--fallback::after {
  content: '猪事大吉';
  position: absolute;
  right: 6%;
  top: 50%;
  transform: translateY(-50%);
  font-size: 120px;
  font-weight: 900;
  letter-spacing: 8px;
  color: rgba(255, 255, 255, 0.06);
}

.banner__mask {
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(20, 8, 9, 0.82) 0%, rgba(20, 8, 9, 0.45) 55%, rgba(20, 8, 9, 0.15) 100%);
}

.banner__caption-wrap {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
}

.banner__caption {
  color: #fff;
}

.banner__kicker {
  display: inline-block;
  margin-bottom: 14px;
  padding: 5px 14px;
  border-radius: 999px;
  font-size: 13px;
  letter-spacing: 2px;
  color: var(--brand-gold-light);
  background: rgba(212, 163, 91, 0.16);
  border: 1px solid rgba(212, 163, 91, 0.4);
}

.banner__title {
  max-width: 620px;
  font-size: 42px;
  font-weight: 900;
  line-height: 1.25;
  letter-spacing: 2px;
}

.banner__sub {
  margin-top: 14px;
  font-size: 17px;
  color: rgba(255, 255, 255, 0.82);
}

.banner__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin-top: 30px;
}

.btn-outline {
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.6);
}

.btn-outline:hover {
  color: #241012;
  background: #fff;
}

.banner__arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 44px;
  height: 44px;
  border-radius: 50%;
  font-size: 26px;
  line-height: 1;
  color: #fff;
  background: rgba(255, 255, 255, 0.16);
  backdrop-filter: blur(4px);
  transition: var(--transition);
}

.banner__arrow:hover {
  background: var(--brand-red);
}

.banner__arrow--prev {
  left: 24px;
}

.banner__arrow--next {
  right: 24px;
}

.banner__dots {
  position: absolute;
  left: 50%;
  bottom: 22px;
  transform: translateX(-50%);
  display: flex;
  gap: 10px;
}

.banner__dot {
  width: 26px;
  height: 5px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.4);
  transition: var(--transition);
}

.banner__dot.active {
  width: 40px;
  background: var(--brand-gold);
}

/* ---------------- 服务承诺 ---------------- */
.promise {
  background: #fff;
  border-bottom: 1px solid var(--border-color);
}

.promise__inner {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  padding-top: 26px;
  padding-bottom: 26px;
}

.promise__item {
  display: flex;
  align-items: center;
  gap: 14px;
}

.promise__icon {
  font-size: 30px;
}

.promise__title {
  display: block;
  font-size: 16px;
  font-weight: 700;
}

.promise__desc {
  font-size: 13px;
  color: var(--text-muted);
}

/* ---------------- 品牌简介 ---------------- */
.about__inner {
  display: grid;
  grid-template-columns: 1.15fr 1fr;
  gap: 48px;
  align-items: center;
}

.about__slogan {
  margin: 18px 0 14px;
  font-size: 20px;
  font-weight: 800;
  color: var(--brand-red);
  letter-spacing: 1px;
}

.about__desc {
  color: var(--text-sub);
  line-height: 2;
}

.about__points {
  margin: 20px 0 28px;
}

.about__points li {
  position: relative;
  padding-left: 26px;
  margin-bottom: 10px;
  color: var(--text-sub);
}

.about__points li::before {
  content: '✓';
  position: absolute;
  left: 0;
  top: 0;
  width: 18px;
  height: 18px;
  margin-top: 5px;
  border-radius: 50%;
  font-size: 12px;
  line-height: 18px;
  text-align: center;
  color: #fff;
  background: var(--brand-gold);
}

.about__visual {
  position: relative;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.about__badge {
  position: absolute;
  right: -10px;
  top: -22px;
  z-index: 2;
  width: 96px;
  height: 96px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 15px;
  font-weight: 800;
  line-height: 1.3;
  text-align: center;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 12px 26px rgba(200, 22, 29, 0.32);
}

.about__badge small {
  font-size: 9px;
  letter-spacing: 1px;
  opacity: 0.8;
}

.about__card {
  padding: 26px 22px;
  border-radius: var(--radius);
  background: #fff;
  border: 1px solid var(--border-color);
  box-shadow: var(--shadow-card);
}

.about__card--gold {
  margin-top: 26px;
  background: linear-gradient(160deg, #fffaf3, #fdf1e2);
  border-color: rgba(212, 163, 91, 0.4);
}

.about__card-icon {
  font-size: 30px;
}

.about__card strong {
  display: block;
  margin: 10px 0 8px;
  font-size: 17px;
  color: var(--brand-red);
}

.about__card--gold strong {
  color: var(--brand-gold-dark);
}

.about__card p {
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

/* ---------------- 分类入口 ---------------- */
.categories {
  background: #fff;
}

.categories__grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.category-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 30px 16px;
  text-align: center;
  border: 1px solid var(--border-color);
  cursor: pointer;
}

.category-card__icon {
  font-size: 38px;
  transition: transform 0.35s ease;
}

.category-card:hover .category-card__icon {
  transform: scale(1.15) rotate(-6deg);
}

.category-card__name {
  font-size: 16px;
  font-weight: 700;
}

.category-card:hover .category-card__name {
  color: var(--brand-red);
}

.category-card__hint {
  font-size: 12.5px;
  color: var(--text-muted);
}

/* ---------------- 商品网格 ---------------- */
.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 22px;
}

/* ---------------- 门店 ---------------- */
.stores {
  background: linear-gradient(180deg, #fff 0%, var(--bg-page) 100%);
}

.stores__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}

.store-card {
  padding: 26px 24px;
  border: 1px solid var(--border-color);
}

.store-card__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.store-card__name {
  font-size: 17px;
  font-weight: 800;
}

.store-card__list li {
  display: flex;
  gap: 12px;
  margin-bottom: 10px;
  font-size: 14px;
  color: var(--text-sub);
}

.store-card__list li span {
  flex-shrink: 0;
  width: 40px;
  color: var(--text-muted);
}

.store-card__list a {
  color: var(--brand-red);
  font-weight: 700;
}

.store-card__link {
  display: inline-block;
  margin-top: 8px;
  font-size: 13px;
  font-weight: 600;
  color: var(--brand-gold-dark);
}

/* ---------------- 资讯 ---------------- */
.news__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}

.news-card {
  display: flex;
  gap: 18px;
  padding: 24px;
  border: 1px solid var(--border-color);
}

.news-card__date {
  flex-shrink: 0;
  width: 62px;
  height: 62px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  color: #fff;
  background: linear-gradient(150deg, var(--brand-red), var(--brand-red-light));
}

.news-card__date strong {
  font-size: 22px;
  line-height: 1.1;
}

.news-card__date span {
  font-size: 11px;
  opacity: 0.85;
}

.news-card__title {
  margin-bottom: 8px;
  font-size: 16px;
  font-weight: 700;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.news-card:hover .news-card__title {
  color: var(--brand-red);
}

.news-card__summary {
  font-size: 13.5px;
  color: var(--text-muted);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.news-card__meta {
  display: inline-block;
  margin-top: 10px;
  font-size: 12px;
  color: var(--brand-gold-dark);
}

/* ---------------- 团购 CTA ---------------- */
.cta {
  background: linear-gradient(120deg, var(--brand-red-dark), var(--brand-red) 70%, #e0503f);
  color: #fff;
}

.cta__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding-top: 40px;
  padding-bottom: 40px;
}

.cta__title {
  font-size: 26px;
  font-weight: 800;
  letter-spacing: 1px;
}

.cta__sub {
  margin-top: 8px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.82);
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 1200px) {
  .banner {
    height: 400px;
  }

  .banner__title {
    font-size: 34px;
  }

  .product-grid {
    grid-template-columns: repeat(3, 1fr);
  }

  .categories__grid {
    grid-template-columns: repeat(3, 1fr);
  }

  .stores__grid,
  .news__grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .banner {
    height: 340px;
  }

  .banner__title {
    font-size: 24px;
  }

  .banner__sub {
    font-size: 14px;
  }

  .banner__arrow {
    display: none;
  }

  .banner__img--fallback::after {
    font-size: 60px;
  }

  .promise__inner {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
  }

  .about__inner {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .about__visual {
    grid-template-columns: 1fr;
  }

  .about__badge {
    right: 4px;
    top: -14px;
    width: 78px;
    height: 78px;
    font-size: 13px;
  }

  .categories__grid,
  .product-grid,
  .stores__grid,
  .news__grid {
    grid-template-columns: 1fr;
  }

  .cta__inner {
    flex-direction: column;
    text-align: center;
  }
}
</style>
