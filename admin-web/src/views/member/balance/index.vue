<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/member/balance', perm: 'member:balance' }"
      title="储值记录"
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
  RECHARGE: { label: '充值', type: 'primary' },
  CONSUME: { label: '消费', type: 'warning' },
  REFUND: { label: '退款', type: 'success' },
  ADJUST: { label: '调整', type: 'info' }
}

const columns = [
  { prop: 'memberId', label: '会员ID', minWidth: 100 },
  { prop: 'changeType', label: '变动类型', minWidth: 110, type: 'tag', dict: changeTypeDict },
  { prop: 'amount', label: '变动金额', minWidth: 110 },
  { prop: 'balance', label: '变动后余额', minWidth: 120 },
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
