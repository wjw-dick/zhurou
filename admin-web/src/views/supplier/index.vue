<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/info', perm: 'supplier:info' }"
      title="供应商"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ supplyType: 'PORK', settleType: 'MONTH', rating: 5, status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const supplyTypeDict: Record<string, { label: string; type?: string }> = {
  PORK: { label: '鲜猪肉', type: 'danger' },
  HOTPOT: { label: '火锅食材', type: 'warning' },
  PROCESSED: { label: '肉制品', type: 'primary' },
  BASE: { label: '底料', type: 'success' }
}

const settleTypeDict: Record<string, { label: string; type?: string }> = {
  MONTH: { label: '月结', type: 'primary' },
  WEEK: { label: '周结', type: 'warning' },
  CASH: { label: '现结', type: 'success' }
}

const columns = [
  { prop: 'code', label: '供应商编码', minWidth: 130 },
  { prop: 'name', label: '供应商名称', minWidth: 160 },
  { prop: 'contact', label: '联系人', minWidth: 110 },
  { prop: 'phone', label: '联系电话', minWidth: 130 },
  { prop: 'supplyType', label: '供货类型', minWidth: 110, type: 'tag', dict: supplyTypeDict },
  { prop: 'settleType', label: '结算方式', minWidth: 100, type: 'tag', dict: settleTypeDict },
  { prop: 'rating', label: '评分', minWidth: 80 },
  {
    prop: 'status',
    label: '状态',
    minWidth: 90,
    type: 'tag',
    dict: { 1: { label: '合作', type: 'success' }, 0: { label: '停用', type: 'danger' } }
  }
]

const filters = [
  {
    prop: 'supplyType',
    label: '供货类型',
    type: 'select',
    options: Object.entries(supplyTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '合作', value: 1 },
      { label: '停用', value: 0 }
    ]
  },
  { prop: 'name', label: '供应商名称', type: 'input' }
]

const formFields = [
  { prop: 'code', label: '供应商编码', required: true, span: 12 },
  { prop: 'name', label: '供应商名称', required: true, span: 12 },
  { prop: 'userId', label: '登录账号ID', type: 'number', precision: 0, span: 12 },
  { prop: 'contact', label: '联系人', span: 12 },
  { prop: 'phone', label: '联系电话', span: 12 },
  { prop: 'address', label: '地址', span: 24 },
  {
    prop: 'supplyType',
    label: '供货类型',
    type: 'select',
    span: 12,
    options: Object.entries(supplyTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'settleType',
    label: '结算方式',
    type: 'select',
    span: 12,
    options: Object.entries(settleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'bankName', label: '开户银行', span: 12 },
  { prop: 'bankAccount', label: '银行账号', span: 12 },
  { prop: 'bankHolder', label: '开户人', span: 12 },
  { prop: 'rating', label: '评分(1-5)', type: 'number', precision: 1, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]
</script>
