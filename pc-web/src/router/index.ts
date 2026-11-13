import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

/* =========================================================
 * 路由表 —— 路径与后端 PC 平台菜单保持一致
 * （/  /brand  /products  /stores  /news  /contact）
 * ========================================================= */

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/Home.vue'),
    meta: { title: '首页' }
  },
  {
    path: '/brand',
    name: 'brand',
    component: () => import('@/views/Brand.vue'),
    meta: { title: '品牌故事' }
  },
  {
    path: '/products',
    name: 'products',
    component: () => import('@/views/Products.vue'),
    meta: { title: '产品展示' }
  },
  {
    path: '/products/:id',
    name: 'product-detail',
    component: () => import('@/views/ProductDetail.vue'),
    meta: { title: '商品详情' }
  },
  {
    path: '/stores',
    name: 'stores',
    component: () => import('@/views/Stores.vue'),
    meta: { title: '门店导航' }
  },
  {
    path: '/news',
    name: 'news',
    component: () => import('@/views/News.vue'),
    meta: { title: '新闻资讯' }
  },
  {
    path: '/news/:id',
    name: 'article-detail',
    component: () => import('@/views/ArticleDetail.vue'),
    meta: { title: '资讯详情' }
  },
  {
    path: '/contact',
    name: 'contact',
    component: () => import('@/views/Contact.vue'),
    meta: { title: '联系我们' }
  },
  {
    path: '/qualification',
    name: 'qualification',
    component: () => import('@/views/Qualification.vue'),
    meta: { title: '资质证照' }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '页面不存在' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(_to, _from, savedPosition) {
    return savedPosition || { top: 0 }
  }
})

// 动态设置页面标题
router.afterEach((to) => {
  const base = import.meta.env.VITE_APP_TITLE || '猪事大吉'
  const title = to.meta?.title as string | undefined
  document.title = title ? `${title} · ${base}` : base
})

export default router
