<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/channel/settlement', perm: 'channel:settlement' }"
      title="渠道结算"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 'PENDING' }"
      :action-width="220"
    >
      <template #row-actions="{ row }">
        <el-button link type="primary" @click="confirm(row)">确认</el-button>
        <el-button link type="success" @click="pay(row)">打款</el-button>
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

// 结算状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  PENDING: { label: '待结算', type: 'warning' },
  CONFIRMED: { label: '已确认', type: 'primary' },
  PAID: { label: '已打款', type: 'success' }
}

const columns = [
  { prop: 'settleNo', label: '结算单号', minWidth: 150 },
  { prop: 'channelId', label: '渠道商ID', minWidth: 100 },
  { prop: 'periodStart', label: '结算开始', minWidth: 120, type: 'date' },
  { prop: 'periodEnd', label: '结算结束', minWidth: 120, type: 'date' },
  { prop: 'amount', label: '应结佣金', minWidth: 110 },
  { prop: 'paidAmount', label: '已打款', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict }
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
  { prop: 'settleNo', label: '结算单号', span: 12 },
  { prop: 'channelId', label: '渠道商ID', type: 'number', precision: 0, span: 12 },
  { prop: 'periodStart', label: '结算开始', type: 'date', span: 12 },
  { prop: 'periodEnd', label: '结算结束', type: 'date', span: 12 },
  { prop: 'amount', label: '应结佣金', type: 'number', span: 12 },
  { prop: 'paidAmount', label: '已打款金额', type: 'number', span: 12 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

// 确认结算单
async function confirm(row: any) {
  await ElMessageBox.confirm(`确定确认结算单「${row.settleNo || row.id}」吗？`, '提示', { type: 'warning' })
  await request.put(`/channel/settlement/${row.id}/confirm`)
  ElMessage.success('已确认')
  crudRef.value?.loadData()
}

// 打款：输入金额后调用打款接口
async function pay(row: any) {
  const { value } = await ElMessageBox.prompt('请输入本次打款金额', '打款', {
    inputPattern: /^\d+(\.\d+)?$/,
    inputErrorMessage: '请输入正确的金额',
    inputValue: String(row.amount ?? 0)
  })
  await request.put(`/channel/settlement/${row.id}/pay`, null, { params: { paidAmount: Number(value) } })
  ElMessage.success('打款成功')
  crudRef.value?.loadData()
}
</script>
