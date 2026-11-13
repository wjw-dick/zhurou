<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/cms/banner', perm: 'cms:banner' }"
      title="Banner"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ position: 'PC_HOME', sort: 0, status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 展示位置字典
const positionDict: Record<string, { label: string; type?: string }> = {
  PC_HOME: { label: '官网首页', type: 'primary' },
  MINIAPP_HOME: { label: '小程序首页', type: 'success' },
  H5_HOME: { label: 'H5 首页', type: 'warning' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'image', label: '图片', minWidth: 80, type: 'image' },
  { prop: 'title', label: '标题', minWidth: 160 },
  { prop: 'position', label: '展示位置', minWidth: 120, type: 'tag', dict: positionDict },
  { prop: 'linkUrl', label: '跳转链接', minWidth: 200 },
  { prop: 'sort', label: '排序', minWidth: 80 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  {
    prop: 'position',
    label: '展示位置',
    type: 'select',
    options: Object.entries(positionDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'title', label: '标题', required: true, span: 12 },
  { prop: 'titleEn', label: '英文标题', span: 12 },
  { prop: 'image', label: '图片', type: 'image', required: true, span: 24 },
  { prop: 'linkUrl', label: '跳转链接', span: 12 },
  {
    prop: 'position',
    label: '展示位置',
    type: 'select',
    span: 12,
    options: Object.entries(positionDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
