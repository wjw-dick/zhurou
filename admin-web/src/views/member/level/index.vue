<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/member/level', perm: 'member:level' }"
      title="会员等级"
      :columns="columns"
      :form-fields="formFields"
      :default-form="{ level: 1, discount: 100, pointsRatio: 1, status: 1 }"
      :action-width="180"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CrudTable from '@/components/CrudTable/index.vue'

const crudRef = ref()

const columns = [
  { prop: 'name', label: '等级名称', minWidth: 120 },
  { prop: 'level', label: '等级值', minWidth: 90 },
  { prop: 'upgradeAmount', label: '升级门槛', minWidth: 120 },
  { prop: 'discount', label: '折扣', minWidth: 90 },
  { prop: 'pointsRatio', label: '积分倍率', minWidth: 100 },
  {
    prop: 'status',
    label: '状态',
    minWidth: 90,
    type: 'tag',
    dict: { 1: { label: '启用', type: 'success' }, 0: { label: '停用', type: 'danger' } }
  }
]

const formFields = [
  { prop: 'name', label: '等级名称', required: true, span: 12 },
  { prop: 'level', label: '等级值', type: 'number', precision: 0, required: true, span: 12 },
  { prop: 'upgradeAmount', label: '升级门槛', type: 'number', span: 12 },
  { prop: 'discount', label: '折扣(95=95折)', type: 'number', span: 12 },
  { prop: 'pointsRatio', label: '积分倍率', type: 'number', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]
</script>
