<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/member/info', perm: 'member:info' }"
      title="会员"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :show-add="false"
      :show-edit="false"
      :action-width="180"
    >
      <template #row-actions="{ row }">
        <el-button link type="warning" @click="handleRecharge(row)">充值</el-button>
        <el-button link type="primary" @click="handlePoints(row)">积分调整</el-button>
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

const columns = [
  { prop: 'nickname', label: '昵称', minWidth: 120 },
  { prop: 'phone', label: '手机号', minWidth: 120 },
  { prop: 'levelId', label: '会员等级', minWidth: 100 },
  { prop: 'balance', label: '余额', minWidth: 100 },
  { prop: 'points', label: '积分', minWidth: 90 },
  { prop: 'totalAmount', label: '累计消费', minWidth: 110 },
  {
    prop: 'status',
    label: '状态',
    minWidth: 90,
    type: 'tag',
    dict: { 1: { label: '正常', type: 'success' }, 0: { label: '禁用', type: 'danger' } }
  }
]

const filters = [
  { prop: 'phone', label: '手机号', type: 'input' },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '正常', value: 1 },
      { label: '禁用', value: 0 }
    ]
  }
]

// 会员来自微信授权，不支持后台新增/编辑，此处保留空数组避免组件报错
const formFields: any[] = []

// 会员储值
async function handleRecharge(row: any) {
  const { value } = await ElMessageBox.prompt(`为会员「${row.nickname || row.phone}」充值`, '会员充值', {
    inputPattern: /^\d+(\.\d{1,2})?$/,
    inputErrorMessage: '请输入正确的金额'
  })
  await request.put(`/member/info/${row.id}/recharge`, null, { params: { amount: value } })
  ElMessage.success('充值成功')
  crudRef.value?.loadData()
}

// 调整积分
async function handlePoints(row: any) {
  const { value } = await ElMessageBox.prompt(
    `为会员「${row.nickname || row.phone}」调整积分（正数增加，负数扣减）`,
    '积分调整',
    { inputPattern: /^-?\d+$/, inputErrorMessage: '请输入整数积分' }
  )
  await request.put(`/member/info/${row.id}/points`, null, { params: { points: value } })
  ElMessage.success('积分调整成功')
  crudRef.value?.loadData()
}
</script>
