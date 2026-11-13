<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/staff/order', perm: 'staff:order' }"
      title="称重开单"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :action-width="180"
    >
      <template #toolbar>
        <el-button type="primary" @click="handleCreate">称重开单</el-button>
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

const columns = [
  { prop: 'orderNo', label: '开单号', minWidth: 150 },
  { prop: 'staffId', label: '店员ID', minWidth: 90 },
  { prop: 'storeId', label: '门店ID', minWidth: 90 },
  { prop: 'productName', label: '商品名称', minWidth: 140 },
  { prop: 'price', label: '单价', minWidth: 100 },
  { prop: 'weight', label: '重量(kg)', minWidth: 100 },
  { prop: 'amount', label: '金额', minWidth: 100 },
  { prop: 'commission', label: '提成', minWidth: 100 },
  { prop: 'createTime', label: '开单时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'storeId', label: '门店ID' },
  { prop: 'staffId', label: '店员ID' }
]

const formFields = [
  { prop: 'staffId', label: '店员ID', type: 'number', precision: 0, span: 12 },
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, span: 12 },
  { prop: 'productName', label: '商品名称', span: 12 },
  { prop: 'price', label: '单价', type: 'number', span: 12 },
  { prop: 'weight', label: '重量(kg)', type: 'number', span: 12 }
]

// 快捷称重开单：直接用输入框收集重量后调用接口。
// 实际使用时可将此处替换为包含店员、门店、商品、单价等字段的完整表单弹窗。
async function handleCreate() {
  const { value } = await ElMessageBox.prompt('请输入实称重量（kg）', '称重开单', {
    inputPattern: /^\d+(\.\d+)?$/,
    inputErrorMessage: '请输入正确的重量',
    inputPlaceholder: '如 2.5'
  })
  await request.post('/staff/order/create', {
    staffId: 1,
    storeId: 1,
    productName: '手工开单',
    price: 30,
    weight: Number(value)
  })
  ElMessage.success('开单成功')
  crudRef.value?.loadData()
}
</script>
