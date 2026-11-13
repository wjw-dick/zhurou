<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/staff/info', perm: 'staff:info' }"
      title="店员档案"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ staffType: 'CLERK', status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 员工类型字典：CLERK店员 / CUTTER分割师傅
const staffTypeDict: Record<string, { label: string; type?: string }> = {
  CLERK: { label: '店员', type: 'primary' },
  CUTTER: { label: '分割师傅', type: 'success' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '在职', type: 'success' },
  0: { label: '离职', type: 'danger' }
}

const columns = [
  { prop: 'name', label: '姓名', minWidth: 100 },
  { prop: 'phone', label: '手机号', minWidth: 120 },
  { prop: 'staffType', label: '员工类型', minWidth: 110, type: 'tag', dict: staffTypeDict },
  { prop: 'storeId', label: '所属门店', minWidth: 100 },
  { prop: 'commissionRate', label: '提成比例(%)', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  { prop: 'storeId', label: '所属门店' },
  {
    prop: 'staffType',
    label: '员工类型',
    type: 'select',
    options: Object.entries(staffTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '在职', value: 1 },
      { label: '离职', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'userId', label: '关联用户', type: 'number', precision: 0, required: true, placeholder: '关联系统用户ID', span: 12 },
  { prop: 'storeId', label: '所属门店', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'name', label: '姓名', required: true, span: 12 },
  { prop: 'phone', label: '手机号', span: 12 },
  {
    prop: 'staffType',
    label: '员工类型',
    type: 'select',
    span: 12,
    options: Object.entries(staffTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'commissionRate', label: '提成比例(%)', type: 'number', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
