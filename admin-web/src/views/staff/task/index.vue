<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/staff/task', perm: 'staff:task' }"
      title="备货待办"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ taskType: 'PREPARE', status: 'PENDING' }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="primary" @click="assign(row)">派单</el-button>
        <el-button link type="success" @click="done(row)">完成</el-button>
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

// 任务类型字典
const taskTypeDict: Record<string, { label: string; type?: string }> = {
  PREPARE: { label: '备货', type: 'primary' },
  SPLIT: { label: '分割', type: 'warning' },
  PICK: { label: '配货', type: 'success' },
  DELIVER: { label: '配送', type: 'info' }
}

// 任务状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  PENDING: { label: '待办', type: 'warning' },
  DOING: { label: '进行中', type: 'primary' },
  DONE: { label: '已完成', type: 'success' }
}

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 90 },
  { prop: 'staffId', label: '店员ID', minWidth: 90 },
  { prop: 'orderNo', label: '关联订单号', minWidth: 140 },
  { prop: 'taskType', label: '任务类型', minWidth: 100, type: 'tag', dict: taskTypeDict },
  { prop: 'taskDate', label: '任务日期', minWidth: 120, type: 'date' },
  { prop: 'content', label: '任务内容', minWidth: 180 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'finishTime', label: '完成时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'storeId', label: '门店ID' },
  { prop: 'staffId', label: '店员ID' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'taskDate', label: '任务日期', type: 'date' }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, span: 12 },
  { prop: 'staffId', label: '店员ID', type: 'number', precision: 0, span: 12 },
  { prop: 'orderId', label: '关联订单ID', type: 'number', precision: 0, span: 12 },
  { prop: 'orderNo', label: '关联订单号', span: 12 },
  {
    prop: 'taskType',
    label: '任务类型',
    type: 'select',
    span: 12,
    options: Object.entries(taskTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'taskDate', label: '任务日期', type: 'date', span: 12 },
  { prop: 'content', label: '任务内容', type: 'textarea', span: 24 },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    span: 12,
    options: Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

// 派单：输入店员ID后指派任务
async function assign(row: any) {
  const { value } = await ElMessageBox.prompt('请输入要指派的店员ID', '派单', {
    inputPattern: /^\d+$/,
    inputErrorMessage: '请输入正确的店员ID',
    inputPlaceholder: '店员ID'
  })
  await request.put(`/staff/task/${row.id}/assign`, null, { params: { staffId: Number(value) } })
  ElMessage.success('派单成功')
  crudRef.value?.loadData()
}

// 完成：标记任务已完成
async function done(row: any) {
  await ElMessageBox.confirm(`确定将该待办标记为已完成吗？`, '提示', { type: 'warning' })
  await request.put(`/staff/task/${row.id}/done`)
  ElMessage.success('已完成')
  crudRef.value?.loadData()
}
</script>
