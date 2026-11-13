import { defineStore } from 'pinia'
import { request, getToken, setToken, clearToken } from '@/utils/request'

export interface LoginUser {
  userId: number
  username: string
  nickname: string
  avatar?: string
  userType?: string
  superAdmin: boolean
  storeId?: number
  storeName?: string
  roles: string[]
  perms: string[]
}

export const useUserStore = defineStore('user', {
  state: () => ({
    token: getToken(),
    userInfo: null as LoginUser | null,
    roles: [] as string[],
    perms: [] as string[],
    loaded: false
  }),
  getters: {
    isSuperAdmin: (state) => !!state.userInfo?.superAdmin
  },
  actions: {
    async login(username: string, password: string) {
      const res = await request.post('/auth/login', { username, password })
      this.token = res.data.token
      setToken(res.data.token)
      this.userInfo = res.data.userInfo
      this.roles = res.data.roles || []
      this.perms = res.data.perms || []
      this.loaded = true
      return res.data
    },
    async loadUserInfo() {
      const res = await request.get('/auth/info')
      this.userInfo = res.data
      this.roles = res.data.roles || []
      this.perms = res.data.perms || []
      this.loaded = true
      return res.data
    },
    /** 超管拥有全部功能维护权限 */
    hasPerm(perm?: string) {
      if (!perm) return true
      if (this.userInfo?.superAdmin) return true
      return this.perms.includes(perm) || this.perms.includes('*:*:*')
    },
    async logout() {
      try {
        await request.post('/auth/logout')
      } catch (e) {
        // ignore
      }
      this.reset()
    },
    reset() {
      this.token = ''
      this.userInfo = null
      this.roles = []
      this.perms = []
      this.loaded = false
      clearToken()
    }
  }
})
