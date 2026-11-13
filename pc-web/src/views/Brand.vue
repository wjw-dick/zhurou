<template>
  <div class="page brand-page">
    <PageBanner
      title="品牌故事"
      subtitle="猪事大吉 · 取「诸事大吉」之谐音，愿每一次下厨与相聚都顺顺利利"
      :crumbs="[{ label: '品牌故事' }]"
    />

    <!-- 谐音梗主视觉 -->
    <section class="section name-origin">
      <div class="container name-origin__inner">
        <div class="name-origin__chars">
          <div class="name-origin__char">
            <strong>猪</strong>
            <span>事</span>
            <span>大</span>
            <span>吉</span>
          </div>
          <div class="name-origin__equals">＝</div>
          <div class="name-origin__char name-origin__char--gold">
            <strong>诸</strong>
            <span>事</span>
            <span>大</span>
            <span>吉</span>
          </div>
        </div>

        <div class="name-origin__text">
          <h2 class="section-title">名字的由来</h2>
          <p>
            「猪事大吉」，是我们给这家社区鲜肉店的命名。它读起来是
            <em>「诸事大吉」</em>——凡事顺遂、万事如意。
          </p>
          <p>
            猪，是中国人餐桌上最熟悉的滋味；大吉，是每一次开火做饭时最朴素的期待。
            我们希望把这份好意头，连同当日新鲜的猪肉、火锅食材与肉制品，一起送进街坊邻居的厨房。
          </p>
          <p class="name-origin__quote">
            “把好肉卖给熟人，把好意头带回家。”
          </p>
        </div>
      </div>
    </section>

    <!-- 品牌正文（接口数据；无数据时展示内置文案） -->
    <section class="section story">
      <div class="container">
        <h2 class="section-title">品牌正文</h2>
        <p class="section-sub">内容由官网 CMS 维护（articleType = BRAND）</p>

        <div v-if="loading" class="state-tip">加载中…</div>

        <article v-else-if="brandArticle" class="story__article">
          <h3 class="story__title">{{ brandArticle.title }}</h3>
          <div class="story__meta">
            <span v-if="brandArticle.publishTime">发布于 {{ brandArticle.publishTime.slice(0, 10) }}</span>
            <span>阅读 {{ brandArticle.views || 0 }}</span>
          </div>
          <div class="rich-text" v-html="brandArticle.content"></div>
        </article>

        <!-- 内置兜底文案 -->
        <div v-else class="rich-text story__fallback">
          <p>
            <strong>猪事大吉，取「诸事大吉」谐音。</strong>
            我们是一家扎根社区的鲜肉与火锅食材超市，主打当日冷链直供的冷鲜猪肉，
            以及火锅食材、肉制品、底料蘸料与套餐礼盒。
          </p>
          <p>
            我们的鲜肉理念很简单：<strong>当日分割、当日配送，不卖隔夜肉</strong>。
            每天凌晨，合作屠宰场完成分割与冷却排酸，冷链车直送门店；
            门店按需分割、按份售卖，卖不完的当天进冷柜做预制或员工餐，绝不再上第二天的鲜肉台。
          </p>
          <p>
            每一批猪肉都随附
            <strong>《动物产品检疫合格证明》</strong>与<strong>《肉品品质检验合格证》</strong>，
            胴体加盖检疫验讫印章与肉品品质检验印章，即俗称的「两证两章」；
            加工类产品公示食品生产许可（SC）编号。所有证明均在官网
            <router-link to="/qualification">资质证照</router-link>栏目公示，欢迎查验。
          </p>
          <p>
            门店提供免费的切块、绞肉、切片加工服务，顾客也可以提前预订当日好肉，
            下班顺路到店自提，或选择门店配送，3 公里内当日送达。
          </p>
        </div>
      </div>
    </section>

    <!-- 鲜肉理念 -->
    <section class="section idea">
      <div class="container">
        <div class="section-head">
          <div>
            <h2 class="section-title">鲜肉理念</h2>
            <p class="section-sub">鲜，是可以被验证的</p>
          </div>
        </div>

        <div class="idea__grid">
          <div v-for="item in ideas" :key="item.title" class="idea-card card card-hover">
            <span class="idea-card__icon">{{ item.icon }}</span>
            <strong class="idea-card__title">{{ item.title }}</strong>
            <p class="idea-card__desc">{{ item.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 数据条 -->
    <section class="stats">
      <div class="container stats__inner">
        <div v-for="stat in stats" :key="stat.label" class="stats__item">
          <strong class="stats__value">{{ stat.value }}</strong>
          <span class="stats__label">{{ stat.label }}</span>
        </div>
      </div>
    </section>

    <!-- 我们的坚持 -->
    <section class="section insist">
      <div class="container insist__inner">
        <div>
          <h2 class="section-title">我们的坚持</h2>
          <ul class="insist__list">
            <li v-for="item in insists" :key="item">{{ item }}</li>
          </ul>
        </div>
        <div class="insist__cta">
          <p>想看看我们今天到了什么好肉？</p>
          <router-link to="/products" class="btn btn-primary">进入产品展示 →</router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import PageBanner from '@/components/PageBanner.vue'
import { getArticles, getStores, type Article } from '@/api'

const brandArticle = ref<Article | null>(null)
const loading = ref(true)
const storeCount = ref(0)

const ideas = [
  { icon: '🧊', title: '当日冷链', desc: '凌晨分割、冷链直送，门店当日售完为止，鲜肉不过夜。' },
  { icon: '📜', title: '两证两章', desc: '检疫合格证明 + 肉品品质检验合格证，胴体盖验讫印章。' },
  { icon: '🔪', title: '现切现分', desc: '门店免费切块 / 绞肉 / 切片，按需按份，不凑整不搭售。' },
  { icon: '🏘️', title: '社区半径', desc: '门店 3 公里内当日配送，下班顺路即可到店自提。' }
]

const insists = [
  '不注水、不注胶，只卖正经猪肉',
  '不缺斤少两，电子秤当面称重',
  '来源可溯，批批索证索票',
  '卖不完的鲜肉当日处理，绝不上第二天的鲜肉台',
  '加工类产品公示 SC 许可与检测报告'
]

const stats = computed(() => [
  { value: `${storeCount.value}`, label: '社区线下门店' },
  { value: '2 证 2 章', label: '批批随附、来源可溯' },
  { value: '3 km', label: '门店当日配送半径' },
  { value: '4 大品类', label: '鲜肉 / 火锅 / 肉制品 / 套餐' }
])

onMounted(async () => {
  const [articleRes, storeRes] = await Promise.allSettled([
    getArticles({ articleType: 'BRAND', size: 1, current: 1 }),
    getStores()
  ])

  if (articleRes.status === 'fulfilled') {
    brandArticle.value = articleRes.value?.records?.[0] || null
  }
  if (storeRes.status === 'fulfilled') {
    storeCount.value = storeRes.value?.length || 0
  }
  loading.value = false
})
</script>

<style scoped>
/* ---------------- 名字由来 ---------------- */
.name-origin {
  background: #fff;
}

.name-origin__inner {
  display: grid;
  grid-template-columns: 1fr 1.1fr;
  gap: 48px;
  align-items: center;
}

.name-origin__chars {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 18px;
  padding: 34px 20px;
  border-radius: var(--radius-lg);
  background: linear-gradient(160deg, #fff7f7, #fdf3e8);
  border: 1px solid rgba(200, 22, 29, 0.12);
}

.name-origin__char {
  display: flex;
  gap: 6px;
}

.name-origin__char strong,
.name-origin__char span {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 58px;
  border-radius: 10px;
  font-size: 24px;
  font-weight: 800;
  color: #fff;
  background: linear-gradient(160deg, var(--brand-red), var(--brand-red-dark));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.22);
}

.name-origin__char strong {
  background: linear-gradient(160deg, var(--brand-red-light), var(--brand-red));
  transform: translateY(-6px);
}

.name-origin__char--gold strong,
.name-origin__char--gold span {
  background: linear-gradient(160deg, var(--brand-gold), var(--brand-gold-dark));
  box-shadow: 0 6px 14px rgba(212, 163, 91, 0.3);
}

.name-origin__equals {
  font-size: 26px;
  font-weight: 800;
  color: var(--text-muted);
}

.name-origin__text p {
  margin-top: 14px;
  color: var(--text-sub);
  line-height: 2;
}

.name-origin__text em {
  font-style: normal;
  font-weight: 800;
  color: var(--brand-red);
}

.name-origin__quote {
  padding-left: 16px;
  border-left: 4px solid var(--brand-gold);
  font-size: 17px;
  font-weight: 700;
  color: var(--brand-gold-dark);
}

/* ---------------- 品牌正文 ---------------- */
.story {
  background: var(--bg-page);
}

.story__article {
  margin-top: 26px;
  padding: 34px 40px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-card);
}

.story__title {
  font-size: 24px;
  font-weight: 800;
  color: var(--text-main);
}

.story__meta {
  display: flex;
  gap: 18px;
  margin: 10px 0 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
  font-size: 13px;
  color: var(--text-muted);
}

.story__fallback {
  margin-top: 26px;
  padding: 34px 40px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-card);
}

