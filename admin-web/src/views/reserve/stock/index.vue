<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/reserve/stock', perm: 'reserve:stock' }"
      title="备货量"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ capacity: 0 }"
      :action-width="180"
    >
      <template #toolbar>
        <el-button type="success" :icon="DataAnalysis" @click="handleSummary">备货汇总</el-button>
      </template>
    </CrudTable>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessageBox } from 'element-plus'
import { DataAnalysis } from '@element-plus/icons-vue'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()

const columns = [
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'productId', label: '商品ID', minWidth: 100 },
  { prop: 'skuId', label: '规格ID', minWidth: 100 },
  { prop: 'reserveDate', label: '预订日期', minWidth: 120, type: 'date' },
  { prop: 'capacity', label: '备货量', minWidth: 100 },
  { prop: 'booked', label: '已订', minWidth: 100 },
  { prop: 'version', label: '版本号', minWidth: 90 }
]

const filters = [
  { prop: 'storeId', label: '门店ID' },
  { prop: 'reserveDate', label: '预订日期', type: 'date' }
]

const formFields = [
  { prop: 'storeId', label: '门店ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'productId', label: '商品ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'skuId', label: '规格ID', type: 'number', precision: 0, span: 12 },
  { prop: 'reserveDate', label: '预订日期', type: 'date', span: 12 },
  { prop: 'capacity', label: '备货量', type: 'number', precision: 0, span: 12 }
]

// 查看备货汇总
async function handleSummary() {
  const res = await request.get('/reserve/stock/summary', { reserveDate: '', storeId: undefined })
  const rows = res.data
  const count = Array.isArray(rows) ? rows.length : rows ? Object.keys(rows).length : 0
  ElMessageBox.alert(
    `<div>共 ${count} 条汇总记录</div><pre style="max-height: 320px; overflow: auto; margin: 8px 0 0">${JSON.stringify(
      rows,
      null,
      2
    )}</pre>`,
    '备货汇总',
    { dangerouslyUseHTMLString: true, confirmButtonText: '确定' }
  )
}
</script>
