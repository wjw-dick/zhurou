<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/agreement', perm: 'supplier:agreement' }"
      title="供货协议"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const settleTypeDict: Record<string, { label: string; type?: string }> = {
  MONTH: { label: '月结', type: 'primary' },
  WEEK: { label: '周结', type: 'warning' },
  CASH: { label: '现结', type: 'success' }
}

const columns = [
  { prop: 'supplierId', label: '供应商ID', minWidth: 100 },
  { prop: 'agreementNo', label: '协议编号', minWidth: 140 },
  { prop: 'title', label: '协议名称', minWidth: 160 },
  { prop: 'startDate', label: '开始日期', minWidth: 120, type: 'date' },
  { prop: 'endDate', label: '结束日期', minWidth: 120, type: 'date' },
  { prop: 'settleType', label: '结算方式', minWidth: 100, type: 'tag', dict: settleTypeDict },
  { prop: 'fileUrl', label: '协议文件', minWidth: 100, type: 'image' },
  {
    prop: 'status',
    label: '状态',
    minWidth: 90,
    type: 'tag',
    dict: { 1: { label: '生效', type: 'success' }, 0: { label: '失效', type: 'danger' } }
  }
]

const filters = [
  { prop: 'supplierId', label: '供应商ID', type: 'input' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '生效', value: 1 },
      { label: '失效', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'supplierId', label: '供应商ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'agreementNo', label: '协议编号', span: 12 },
  { prop: 'title', label: '协议名称', span: 24 },
  { prop: 'startDate', label: '开始日期', type: 'date', span: 12 },
  { prop: 'endDate', label: '结束日期', type: 'date', span: 12 },
  {
    prop: 'settleType',
    label: '结算方式',
    type: 'select',
    span: 12,
    options: Object.entries(settleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'fileUrl', label: '协议文件', type: 'image', span: 24 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
