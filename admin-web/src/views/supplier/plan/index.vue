<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/plan', perm: 'purchase:plan' }"
      title="采购计划"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 'DRAFT' }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const statusDict: Record<string, { label: string; type?: string }> = {
  DRAFT: { label: '草稿', type: 'info' },
  SUBMITTED: { label: '已提交', type: 'warning' },
  DONE: { label: '已采购', type: 'success' }
}

const columns = [
  { prop: 'planNo', label: '计划单号', minWidth: 150 },
  { prop: 'planDate', label: '计划日期', minWidth: 120, type: 'date' },
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'totalAmount', label: '计划金额', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'remark', label: '备注', minWidth: 160 }
]

const filters = [
  { prop: 'storeId', label: '门店ID', type: 'input' },
  { prop: 'planDate', label: '计划日期', type: 'date' }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'planDate', label: '计划日期', type: 'date', required: true, span: 12 },
  { prop: 'totalAmount', label: '计划金额', type: 'number', span: 12 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]
</script>
