<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/store/info', perm: 'store:info' }"
      title="门店"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ status: 1, sort: 0 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 门店状态字典：1营业 0停业
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'code', label: '门店编码', minWidth: 120 },
  { prop: 'name', label: '门店名称', minWidth: 140 },
  { prop: 'contact', label: '联系人', minWidth: 100 },
  { prop: 'phone', label: '电话', minWidth: 120 },
  { prop: 'city', label: '城市', minWidth: 100 },
  { prop: 'address', label: '地址', minWidth: 180 },
  { prop: 'deliveryFee', label: '配送费', minWidth: 100 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict },
  { prop: 'sort', label: '排序', minWidth: 80 }
]

const formFields = [
  { prop: 'code', label: '门店编码', required: true, span: 12 },
  { prop: 'name', label: '门店名称', required: true, span: 12 },
  { prop: 'contact', label: '联系人', span: 12 },
  { prop: 'phone', label: '电话', span: 12 },
  { prop: 'province', label: '省份', span: 12 },
  { prop: 'city', label: '城市', span: 12 },
  { prop: 'district', label: '区县', span: 12 },
  { prop: 'address', label: '详细地址', span: 24 },
  { prop: 'lng', label: '经度', span: 12 },
  { prop: 'lat', label: '纬度', span: 12 },
  { prop: 'businessHours', label: '营业时间', span: 12, placeholder: '如 08:00-21:00' },
  { prop: 'deliveryRadiusKm', label: '配送半径(km)', span: 12 },
  { prop: 'deliveryFee', label: '配送费', span: 12 },
  { prop: 'freeDeliveryAmount', label: '满额免配送费', span: 12 },
  { prop: 'minOrderAmount', label: '起送金额', span: 12 },
  { prop: 'intro', label: '门店简介', type: 'textarea', span: 24 },
  { prop: 'images', label: '门店图片', type: 'image', span: 24 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 }
]
</script>
