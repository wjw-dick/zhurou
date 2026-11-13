<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/channel/price', perm: 'channel:price' }"
      title="渠道专属价"
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

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'channelId', label: '渠道商ID', minWidth: 100 },
  { prop: 'productId', label: '商品ID', minWidth: 100 },
  { prop: 'skuId', label: 'SKU ID', minWidth: 100 },
  { prop: 'price', label: '专属价', minWidth: 110 },
  { prop: 'startTime', label: '生效时间', minWidth: 140, type: 'date' },
  { prop: 'endTime', label: '失效时间', minWidth: 140, type: 'date' },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  { prop: 'channelId', label: '渠道商ID' },
  { prop: 'productId', label: '商品ID' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '启用', value: 1 },
      { label: '停用', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'channelId', label: '渠道商ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'productId', label: '商品ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'skuId', label: 'SKU ID', type: 'number', precision: 0, span: 12 },
  { prop: 'price', label: '专属价', type: 'number', required: true, span: 12 },
  { prop: 'startTime', label: '生效时间', type: 'date', span: 12 },
  { prop: 'endTime', label: '失效时间', type: 'date', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
