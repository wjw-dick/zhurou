<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/purchase', perm: 'purchase:order' }"
      title="供货单"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 'CREATED' }"
      :action-width="180"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="handleReceive(row)">入库</el-button>
      </template>
    </CrudTable>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()

const statusDict: Record<string, { label: string; type?: string }> = {
  CREATED: { label: '待发货', type: 'info' },
  DELIVERING: { label: '配送中', type: 'warning' },
  RECEIVED: { label: '已入库', type: 'success' },
  CHECKING: { label: '对账中', type: 'primary' },
  SETTLED: { label: '已结算', type: 'success' }
}

const columns = [
  { prop: 'purchaseNo', label: '供货单号', minWidth: 150 },
  { prop: 'supplierId', label: '供应商ID', minWidth: 100 },
  { prop: 'storeId', label: '门店ID', minWidth: 90 },
  { prop: 'totalAmount', label: '供货金额', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'receiveTime', label: '收货时间', minWidth: 170, type: 'date' },
  { prop: 'createTime', label: '创建时间', minWidth: 170, type: 'date' }
]

const filters = [
  { prop: 'supplierId', label: '供应商ID', type: 'input' },
  { prop: 'storeId', label: '门店ID', type: 'input' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'supplierId', label: '供应商ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'totalAmount', label: '供货金额', type: 'number', span: 12 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

// 收货入库
async function handleReceive(row: any) {
  await ElMessageBox.confirm(`确定将供货单「${row.purchaseNo}」入库吗？`, '入库确认', {
    type: 'warning',
    confirmButtonText: '确定入库'
  })
  await request.put(`/supplier/purchase/${row.id}/receive`, null, { params: { storeId: row.storeId } })
  ElMessage.success('入库成功')
  crudRef.value?.loadData()
}
</script>
