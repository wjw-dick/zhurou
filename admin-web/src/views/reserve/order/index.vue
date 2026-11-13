<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/order/info', perm: 'order:info' }"
      title="预订单"
      :columns="columns"
      :filters="filters"
      :page-params="{ orderType: 'RESERVE' }"
      :show-add="false"
      :show-edit="false"
      :show-delete="false"
      :show-actions="false"
      :action-width="0"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 订单状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  UNPAID: { label: '待支付', type: 'warning' },
  PREPARING: { label: '待备货', type: 'primary' },
  READY: { label: '待取货', type: 'warning' },
  DELIVERING: { label: '配送中', type: 'primary' },
  COMPLETED: { label: '已完成', type: 'success' },
  CANCELLED: { label: '已取消', type: 'info' }
}

// 配送方式字典
const deliveryTypeDict: Record<string, { label: string; type?: string }> = {
  SELF_PICKUP: { label: '到店自提', type: 'success' },
  DELIVERY: { label: '门店配送', type: 'primary' }
}

const columns = [
  { prop: 'orderNo', label: '订单号', minWidth: 180 },
  { prop: 'memberId', label: '会员ID', minWidth: 100 },
  { prop: 'storeId', label: '门店ID', minWidth: 100 },
  { prop: 'status', label: '订单状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'deliveryType', label: '配送方式', minWidth: 110, type: 'tag', dict: deliveryTypeDict },
  { prop: 'appointDate', label: '预订日期', minWidth: 120, type: 'date' },
  { prop: 'totalAmount', label: '商品总额', minWidth: 110 },
  { prop: 'payAmount', label: '实付金额', minWidth: 110 },
  { prop: 'payStatus', label: '支付状态', minWidth: 110 },
  { prop: 'createTime', label: '下单时间', minWidth: 170, type: 'date' }
]

const filters = [
  {
    prop: 'status',
    label: '订单状态',
    type: 'select',
    options: [
      { label: '待支付', value: 'UNPAID' },
      { label: '待备货', value: 'PREPARING' },
      { label: '待取货', value: 'READY' },
      { label: '配送中', value: 'DELIVERING' },
      { label: '已完成', value: 'COMPLETED' },
      { label: '已取消', value: 'CANCELLED' }
    ]
  },
  { prop: 'storeId', label: '门店ID' }
]
</script>
