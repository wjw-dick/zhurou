<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/reserve/config', perm: 'reserve:config' }"
      title="预订配置"
      :columns="columns"
      :form-fields="formFields"
      :default-form="defaultForm"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'reserveDays', label: '可预订天数', minWidth: 120 },
  { prop: 'cutoffTime', label: '截止时间', minWidth: 110 },
  { prop: 'splitFeeCube', label: '切块费', minWidth: 100 },
  { prop: 'splitFeeMinced', label: '绞肉费', minWidth: 100 },
  { prop: 'splitFeeSliced', label: '切片费', minWidth: 100 },
  { prop: 'lossRate', label: '损耗率(%)', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const defaultForm = {
  reserveDays: 2,
  cutoffTime: '18:00',
  splitFeeCube: 0,
  splitFeeMinced: 0,
  splitFeeSliced: 0,
  lossRate: 3,
  status: 1
}

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'reserveDays', label: '可预订天数', type: 'number', precision: 0, span: 12 },
  { prop: 'cutoffTime', label: '截止时间', span: 12, placeholder: '如 18:00' },
  { prop: 'splitFeeCube', label: '切块费', type: 'number', span: 12 },
  { prop: 'splitFeeMinced', label: '绞肉费', type: 'number', span: 12 },
  { prop: 'splitFeeSliced', label: '切片费', type: 'number', span: 12 },
  { prop: 'lossRate', label: '损耗率(%)', type: 'number', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
