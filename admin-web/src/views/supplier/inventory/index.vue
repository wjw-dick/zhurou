<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/inventory', perm: 'inventory:record' }"
      title="出入库"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ recordType: 'IN' }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const recordTypeDict: Record<string, { label: string; type?: string }> = {
  IN: { label: '入库', type: 'success' },
  OUT: { label: '出库', type: 'warning' },
  LOSS: { label: '损耗', type: 'danger' },
  CHECK: { label: '盘点', type: 'primary' }
}

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'productId', label: '商品ID', minWidth: 100 },
  { prop: 'recordType', label: '类型', minWidth: 100, type: 'tag', dict: recordTypeDict },
  { prop: 'quantity', label: '数量', minWidth: 100 },
  { prop: 'beforeStock', label: '变动前库存', minWidth: 120 },
  { prop: 'afterStock', label: '变动后库存', minWidth: 120 },
  { prop: 'remark', label: '备注', minWidth: 160 },
  { prop: 'createTime', label: '时间', minWidth: 170, type: 'date' }
]

const filters = [
  { prop: 'storeId', label: '门店ID', type: 'input' },
  {
    prop: 'recordType',
    label: '类型',
    type: 'select',
    options: Object.entries(recordTypeDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'productId', label: '商品ID', type: 'number', precision: 0, required: true, span: 12 },
  {
    prop: 'recordType',
    label: '类型',
    type: 'select',
    span: 12,
    options: Object.entries(recordTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'quantity', label: '数量', type: 'number', precision: 3, span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]
</script>
