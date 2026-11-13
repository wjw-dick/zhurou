<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/warning', perm: 'inventory:warning' }"
      title="库存预警"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ status: 'PENDING' }"
      :action-width="180"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="handleWarning(row)">处理</el-button>
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
  PENDING: { label: '待处理', type: 'warning' },
  HANDLED: { label: '已处理', type: 'success' }
}

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'productId', label: '商品ID', minWidth: 100 },
  { prop: 'skuId', label: 'SKU ID', minWidth: 100 },
  { prop: 'currentStock', label: '当前库存', minWidth: 110 },
  { prop: 'warnStock', label: '预警库存', minWidth: 110 },
  { prop: 'status', label: '状态', minWidth: 100, type: 'tag', dict: statusDict }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'productId', label: '商品ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'skuId', label: 'SKU ID', type: 'number', precision: 0, span: 12 },
  { prop: 'currentStock', label: '当前库存', type: 'number', precision: 3, span: 12 },
  { prop: 'warnStock', label: '预警库存', type: 'number', precision: 3, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12, activeValue: 'HANDLED', inactiveValue: 'PENDING' }
]

// 处理预警
async function handleWarning(row: any) {
  await ElMessageBox.confirm('确定处理该条库存预警吗？', '处理预警', {
    type: 'warning',
    confirmButtonText: '确定'
  })
  await request.put(`/supplier/warning/${row.id}/handle`)
  ElMessage.success('处理完成')
  crudRef.value?.loadData()
}
</script>
