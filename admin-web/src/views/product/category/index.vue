<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/product/category', perm: 'product:category' }"
      title="商品分类"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ parentId: 0, bizType: 'PORK', sort: 0, status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 业务类型字典
const bizTypeDict: Record<string, { label: string; type?: string }> = {
  PORK: { label: '鲜猪肉', type: 'danger' },
  HOTPOT: { label: '火锅食材', type: 'warning' },
  PROCESSED: { label: '肉制品', type: 'success' },
  BASE: { label: '底料蘸料', type: 'info' },
  SET: { label: '套餐礼盒', type: 'primary' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const bizTypeOptions = Object.entries(bizTypeDict).map(([value, v]) => ({ label: v.label, value }))

const columns = [
  { prop: 'id', label: 'ID', minWidth: 80 },
  { prop: 'name', label: '分类名称', minWidth: 140 },
  { prop: 'nameEn', label: '英文名称', minWidth: 140 },
  { prop: 'bizType', label: '业务类型', minWidth: 110, type: 'tag', dict: bizTypeDict },
  { prop: 'sort', label: '排序', minWidth: 80 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const formFields = [
  {
    prop: 'parentId',
    label: '上级分类',
    type: 'number',
    precision: 0,
    span: 12,
    placeholder: '上级分类ID，顶级填 0'
  },
  { prop: 'name', label: '分类名称', required: true, span: 12 },
  { prop: 'nameEn', label: '英文名称', span: 12 },
  { prop: 'bizType', label: '业务类型', type: 'select', span: 12, options: bizTypeOptions },
  { prop: 'icon', label: '分类图标', span: 12 },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
