<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/member/coupon', perm: 'member:coupon' }"
      title="优惠券"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{
        couponType: 'CASH',
        validType: 'DAYS',
        amount: 0,
        discount: 100,
        minAmount: 0,
        totalCount: 0,
        perLimit: 1,
        validDays: 30,
        status: 1
      }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const couponTypeDict: Record<string, { label: string; type?: string }> = {
  CASH: { label: '满减', type: 'primary' },
  DISCOUNT: { label: '折扣', type: 'warning' },
  FREE_DELIVERY: { label: '免配送费', type: 'success' }
}

const validTypeDict: Record<string, { label: string }> = {
  DAYS: { label: '按天' },
  FIXED: { label: '固定日期' }
}

const columns = [
  { prop: 'name', label: '券名称', minWidth: 140 },
  { prop: 'couponType', label: '券类型', minWidth: 110, type: 'tag', dict: couponTypeDict },
  { prop: 'amount', label: '面额', minWidth: 90 },
  { prop: 'discount', label: '折扣', minWidth: 90 },
  { prop: 'minAmount', label: '使用门槛', minWidth: 100 },
  { prop: 'totalCount', label: '发放总量', minWidth: 100 },
  { prop: 'receivedCount', label: '已领取', minWidth: 90 },
  {
    prop: 'status',
    label: '状态',
    minWidth: 90,
    type: 'tag',
    dict: { 1: { label: '上架', type: 'success' }, 0: { label: '下架', type: 'danger' } }
  }
]

const filters = [
  {
    prop: 'couponType',
    label: '券类型',
    type: 'select',
    options: Object.entries(couponTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '上架', value: 1 },
      { label: '下架', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'name', label: '券名称', required: true, span: 24 },
  {
    prop: 'couponType',
    label: '券类型',
    type: 'select',
    required: true,
    span: 12,
    options: Object.entries(couponTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'amount', label: '面额', type: 'number', span: 12 },
  { prop: 'discount', label: '折扣(95=95折)', type: 'number', span: 12 },
  { prop: 'minAmount', label: '使用门槛', type: 'number', span: 12 },
  { prop: 'totalCount', label: '发放总量', type: 'number', precision: 0, span: 12 },
  { prop: 'perLimit', label: '每人限领', type: 'number', precision: 0, span: 12 },
  {
    prop: 'validType',
    label: '有效期类型',
    type: 'select',
    span: 12,
    options: Object.entries(validTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'validDays', label: '有效天数', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
