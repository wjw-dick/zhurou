import { defineStore } from 'pinia'
import type { RouteRecordRaw } from 'vue-router'
import { request } from '@/utils/request'
import Layout from '@/layout/index.vue'

const viewModules = import.meta.glob('../views/**/*.vue')

export interface BackendRoute {
  id: number
  name: string
  path: string
  component?: string
  meta: { title: string; titleEn?: string; icon?: string; hidden?: boolean; keepAlive?: boolean; perm?: string }
  children?: BackendRoute[]
}

function toRoute(route: BackendRoute): RouteRecordRaw {
  const record: any = {
    path: route.path,
    name: route.path?.replace(/\//g, '_') || String(route.id),
    meta: { ...route.meta, title: route.meta?.title }
  }
  if (route.component) {
    const key = `../views/${route.component}.vue`
    record.component = viewModules[key] || (() => import('@/views/error/404.vue'))
  }
  if (route.children && route.children.length > 0) {
    record.children = route.children.map(toRoute)
  }
  return record as RouteRecordRaw
}

export const usePermissionStore = defineStore('permission', {
  state: () => ({
    routes: [] as RouteRecordRaw[],
    generated: false
  }),
  actions: {
    async generateRoutes(): Promise<RouteRecordRaw[]> {
      const res = await request.get<BackendRoute[]>('/auth/routes')
      const backendRoutes = (res.data || []).map(toRoute)
      const layoutRoute: RouteRecordRaw = {
        path: '/',
        name: 'Layout',
        component: Layout,
        redirect: backendRoutes[0]?.path || '/dashboard',
        children: backendRoutes
      } as RouteRecordRaw
      this.routes = [layoutRoute]
      this.generated = true
      return this.routes
    },
    reset() {
      this.routes = []
      this.generated = false
    }
  }
})
