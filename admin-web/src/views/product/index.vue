<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/product/info', perm: 'product:info' }"
      title="商品"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="defaultForm"
      :action-width="240"
    >
      <template #toolbar>
        <span class="toolbar-tip">提示：商品审核通过后方可上架，可直接在行内执行审核、上架、下架操作</span>
      </template>
      <template #row-actions="{ row }">
        <el-button link type="success" @click="handleAudit(row)">审核</el-button>
        <el-button link type="primary" @click="handleStatus(row, 1)">上架</el-button>
        <el-button link type="warning" @click="handleStatus(row, 2)">下架</el-button>
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

// 业务类型字典
const bizTypeDict: Record<string, { label: string; type?: string }> = {
  PORK: { label: '鲜猪肉', type: 'danger' },
  HOTPOT: { label: '火锅食材', type: 'warning' },
  PROCESSED: { label: '肉制品', type: 'success' },
  BASE: { label: '底料蘸料', type: 'info' },
  SET: { label: '套餐礼盒', type: 'primary' }
}

// 商品状态字典：0待审核 1上架 2下架
const statusDict: Record<string, { label: string; type?: string }> = {
  0: { label: '待审核', type: 'warning' },
  1: { label: '上架', type: 'success' },
  2: { label: '下架', type: 'info' }
}

// 结算方式字典
const settleTypeDict: Record<string, { label: string }> = {
  WEIGHT: { label: '按重量' },
  FIXED: { label: '按份' }
}

const bizTypeOptions = Object.entries(bizTypeDict).map(([value, v]) => ({ label: v.label, value }))
const settleTypeOptions = Object.entries(settleTypeDict).map(([value, v]) => ({ label: v.label, value }))

const columns = [
  { prop: 'cover', label: '封面', minWidth: 80, type: 'image' },
  { prop: 'name', label: '商品名称', minWidth: 160 },
  { prop: 'subTitle', label: '副标题', minWidth: 160 },
  { prop: 'bizType', label: '业务类型', minWidth: 110, type: 'tag', dict: bizTypeDict },
  { prop: 'unit', label: '单位', minWidth: 80 },
  { prop: 'sales', label: '销量', minWidth: 80 },
  { prop: 'reservable', label: '可预订', minWidth: 90, type: 'bool' },
  { prop: 'splitEnabled', label: '可分割', minWidth: 90, type: 'bool' },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict },
  { prop: 'sort', label: '排序', minWidth: 80 }
]

const filters = [
  { prop: 'bizType', label: '业务类型', type: 'select', options: bizTypeOptions },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '待审核', value: 0 },
      { label: '上架', value: 1 },
      { label: '下架', value: 2 }
    ]
  },
  {
    prop: 'reservable',
    label: '可预订',
    type: 'select',
    options: [
      { label: '是', value: 1 },
      { label: '否', value: 0 }
    ]
  }
]

const defaultForm = {
  bizType: 'PORK',
  settleType: 'WEIGHT',
  reservable: 0,
  splitEnabled: 0,
  splitFee: 0,
  commissionRate: 0,
  sort: 0,
  status: 0
}

const formFields = [
  { prop: 'categoryId', label: '分类ID', type: 'number', precision: 0, span: 12 },
  { prop: 'name', label: '商品名称', required: true, span: 24 },
  { prop: 'subTitle', label: '副标题', span: 12 },
  { prop: 'bizType', label: '业务类型', type: 'select', span: 12, options: bizTypeOptions },
  { prop: 'cover', label: '封面图', type: 'image', span: 24 },
  { prop: 'detail', label: '商品详情', type: 'richtext', span: 24 },
  { prop: 'unit', label: '单位', span: 12 },
  { prop: 'origin', label: '产地', span: 12 },
  { prop: 'shelfLife', label: '保质期', span: 12 },
  { prop: 'storageCond', label: '储存条件', span: 12 },
  { prop: 'cookTip', label: '烹饪提示', type: 'textarea', span: 24 },
  { prop: 'reservable', label: '支持预订', type: 'switch', span: 12 },
  { prop: 'splitEnabled', label: '支持分割', type: 'switch', span: 12 },
  { prop: 'splitFee', label: '分割加工费', type: 'number', span: 12 },
  { prop: 'commissionRate', label: '佣金比例(%)', type: 'number', span: 12 },
  { prop: 'settleType', label: '结算方式', type: 'select', span: 12, options: settleTypeOptions },
  { prop: 'tags', label: '标签', span: 12 },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'number', precision: 0, span: 12 }
]

// 审核通过
async function handleAudit(row: any) {
  await ElMessageBox.confirm(`确定审核通过商品「${row.name}」吗？`, '审核确认', { type: 'warning' })
  await request.put(`/product/info/${row.id}/audit`, null, { params: { status: 1, remark: '审核通过' } })
  ElMessage.success('审核成功')
  crudRef.value?.loadData()
}

// 上架 / 下架
async function handleStatus(row: any, status: number) {
  const tip = status === 1 ? '上架' : '下架'
  await ElMessageBox.confirm(`确定${tip}商品「${row.name}」吗？`, `${tip}确认`, { type: 'warning' })
  await request.put(`/product/info/${row.id}/status`, null, { params: { status } })
  ElMessage.success(`${tip}成功`)
  crudRef.value?.loadData()
}
</script>

<style scoped>
.toolbar-tip {
  margin-left: 12px;
  color: #909399;
  font-size: 13px;
}
</style>
