<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/product/qualification', perm: 'product:qualification' }"
      title="检疫资质"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

// 资质类型字典
const qualTypeDict: Record<string, { label: string; type?: string }> = {
  QUARANTINE: { label: '动物产品检疫合格证明', type: 'success' },
  QUALITY: { label: '肉品品质检验合格证', type: 'primary' },
  SC: { label: '食品生产许可', type: 'warning' },
  INSPECTION: { label: '检测报告', type: 'info' },
  BUSINESS: { label: '营业执照', type: 'danger' }
}

// 状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '有效', type: 'success' },
  0: { label: '失效', type: 'danger' }
}

const qualTypeOptions = Object.entries(qualTypeDict).map(([value, v]) => ({ label: v.label, value }))

const columns = [
  { prop: 'productId', label: '商品ID', minWidth: 100 },
  { prop: 'qualType', label: '资质类型', minWidth: 180, type: 'tag', dict: qualTypeDict },
  { prop: 'qualNo', label: '证书编号', minWidth: 160 },
  { prop: 'issuer', label: '发证机构', minWidth: 160 },
  { prop: 'issueDate', label: '发证日期', minWidth: 120, type: 'date' },
  { prop: 'expireDate', label: '到期日期', minWidth: 120, type: 'date' },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict }
]

const filters = [
  { prop: 'productId', label: '商品ID' },
  { prop: 'qualType', label: '资质类型', type: 'select', options: qualTypeOptions }
]

const formFields = [
  { prop: 'productId', label: '商品ID', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'qualType', label: '资质类型', type: 'select', required: true, span: 12, options: qualTypeOptions },
  { prop: 'qualNo', label: '证书编号', span: 12 },
  { prop: 'issuer', label: '发证机构', span: 12 },
  { prop: 'issueDate', label: '发证日期', type: 'date', span: 12 },
  { prop: 'expireDate', label: '到期日期', type: 'date', span: 12 },
  { prop: 'fileUrl', label: '证明文件', type: 'image', span: 24 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
