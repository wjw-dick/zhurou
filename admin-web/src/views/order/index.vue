<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/order/info', perm: 'order:info' }"
      title="订单"
      :columns="columns"
      :filters="filters"
      :show-add="false"
      :show-edit="false"
      :show-delete="false"
      :action-width="260"
    >
      <template #row-actions="{ row }">
        <el-button link type="primary" @click="handlePrepare(row)">备货</el-button>
        <el-button link type="success" @click="handleDeliver(row)">发货</el-button>
        <el-button link type="warning" @click="handleFinish(row)">完成</el-button>
        <el-button link type="danger" @click="handleCancel(row)">取消</el-button>
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

// 订单状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  UNPAID: { label: '待支付', type: 'warning' },
  PREPARING: { label: '待备货', type: 'primary' },
  READY: { label: '待取货', type: 'warning' },
  DELIVERING: { label: '配送中', type: 'primary' },
  COMPLETED: { label: '已完成', type: 'success' },
  CANCELLED: { label: '已取消', type: 'info' },
  AFTERSALE: { label: '售后', type: 'danger' }
}

// 订单类型字典
const orderTypeDict: Record<string, { label: string; type?: string }> = {
  NORMAL: { label: '普通订单', type: 'primary' },
  RESERVE: { label: '鲜肉预订', type: 'success' },
  SET: { label: '火锅套餐', type: 'warning' },
  GIFT: { label: '礼盒', type: 'danger' }
}

// 配送方式字典
const deliveryTypeDict: Record<string, { label: string; type?: string }> = {
  SELF_PICKUP: { label: '到店自提', type: 'success' },
  DELIVERY: { label: '门店配送', type: 'primary' }
}

const statusOptions = Object.entries(statusDict).map(([value, v]) => ({ label: v.label, value }))
const orderTypeOptions = Object.entries(orderTypeDict).map(([value, v]) => ({ label: v.label, value }))

const columns = [
  { prop: 'orderNo', label: '订单号', minWidth: 180 },
  { prop: 'orderType', label: '订单类型', minWidth: 110, type: 'tag', dict: orderTypeDict },
  { prop: 'source', label: '来源', minWidth: 100 },
  { prop: 'memberId', label: '会员ID', minWidth: 100 },
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'status', label: '订单状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'deliveryType', label: '配送方式', minWidth: 110, type: 'tag', dict: deliveryTypeDict },
  { prop: 'payAmount', label: '实付金额', minWidth: 110 },
  { prop: 'payStatus', label: '支付状态', minWidth: 110 },
  { prop: 'createTime', label: '下单时间', minWidth: 170, type: 'date' }
]

const filters = [
  { prop: 'status', label: '订单状态', type: 'select', options: statusOptions },
  { prop: 'orderType', label: '订单类型', type: 'select', options: orderTypeOptions },
  { prop: 'storeId', label: '门店ID' },
  { prop: 'orderNo', label: '订单号' }
]

// 备货
async function handlePrepare(row: any) {
  await ElMessageBox.confirm(`确定对订单「${row.orderNo}」执行备货吗？`, '备货确认', { type: 'warning' })
  await request.put(`/order/info/${row.id}/prepare`)
  ElMessage.success('备货成功')
  crudRef.value?.loadData()
}

// 发货
async function handleDeliver(row: any) {
  await ElMessageBox.confirm(`确定对订单「${row.orderNo}」执行发货吗？`, '发货确认', { type: 'warning' })
  await request.put(`/order/info/${row.id}/deliver`)
  ElMessage.success('发货成功')
  crudRef.value?.loadData()
}

// 完成
async function handleFinish(row: any) {
  await ElMessageBox.confirm(`确定将订单「${row.orderNo}」标记为完成吗？`, '完成确认', { type: 'warning' })
  await request.put(`/order/info/${row.id}/finish`)
  ElMessage.success('订单已完成')
  crudRef.value?.loadData()
}

// 取消
async function handleCancel(row: any) {
  await ElMessageBox.confirm(`确定取消订单「${row.orderNo}」吗？`, '取消确认', {
    type: 'warning',
    confirmButtonText: '确定取消',
    confirmButtonClass: 'el-button--danger'
  })
  await request.put(`/order/info/${row.id}/cancel`, null, { params: { reason: '后台操作' } })
  ElMessage.success('订单已取消')
  crudRef.value?.loadData()
}
</script>
