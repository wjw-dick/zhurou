<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/staff/split', perm: 'staff:split' }"
      title="分割登记"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ splitType: 'CUBE' }"
      :action-width="180"
    >
      <template #toolbar>
        <el-button type="primary" @click="handleRegister">分割登记</el-button>
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

// 分割方式字典
const splitTypeDict: Record<string, { label: string; type?: string }> = {
  CUBE: { label: '切块', type: 'primary' },
  MINCED: { label: '绞肉', type: 'warning' },
  SLICED: { label: '切片', type: 'success' },
  NONE: { label: '不分割', type: 'info' }
}

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 90 },
  { prop: 'staffId', label: '店员ID', minWidth: 90 },
  { prop: 'orderNo', label: '关联订单号', minWidth: 140 },
  { prop: 'productName', label: '商品名称', minWidth: 140 },
  { prop: 'splitType', label: '分割方式', minWidth: 100, type: 'tag', dict: splitTypeDict },
  { prop: 'weight', label: '加工重量(kg)', minWidth: 120 },
  { prop: 'splitFee', label: '加工费', minWidth: 100 },
  { prop: 'createTime', label: '登记时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'storeId', label: '门店ID' },
  { prop: 'staffId', label: '店员ID' },
  {
    prop: 'splitType',
    label: '分割方式',
    type: 'select',
    options: Object.entries(splitTypeDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, span: 12 },
  { prop: 'staffId', label: '店员ID', type: 'number', precision: 0, span: 12 },
  { prop: 'orderId', label: '关联订单ID', type: 'number', precision: 0, span: 12 },
  { prop: 'orderNo', label: '关联订单号', span: 12 },
  { prop: 'productName', label: '商品名称', span: 12 },
  {
    prop: 'splitType',
    label: '分割方式',
    type: 'select',
    span: 12,
    options: Object.entries(splitTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'weight', label: '加工重量(kg)', type: 'number', span: 12 },
  { prop: 'splitFee', label: '加工费', type: 'number', span: 12 }
]

// 快捷分割登记：直接用输入框收集重量后调用接口。
// 实际使用时可将此处替换为包含门店、店员、商品、分割方式等字段的完整表单弹窗。
async function handleRegister() {
  const { value } = await ElMessageBox.prompt('请输入本次分割重量（kg）', '分割登记', {
    inputPattern: /^\d+(\.\d+)?$/,
    inputErrorMessage: '请输入正确的重量',
    inputPlaceholder: '如 1.5'
  })
  await request.post('/staff/split/register', {
    storeId: 1,
    staffId: 1,
    productName: '手工登记',
    splitType: 'CUBE',
    weight: Number(value),
    splitFee: 0
  })
  ElMessage.success('分割登记成功')
  crudRef.value?.loadData()
}
</script>
