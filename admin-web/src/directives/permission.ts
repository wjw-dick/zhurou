import type { Directive } from 'vue'
import { useUserStore } from '@/store/user'

/**
 * 按钮级权限：v-perm="'sys:user:add'"；超管自动放行
 */
export const permission: Directive = {
  mounted(el: HTMLElement, binding) {
    const perm = binding.value as string
    const userStore = useUserStore()
    if (perm && !userStore.hasPerm(perm)) {
      el.parentNode?.removeChild(el)
    }
  }
}