.story__fallback a {
  color: var(--brand-red);
  font-weight: 700;
  text-decoration: underline;
}

/* ---------------- 鲜肉理念 ---------------- */
.idea {
  background: #fff;
}

.idea__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 22px;
}

.idea-card {
  padding: 30px 24px;
  border: 1px solid var(--border-color);
  border-top: 4px solid var(--brand-gold);
}

.idea-card__icon {
  font-size: 32px;
}

.idea-card__title {
  display: block;
  margin: 14px 0 10px;
  font-size: 18px;
  font-weight: 800;
  color: var(--brand-red);
}

.idea-card__desc {
  font-size: 14px;
  line-height: 1.9;
  color: var(--text-sub);
}

/* ---------------- 数据条 ---------------- */
.stats {
  background: linear-gradient(120deg, #241012, var(--brand-red-dark) 60%, var(--brand-red));
  color: #fff;
}

.stats__inner {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  padding-top: 38px;
  padding-bottom: 38px;
  text-align: center;
}

.stats__value {
  display: block;
  font-size: 30px;
  font-weight: 900;
  letter-spacing: 1px;
  color: var(--brand-gold-light);
}

.stats__label {
  font-size: 13.5px;
  color: rgba(255, 255, 255, 0.75);
}

/* ---------------- 坚持 ---------------- */
.insist {
  background: #fff;
}

.insist__inner {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 48px;
  align-items: center;
}

.insist__list {
  margin-top: 22px;
}

.insist__list li {
  position: relative;
  padding-left: 28px;
  margin-bottom: 14px;
  color: var(--text-sub);
}

.insist__list li::before {
  content: '✓';
  position: absolute;
  left: 0;
  top: 4px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  font-size: 12px;
  line-height: 18px;
  text-align: center;
  color: #fff;
  background: var(--brand-red);
}

.insist__cta {
  padding: 34px 30px;
  border-radius: var(--radius-lg);
  text-align: center;
  background: linear-gradient(160deg, #fff7f7, #fdf3e8);
  border: 1px solid rgba(212, 163, 91, 0.35);
}

.insist__cta p {
  margin-bottom: 18px;
  font-size: 17px;
  font-weight: 700;
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 992px) {
  .name-origin__inner,
  .insist__inner {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .idea__grid,
  .stats__inner {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .name-origin__char strong,
  .name-origin__char span {
    width: 32px;
    height: 42px;
    font-size: 18px;
  }

  .name-origin__equals {
    font-size: 18px;
  }

  .story__article,
  .story__fallback {
    padding: 22px 18px;
  }

  .idea__grid,
  .stats__inner {
    grid-template-columns: 1fr;
  }
}
</style>
