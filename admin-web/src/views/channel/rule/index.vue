<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/channel/rule', perm: 'channel:rule' }"
      title="佣金规则"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ level: 1, ruleType: 'RATE', status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 规则类型字典：RATE按比例 / FIXED固定金额
const ruleTypeDict: Record<string, { label: string; type?: string }> = {
  RATE: { label: '按比例', type: 'primary' },
  FIXED: { label: '固定金额', type: 'warning' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

// 适用品类
const bizTypeOptions = [
  { label: '全部', value: '' },
  { label: 'PORK 猪肉', value: 'PORK' },
  { label: 'HOTPOT 火锅', value: 'HOTPOT' },
  { label: 'PROCESSED 加工品', value: 'PROCESSED' },
  { label: 'BASE 底料', value: 'BASE' },
  { label: 'SET 套餐', value: 'SET' }
]

const columns = [
  { prop: 'name', label: '规则名称', minWidth: 140 },
  { prop: 'channelId', label: '渠道商', minWidth: 100, formatter: (row: any) => row.channelId || '全局' },
  { prop: 'bizType', label: '适用品类', minWidth: 120 },
  { prop: 'level', label: '层级', minWidth: 80 },
  { prop: 'ruleType', label: '规则类型', minWidth: 100, type: 'tag', dict: ruleTypeDict },
  { prop: 'rate', label: '佣金比例(%)', minWidth: 110 },
  { prop: 'fixedAmount', label: '固定佣金', minWidth: 100 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  { prop: 'channelId', label: '渠道商ID' },
  { prop: 'level', label: '层级', type: 'select', options: [{ label: '一级', value: 1 }, { label: '二级', value: 2 }] },
  {
    prop: 'ruleType',
    label: '规则类型',
    type: 'select',
    options: Object.entries(ruleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'name', label: '规则名称', required: true, span: 24 },
  { prop: 'channelId', label: '渠道商ID', type: 'number', precision: 0, placeholder: '留空=全局规则', span: 12 },
  { prop: 'bizType', label: '适用品类', type: 'select', options: bizTypeOptions, span: 12 },
  { prop: 'level', label: '层级', type: 'number', precision: 0, span: 12 },
  {
    prop: 'ruleType',
    label: '规则类型',
    type: 'select',
    span: 12,
    options: Object.entries(ruleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'rate', label: '佣金比例(%)', type: 'number', span: 12 },
  { prop: 'fixedAmount', label: '固定佣金', type: 'number', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
