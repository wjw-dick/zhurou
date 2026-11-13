import axios, { type AxiosRequestConfig } from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'

const TOKEN_KEY = 'zhushi_token'

export function getToken(): string {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken(token: string) {
  localStorage.setItem(TOKEN_KEY, token)
}

export function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
}

const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || '/api',
  timeout: 30000
})

service.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

let relogining = false

service.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.code === 200) {
      return res
    }
    if (res.code === 401) {
      handleLogout()
      return Promise.reject(new Error(res.msg))
    }
    ElMessage.error(res.msg || '请求失败')
    return Promise.reject(new Error(res.msg || '请求失败'))
  },
  (error) => {
    const status = error?.response?.status
    if (status === 401) {
      handleLogout()
    } else {
      ElMessage.error(error?.response?.data?.msg || error.message || '网络异常')
    }
    return Promise.reject(error)
  }
)

function handleLogout() {
  if (relogining) return
  relogining = true
  clearToken()
  ElMessageBox.alert('登录状态已失效，请重新登录', '提示', {
    confirmButtonText: '重新登录',
    type: 'warning',
    callback: () => {
      relogining = false
      location.href = '/login'
    }
  })
}

export interface ApiResult<T = any> {
  code: number
  msg: string
  data: T
}

export const request = {
  get<T = any>(url: string, params?: any, config?: AxiosRequestConfig) {
    return service.get<any, ApiResult<T>>(url, { params, ...config })
  },
  post<T = any>(url: string, data?: any, config?: AxiosRequestConfig) {
    return service.post<any, ApiResult<T>>(url, data, config)
  },
  put<T = any>(url: string, data?: any, config?: AxiosRequestConfig) {
    return service.put<any, ApiResult<T>>(url, data, config)
  },
  delete<T = any>(url: string, params?: any) {
    return service.delete<any, ApiResult<T>>(url, { params })
  }
}

export interface PageData<T = any> {
  records: T[]
  total: number
  current: number
  size: number
}

export default service
