<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/supplier/qualification', perm: 'supplier:qualification' }"
      title="资质审核"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ auditStatus: 'PENDING' }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="handleAudit(row, 'APPROVED')">通过</el-button>
        <el-button link type="danger" @click="handleAudit(row, 'REJECTED')">驳回</el-button>
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

const qualTypeDict: Record<string, { label: string; type?: string }> = {
  QUARANTINE: { label: '检疫合格证', type: 'success' },
  SC: { label: '食品生产许可', type: 'primary' },
  BUSINESS: { label: '营业执照', type: 'warning' },
  INSPECTION: { label: '检测报告', type: 'info' }
}

const auditStatusDict: Record<string, { label: string; type?: string }> = {
  PENDING: { label: '待审核', type: 'warning' },
  APPROVED: { label: '已通过', type: 'success' },
  REJECTED: { label: '已驳回', type: 'danger' }
}

const columns = [
  { prop: 'supplierId', label: '供应商ID', minWidth: 100 },
  { prop: 'qualType', label: '资质类型', minWidth: 120, type: 'tag', dict: qualTypeDict },
  { prop: 'qualNo', label: '证书编号', minWidth: 150 },
  { prop: 'issueDate', label: '发证日期', minWidth: 120, type: 'date' },
  { prop: 'expireDate', label: '到期日期', minWidth: 120, type: 'date' },
  { prop: 'fileUrl', label: '附件', minWidth: 100, type: 'image' },
  { prop: 'auditStatus', label: '审核状态', minWidth: 110, type: 'tag', dict: auditStatusDict }
]

const filters = [
  { prop: 'supplierId', label: '供应商ID', type: 'input' },
  {
    prop: 'auditStatus',
    label: '审核状态',
    type: 'select',
    options: Object.entries(auditStatusDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

const formFields = [
  { prop: 'supplierId', label: '供应商ID', type: 'number', precision: 0, required: true, span: 12 },
  {
    prop: 'qualType',
    label: '资质类型',
    type: 'select',
    span: 12,
    options: Object.entries(qualTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'qualNo', label: '证书编号', span: 24 },
  { prop: 'issueDate', label: '发证日期', type: 'date', span: 12 },
  { prop: 'expireDate', label: '到期日期', type: 'date', span: 12 },
  { prop: 'fileUrl', label: '附件', type: 'image', span: 24 },
  { prop: 'auditRemark', label: '审核备注', type: 'textarea', span: 24 }
]

// 资质审核：通过 / 驳回
async function handleAudit(row: any, auditStatus: string) {
  const text = auditStatus === 'APPROVED' ? '通过' : '驳回'
  await ElMessageBox.confirm(`确定${text}该资质吗？`, '审核确认', {
    type: 'warning',
    confirmButtonText: '确定'
  })
  await request.put(`/supplier/qualification/${row.id}/audit`, null, { params: { auditStatus } })
  ElMessage.success(`已${text}`)
  crudRef.value?.loadData()
}
</script>
