<template>
  <div class="page news-page">
    <PageBanner
      title="新闻资讯"
      subtitle="品牌动态 · 行业资讯 · 客户案例"
      :crumbs="[{ label: '新闻资讯' }]"
    />

    <div class="container news-body">
      <!-- 栏目筛选 -->
      <div class="type-tabs">
        <button
          v-for="tab in typeTabs"
          :key="tab.value"
          class="type-tabs__item"
          :class="{ active: articleType === tab.value }"
          @click="changeType(tab.value)"
        >
          {{ tab.label }}
        </button>
      </div>

      <div v-if="loading" class="state-tip">加载中…</div>

      <template v-else>
        <ul v-if="articles.length" class="news-list">
          <li v-for="article in articles" :key="article.id" class="news-item">
            <router-link :to="`/news/${article.id}`" class="news-item__link">
              <div class="news-item__cover">
                <img
                  v-if="article.cover && !failed[article.id]"
                  :src="article.cover"
                  :alt="article.title"
                  @error="failed[article.id] = true"
                />
                <div v-else class="thumb-placeholder">{{ article.title.charAt(0) }}</div>
                <span v-if="article.isTop === 1" class="news-item__top">置顶</span>
              </div>

              <div class="news-item__body">
                <h3 class="news-item__title">{{ article.title }}</h3>
                <p class="news-item__summary">{{ article.summary || '点击查看详情' }}</p>
                <div class="news-item__meta">
                  <span>📅 {{ dateOf(article.publishTime || article.createTime) }}</span>
                  <span>👁 阅读 {{ article.views || 0 }}</span>
                  <span v-if="article.author">{{ article.author }}</span>
                  <em class="news-item__more">阅读全文 →</em>
                </div>
              </div>
            </router-link>
          </li>
        </ul>

        <div v-else class="state-tip empty">暂无资讯</div>

        <Pagination :current="current" :size="size" :total="total" @change="changePage" />
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import PageBanner from '@/components/PageBanner.vue'
import Pagination from '@/components/Pagination.vue'
import { getArticles, type Article } from '@/api'

/** 栏目筛选（对应 articleType） */
const typeTabs = [
  { label: '全部', value: '' },
  { label: '品牌动态', value: 'BRAND' },
  { label: '行业资讯', value: 'NEWS' },
  { label: '客户案例', value: 'CASE' }
]

const articleType = ref('')
const current = ref(1)
const size = ref(10)
const total = ref(0)
const articles = ref<Article[]>([])
const loading = ref(true)
/** 记录封面加载失败的文章 */
const failed = reactive<Record<number, boolean>>({})

function dateOf(time?: string) {
  return time ? time.slice(0, 10) : '—'
}

async function fetchArticles() {
  loading.value = true
  try {
    const page = await getArticles({
      articleType: articleType.value || undefined,
      current: current.value,
      size: size.value
    })
    articles.value = page?.records || []
    total.value = page?.total || 0
  } catch (e) {
    articles.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

function changeType(value: string) {
  if (articleType.value === value) return
  articleType.value = value
  current.value = 1
  fetchArticles()
}

function changePage(page: number) {
  current.value = page
  fetchArticles()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(fetchArticles)
</script>

<style scoped>
.news-body {
  padding-top: 34px;
}

/* ---------------- 栏目 Tab ---------------- */
.type-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 24px;
}

.type-tabs__item {
  padding: 9px 22px;
  border-radius: 999px;
  font-size: 14.5px;
  font-weight: 600;
  color: var(--text-sub);
  background: #fff;
  border: 1px solid var(--border-color);
  transition: var(--transition);
}

.type-tabs__item:hover {
  color: var(--brand-red);
  border-color: rgba(200, 22, 29, 0.35);
}

.type-tabs__item.active {
  color: #fff;
  border-color: transparent;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.26);
}

/* ---------------- 列表 ---------------- */
.news-list {
  display: grid;
  gap: 20px;
}

.news-item {
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-sm);
  transition: var(--transition);
  overflow: hidden;
}

.news-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-hover);
}

.news-item__link {
  display: grid;
  grid-template-columns: 260px 1fr;
  gap: 24px;
  padding: 18px;
}

.news-item__cover {
  position: relative;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  border-radius: 12px;
  background: var(--bg-soft);
}

.news-item__cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.45s ease;
}

.news-item:hover .news-item__cover img {
  transform: scale(1.05);
}

.news-item__top {
  position: absolute;
  left: 10px;
  top: 10px;
  padding: 3px 12px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
}

.news-item__body {
  display: flex;
  flex-direction: column;
  padding: 6px 4px;
}

.news-item__title {
  margin-bottom: 12px;
  font-size: 19px;
  font-weight: 800;
  line-height: 1.5;
  transition: var(--transition);
}

.news-item:hover .news-item__title {
  color: var(--brand-red);
}

.news-item__summary {
  color: var(--text-muted);
  font-size: 14px;
  line-height: 1.9;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.news-item__meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 18px;
  margin-top: auto;
  padding-top: 16px;
  font-size: 13px;
  color: var(--text-muted);
}

.news-item__more {
  margin-left: auto;
  font-style: normal;
  font-weight: 700;
  color: var(--brand-red);
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 768px) {
  .news-item__link {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .news-item__title {
    font-size: 17px;
  }

  .news-item__meta {
    gap: 12px;
    font-size: 12px;
  }
}
</style>
