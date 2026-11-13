<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/member/points', perm: 'member:points' }"
      title="积分记录"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
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

const changeTypeDict: Record<string, { label: string; type?: string }> = {
  EARN: { label: '获得', type: 'success' },
  USE: { label: '使用', type: 'warning' },
  REFUND: { label: '退回', type: 'primary' },
  ADJUST: { label: '调整', type: 'info' }
}

const columns = [
  { prop: 'memberId', label: '会员ID', minWidth: 100 },
  { prop: 'changeType', label: '变动类型', minWidth: 110, type: 'tag', dict: changeTypeDict },
  { prop: 'points', label: '变动积分', minWidth: 110 },
  { prop: 'balance', label: '变动后积分', minWidth: 120 },
  { prop: 'bizNo', label: '关联单号', minWidth: 160 },
  { prop: 'remark', label: '备注', minWidth: 160 },
  { prop: 'createTime', label: '时间', minWidth: 170, type: 'date' }
]

const filters = [
  { prop: 'memberId', label: '会员ID', type: 'input' },
  {
    prop: 'changeType',
    label: '变动类型',
    type: 'select',
    options: Object.entries(changeTypeDict).map(([value, v]) => ({ label: v.label, value }))
  }
]

// 只读流水，无新增/编辑表单
const formFields: any[] = []
</script>
