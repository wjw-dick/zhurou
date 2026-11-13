<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/cms/category', perm: 'cms:category' }"
      title="官网栏目"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ sort: 0, status: 1 }"
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
  { prop: 'name', label: '栏目名称', minWidth: 140 },
  { prop: 'nameEn', label: '英文名称', minWidth: 140 },
  { prop: 'code', label: '栏目编码', minWidth: 120 },
  { prop: 'sort', label: '排序', minWidth: 80 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const formFields = [
  { prop: 'name', label: '栏目名称', required: true, span: 12 },
  { prop: 'nameEn', label: '英文名称', span: 12 },
  { prop: 'code', label: '栏目编码', span: 12 },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
