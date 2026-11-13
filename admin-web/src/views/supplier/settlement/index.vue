<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/settlement', perm: 'supplier:settlement' }"
      title="对账结算"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 'PENDING', paidAmount: 0 }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="primary" @click="handleConfirm(row)">确认</el-button>
        <el-button link type="success" @click="handlePay(row)">打款</el-button>
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
  PENDING: { label: '待结算', type: 'warning' },
  CONFIRMED: { label: '已确认', type: 'primary' },
  PAID: { label: '已打款', type: 'success' }
}

const columns = [
  { prop: 'settleNo', label: '对账单号', minWidth: 150 },
  { prop: 'supplierId', label: '供应商ID', minWidth: 100 },
  { prop: 'periodStart', label: '账期开始', minWidth: 120, type: 'date' },
  { prop: 'periodEnd', label: '账期结束', minWidth: 120, type: 'date' },
  { prop: 'amount', label: '应付金额', minWidth: 110 },
  { prop: 'paidAmount', label: '已付金额', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict }
]

const filters = [
  { prop: 'supplierId', label: '供应商ID', type: 'input' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'supplierId', label: '供应商ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'periodStart', label: '账期开始', type: 'date', span: 12 },
  { prop: 'periodEnd', label: '账期结束', type: 'date', span: 12 },
  { prop: 'amount', label: '应付金额', type: 'number', span: 12 },
  { prop: 'paidAmount', label: '已付金额', type: 'number', span: 12 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

// 确认对账
async function handleConfirm(row: any) {
  await ElMessageBox.confirm(`确定确认对账单「${row.settleNo}」吗？`, '确认对账', {
    type: 'warning',
    confirmButtonText: '确定'
  })
  await request.put(`/supplier/settlement/${row.id}/confirm`)
  ElMessage.success('对账确认完成')
  crudRef.value?.loadData()
}

// 付款打款
async function handlePay(row: any) {
  const { value } = await ElMessageBox.prompt(`请输入对账单「${row.settleNo}」的打款金额`, '供应商打款', {
    inputValue: String(row.amount ?? ''),
    inputPattern: /^\d+(\.\d{1,2})?$/,
    inputErrorMessage: '请输入正确的金额'
  })
  await request.put(`/supplier/settlement/${row.id}/pay`, null, { params: { paidAmount: value } })
  ElMessage.success('打款完成')
  crudRef.value?.loadData()
}
</script>
