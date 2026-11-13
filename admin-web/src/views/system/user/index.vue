<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/system/user', perm: 'sys:user' }"
      title="用户"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ userType: 'STORE_MANAGER', status: 1, isSuper: 0 }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="warning" @click="resetPwd(row)">重置密码</el-button>
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

const userTypeDict: Record<string, { label: string; type?: string }> = {
  ADMIN: { label: '平台管理员', type: 'danger' },
  STORE_MANAGER: { label: '店长', type: 'primary' },
  FINANCE: { label: '财务', type: 'warning' },
  CLERK: { label: '店员', type: 'success' },
  CUTTER: { label: '分割师傅', type: 'success' },
  SERVICE: { label: '客服', type: 'info' },
  SUPPLIER: { label: '供应商', type: 'info' },
  CHANNEL: { label: '渠道商', type: 'info' },
  CUSTOMER: { label: '客户', type: 'info' }
}

const columns = [
  { prop: 'username', label: '账号', minWidth: 120 },
  { prop: 'nickname', label: '昵称', minWidth: 100 },
  { prop: 'realName', label: '真实姓名', minWidth: 100 },
  { prop: 'phone', label: '手机号', minWidth: 120 },
  { prop: 'userType', label: '用户类型', minWidth: 120, type: 'tag', dict: userTypeDict },
  { prop: 'isSuper', label: '超管', minWidth: 80, type: 'bool' },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: { 1: { label: '启用', type: 'success' }, 0: { label: '禁用', type: 'danger' } } },
  { prop: 'lastLoginTime', label: '最近登录', minWidth: 160, type: 'date' }
]

const filters = [
  {
    prop: 'userType',
    label: '用户类型',
    type: 'select',
    options: Object.entries(userTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'status', label: '状态', type: 'select', options: [{ label: '启用', value: 1 }, { label: '禁用', value: 0 }] }
]

const formFields = [
  { prop: 'username', label: '登录账号', required: true, span: 12 },
  { prop: 'password', label: '登录密码', placeholder: '不填默认 123456', span: 12 },
  { prop: 'nickname', label: '昵称', span: 12 },
  { prop: 'realName', label: '真实姓名', span: 12 },
  { prop: 'phone', label: '手机号', span: 12 },
  {
    prop: 'userType',
    label: '用户类型',
    type: 'select',
    span: 12,
    options: Object.entries(userTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'storeId',
    label: '所属门店',
    type: 'select',
    span: 12,
    optionsUrl: '/store/info/options',
    optionsMap: (rows: any[]) => rows.map((r) => ({ label: r.name, value: r.id }))
  },
  {
    prop: 'roleIds',
    label: '分配角色',
    type: 'select',
    multiple: true,
    span: 12,
    optionsUrl: '/system/role/options',
    optionsMap: (rows: any[]) => rows.map((r) => ({ label: r.name, value: r.id }))
  },
  { prop: 'isSuper', label: '超级管理员', type: 'switch', span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

async function resetPwd(row: any) {
  const { value } = await ElMessageBox.prompt(`为用户「${row.nickname || row.username}」设置新密码`, '重置密码', {
    inputPlaceholder: '不填默认 123456',
    inputValue: '123456'
  })
  await request.put(`/system/user/${row.id}/resetPwd`, null, { params: { password: value } })
  ElMessage.success('密码已重置')
}
</script>
