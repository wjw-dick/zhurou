<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/wechat/template', perm: 'wechat:template' }"
      title="模板消息"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 业务类型字典
const bizTypeDict: Record<string, { label: string; type?: string }> = {
  ORDER_PAID: { label: '订单支付', type: 'success' },
  ORDER_PREPARING: { label: '备货中', type: 'primary' },
  ORDER_READY: { label: '待取货', type: 'warning' },
  ORDER_DELIVERING: { label: '配送中', type: 'info' },
  ACTIVITY: { label: '活动通知', type: 'danger' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '启用', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'bizType', label: '业务类型', minWidth: 140, type: 'tag', dict: bizTypeDict },
  { prop: 'templateId', label: '微信模板ID', minWidth: 200 },
  { prop: 'title', label: '标题', minWidth: 160 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const formFields = [
  {
    prop: 'bizType',
    label: '业务类型',
    required: true,
    type: 'select',
    span: 12,
    options: Object.entries(bizTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'templateId', label: '微信模板ID', span: 12 },
  { prop: 'title', label: '标题', required: true, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
