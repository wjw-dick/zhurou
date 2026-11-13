<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/staff/performance', perm: 'staff:performance' }"
      title="业绩提成"
      :columns="columns"
      :filters="filters"
      :show-add="false"
      :show-edit="false"
      :show-delete="false"
      :show-actions="false"
      :action-width="0"
    >
      <template #toolbar>
        <el-button type="primary" @click="handleSummary">汇总</el-button>
      </template>
    </CrudTable>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessageBox } from 'element-plus'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()

const columns = [
  { prop: 'staffId', label: '店员ID', minWidth: 90 },
  { prop: 'statDate', label: '统计日期', minWidth: 120, type: 'date' },
  { prop: 'orderCount', label: '单数', minWidth: 90 },
  { prop: 'salesAmount', label: '销售额', minWidth: 110 },
  { prop: 'splitCount', label: '分割次数', minWidth: 100 },
  { prop: 'splitWeight', label: '分割重量(kg)', minWidth: 120 },
  { prop: 'commission', label: '提成', minWidth: 110 },
  { prop: 'createTime', label: '创建时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'staffId', label: '店员ID' },
  { prop: 'statDate', label: '统计日期', type: 'date' }
]

// 业绩汇总：展示接口返回的数据条数
async function handleSummary() {
  const res = await request.get('/staff/performance/summary', { staffId: undefined })
  const count = Array.isArray(res.data) ? res.data.length : res.data?.total ?? 0
  ElMessageBox.alert(`共返回 ${count} 条汇总数据`, '汇总结果', { type: 'success' })
}
</script>
