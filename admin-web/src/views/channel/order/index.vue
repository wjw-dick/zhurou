<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/channel/order', perm: 'channel:order' }"
      title="报单审核"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 'SUBMITTED' }"
      :action-width="220"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="audit(row, 'APPROVED')">通过</el-button>
        <el-button link type="danger" @click="audit(row, 'REJECTED')">驳回</el-button>
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

// 报单状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  SUBMITTED: { label: '待审核', type: 'warning' },
  APPROVED: { label: '已通过', type: 'success' },
  REJECTED: { label: '已驳回', type: 'danger' },
  SETTLED: { label: '已结算', type: 'info' }
}

const columns = [
  { prop: 'reportNo', label: '报单号', minWidth: 140 },
  { prop: 'channelId', label: '渠道商ID', minWidth: 100 },
  { prop: 'orderNo', label: '关联订单号', minWidth: 140 },
  { prop: 'storeId', label: '门店ID', minWidth: 90 },
  { prop: 'amount', label: '报单金额', minWidth: 110 },
  { prop: 'commission', label: '佣金', minWidth: 100 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'auditRemark', label: '审核备注', minWidth: 140 },
  { prop: 'createTime', label: '报单时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'channelId', label: '渠道商ID' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'reportNo', label: '报单号', span: 12 },
  { prop: 'channelId', label: '渠道商ID', type: 'number', precision: 0, span: 12 },
  { prop: 'orderNo', label: '关联订单号', span: 12 },
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, span: 12 },
  { prop: 'amount', label: '报单金额', type: 'number', span: 12 },
  { prop: 'commission', label: '佣金', type: 'number', span: 12 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'auditRemark', label: '审核备注', span: 12 }
]

// 审核报单：APPROVED 通过 / REJECTED 驳回
async function audit(row: any, status: string) {
  const label = status === 'APPROVED' ? '通过' : '驳回'
  await ElMessageBox.confirm(`确定${label}报单「${row.reportNo || row.id}」吗？`, '提示', { type: 'warning' })
  await request.put(`/channel/order/${row.id}/audit`, null, { params: { status } })
  ElMessage.success(`已${label}`)
  crudRef.value?.loadData()
}
</script>
