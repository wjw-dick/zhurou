<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/cms/message', perm: 'cms:message' }"
      title="留言管理"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ status: 0 }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="handleRow(row)">处理</el-button>
      </template>
    </CrudTable>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()

// 处理状态字典：0待处理 1已处理
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '已处理', type: 'success' },
  0: { label: '待处理', type: 'warning' }
}

const columns = [
  { prop: 'name', label: '姓名', minWidth: 100 },
  { prop: 'phone', label: '联系电话', minWidth: 120 },
  { prop: 'content', label: '留言内容', minWidth: 220 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict },
  { prop: 'remark', label: '处理备注', minWidth: 140 },
  { prop: 'createTime', label: '留言时间', minWidth: 160, type: 'date' }
]

const filters = [
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '待处理', value: 0 },
      { label: '已处理', value: 1 }
    ]
  }
]

const formFields = [
  { prop: 'name', label: '姓名', span: 12 },
  { prop: 'phone', label: '联系电话', span: 12 },
  { prop: 'content', label: '留言内容', type: 'textarea', span: 24 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '处理备注', span: 12 }
]

// 标记留言已处理
async function handleRow(row: any) {
  await request.put(`/cms/message/${row.id}/handle`, null, { params: { status: 1, remark: '已处理' } })
  ElMessage.success('已处理')
  crudRef.value?.loadData()
}
</script>
