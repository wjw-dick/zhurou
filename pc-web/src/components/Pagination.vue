<template>
  <div v-if="totalPages > 1" class="pagination">
    <button class="pagination__btn" :disabled="current <= 1" @click="go(current - 1)">上一页</button>

    <button
      v-for="(page, index) in pageList"
      :key="index"
      class="pagination__btn pagination__num"
      :class="{ active: page === current, ellipsis: page === -1 }"
      :disabled="page === -1"
      @click="page !== -1 && go(page)"
    >
      {{ page === -1 ? '…' : page }}
    </button>

    <button
      class="pagination__btn"
      :disabled="current >= totalPages"
      @click="go(current + 1)"
    >
      下一页
    </button>

    <span class="pagination__total">共 {{ total }} 条</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  current: number
  size: number
  total: number
}>()

const emit = defineEmits<{ (e: 'change', page: number): void }>()

const totalPages = computed(() => Math.max(1, Math.ceil((props.total || 0) / (props.size || 10))))

/** 生成页码（含省略号，最多展示 7 个按钮） */
const pageList = computed(() => {
  const total = totalPages.value
  const cur = props.current
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)

  const list: number[] = [1]
  const start = Math.max(2, cur - 1)
  const end = Math.min(total - 1, cur + 1)
  if (start > 2) list.push(-1)
  for (let i = start; i <= end; i++) list.push(i)
  if (end < total - 1) list.push(-1)
  list.push(total)
  return list
})

function go(page: number) {
  if (page < 1 || page > totalPages.value || page === props.current) return
  emit('change', page)
}
</script>

<style scoped>
.pagination {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 36px;
}

.pagination__btn {
  min-width: 38px;
  height: 38px;
  padding: 0 14px;
  border-radius: 10px;
  border: 1px solid var(--border-color);
  background: #fff;
  font-size: 14px;
  color: var(--text-sub);
  transition: var(--transition);
}

.pagination__btn:hover:not(:disabled):not(.active) {
  color: var(--brand-red);
  border-color: var(--brand-red);
}

.pagination__btn.active {
  color: #fff;
  border-color: transparent;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
  box-shadow: 0 6px 14px rgba(200, 22, 29, 0.28);
}

.pagination__btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination__btn.ellipsis {
  opacity: 1;
  border: none;
  background: transparent;
  cursor: default;
}

.pagination__total {
  margin-left: 6px;
  font-size: 13px;
  color: var(--text-muted);
}
</style>
