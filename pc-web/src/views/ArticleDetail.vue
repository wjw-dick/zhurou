<template>
  <div class="page article-page">
    <!-- 面包屑 -->
    <div class="crumb-bar">
      <div class="container crumb-bar__inner">
        <router-link to="/">首页</router-link>
        <span>/</span>
        <router-link to="/news">新闻资讯</router-link>
        <span>/</span>
        <em>正文</em>
      </div>
    </div>

    <div class="container">
      <div v-if="loading" class="state-tip">加载中…</div>

      <div v-else-if="!article" class="state-tip empty">
        <p>文章不存在或已删除</p>
        <router-link to="/news" class="btn btn-primary" style="margin-top: 16px">返回资讯列表</router-link>
      </div>

      <article v-else class="article card">
        <header class="article__head">
          <span v-if="articleTypeLabel" class="tag">{{ articleTypeLabel }}</span>
          <h1 class="article__title">{{ article.title }}</h1>
          <div class="article__meta">
            <span>📅 {{ dateOf(article.publishTime || article.createTime) }}</span>
            <span>👁 阅读 {{ article.views || 0 }}</span>
            <span v-if="article.author">✍ {{ article.author }}</span>
            <span v-if="article.source">来源：{{ article.source }}</span>
          </div>
        </header>

        <p v-if="article.summary" class="article__summary">{{ article.summary }}</p>

        <div class="rich-text article__content" v-html="article.content"></div>

        <footer class="article__foot">
          <router-link to="/news" class="btn btn-ghost">← 返回资讯列表</router-link>
          <router-link to="/products" class="btn btn-primary">去看看鲜肉 →</router-link>
        </footer>
      </article>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { getArticleDetail, type Article } from '@/api'

const route = useRoute()

const article = ref<Article | null>(null)
const loading = ref(true)

const articleTypeMap: Record<string, string> = {
  NEWS: '行业资讯',
  BRAND: '品牌动态',
  CASE: '客户案例',
  PAGE: '单页内容'
}

const articleTypeLabel = computed(() =>
  article.value ? articleTypeMap[article.value.articleType] || '' : ''
)

function dateOf(time?: string) {
  return time ? time.slice(0, 10) : '—'
}

async function fetchArticle(id: string | string[]) {
  loading.value = true
  try {
    article.value = await getArticleDetail(id as string)
  } catch (e) {
    article.value = null
  } finally {
    loading.value = false
  }
}

watch(
  () => route.params.id,
  (id) => {
    if (id) fetchArticle(id)
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

.article {
  max-width: 920px;
  margin: 34px auto 0;
  padding: 44px 52px;
  border: 1px solid var(--border-color);
}

.article__head {
  padding-bottom: 22px;
  border-bottom: 1px solid var(--border-color);
}

.article__title {
  margin: 14px 0 16px;
  font-size: 30px;
  font-weight: 800;
  line-height: 1.45;
}

.article__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  font-size: 13px;
  color: var(--text-muted);
}

.article__summary {
  margin: 24px 0 10px;
  padding: 16px 20px;
  border-left: 4px solid var(--brand-gold);
  border-radius: 0 10px 10px 0;
  background: var(--bg-soft);
  font-size: 15px;
  color: var(--text-sub);
  line-height: 1.9;
}

.article__content {
  margin-top: 22px;
}

.article__foot {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  gap: 14px;
  margin-top: 40px;
  padding-top: 26px;
  border-top: 1px solid var(--border-color);
}

@media (max-width: 768px) {
  .article {
    padding: 26px 20px;
    margin-top: 20px;
  }

  .article__title {
    font-size: 21px;
  }

  .article__foot .btn {
    flex: 1;
  }
}
</style>
