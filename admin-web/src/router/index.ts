import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useUserStore } from '@/store/user'
import { usePermissionStore } from '@/store/permission'

const constantRoutes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/404',
    name: 'NotFound',
    component: () => import('@/views/error/404.vue'),
    meta: { title: '404' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes: constantRoutes,
  scrollBehavior: () => ({ top: 0 })
})

const WHITE_LIST = ['/login', '/404']

router.beforeEach(async (to, _from, next) => {
  const userStore = useUserStore()
  document.title = to.meta?.title ? `${to.meta.title} · 猪事大吉` : '猪事大吉 · 统一后台管理'

  if (WHITE_LIST.includes(to.path)) {
    next()
    return
  }
  if (!userStore.token) {
    next(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
    return
  }
  if (!userStore.loaded) {
    try {
      await userStore.loadUserInfo()
      const permissionStore = usePermissionStore()
      const routes = await permissionStore.generateRoutes()
      routes.forEach((route) => router.addRoute(route))
      next({ ...to, replace: true })
    } catch (e) {
      userStore.reset()
      next(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
    }
    return
  }
  next()
})

export default router
