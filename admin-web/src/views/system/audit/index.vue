<template>
  <div class="page-container">
    <CrudTable
      :api="{ base: '/system/audit', perm: 'sys:audit' }"
      title="审计日志"
      :columns="columns"
      :filters="filters"
      :show-add="false"
      :show-edit="false"
      :show-delete="false"
      :show-actions="false"
      :action-width="0"
    />
  </div>
</template>

<script setup lang="ts">
import CrudTable from '@/components/CrudTable/index.vue'

const columns = [
  { prop: 'username', label: '操作人', minWidth: 110 },
  { prop: 'module', label: '模块', minWidth: 110 },
  { prop: 'action', label: '动作', minWidth: 120 },
  { prop: 'method', label: '请求方式', width: 90 },
  { prop: 'uri', label: '请求地址', minWidth: 200 },
  { prop: 'ip', label: 'IP', minWidth: 130 },
  { prop: 'costMs', label: '耗时(ms)', width: 100 },
  {
    prop: 'status',
    label: '结果',
    width: 90,
    type: 'tag',
    dict: { 1: { label: '成功', type: 'success' }, 0: { label: '失败', type: 'danger' } }
  },
  { prop: 'createTime', label: '时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'username', label: '操作人' },
  { prop: 'status', label: '结果', type: 'select', options: [{ label: '成功', value: 1 }, { label: '失败', value: 0 }] },
  { prop: 'startTime', label: '开始日期', type: 'date' },
  { prop: 'endTime', label: '结束日期', type: 'date' }
]
</script>
