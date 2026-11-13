<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/channel/info', perm: 'channel:info' }"
      title="渠道档案"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ channelType: 'DISTRIBUTOR', level: 1, status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 渠道类型字典：GROUP团购 / DISTRIBUTOR分销 / FRANCHISE加盟
const channelTypeDict: Record<string, { label: string; type?: string }> = {
  GROUP: { label: '团购', type: 'primary' },
  DISTRIBUTOR: { label: '分销', type: 'success' },
  FRANCHISE: { label: '加盟', type: 'warning' }
}

// 状态字典：1合作 0停用
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '合作', type: 'success' },
  0: { label: '停用', type: 'danger' }
}

const columns = [
  { prop: 'code', label: '渠道编码', minWidth: 120 },
  { prop: 'name', label: '渠道商名称', minWidth: 140 },
  { prop: 'channelType', label: '渠道类型', minWidth: 100, type: 'tag', dict: channelTypeDict },
  { prop: 'level', label: '层级', minWidth: 80 },
  { prop: 'contact', label: '联系人', minWidth: 100 },
  { prop: 'phone', label: '联系电话', minWidth: 120 },
  { prop: 'commissionRate', label: '佣金比例(%)', minWidth: 110 },
  { prop: 'creditLimit', label: '额度', minWidth: 100 },
  { prop: 'usedCredit', label: '已用额度', minWidth: 100 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  {
    prop: 'channelType',
    label: '渠道类型',
    type: 'select',
    options: Object.entries(channelTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '合作', value: 1 },
      { label: '停用', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'code', label: '渠道编码', required: true, span: 12 },
  { prop: 'name', label: '渠道商名称', required: true, span: 12 },
  { prop: 'parentId', label: '上级渠道', type: 'number', precision: 0, placeholder: '上级渠道ID，顶级填0', span: 12 },
  { prop: 'level', label: '层级', type: 'number', precision: 0, span: 12 },
  {
    prop: 'channelType',
    label: '渠道类型',
    type: 'select',
    span: 12,
    options: Object.entries(channelTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'contact', label: '联系人', span: 12 },
  { prop: 'phone', label: '联系电话', span: 12 },
  { prop: 'commissionRate', label: '佣金比例(%)', type: 'number', span: 12 },
  { prop: 'creditLimit', label: '授信额度', type: 'number', span: 12 },
  { prop: 'storeIds', label: '可销售门店', placeholder: '门店ID，多个用逗号分隔', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]
</script>
