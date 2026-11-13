<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/cms/article', perm: 'cms:article' }"
      title="文章资讯"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ articleType: 'NEWS', isTop: 0, status: 0 }"
      :action-width="200"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="publish(row)">发布</el-button>
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

// 文章类型字典
const articleTypeDict: Record<string, { label: string; type?: string }> = {
  BRAND: { label: '品牌', type: 'primary' },
  NEWS: { label: '资讯', type: 'success' },
  CASE: { label: '案例', type: 'warning' },
  HELP: { label: '帮助', type: 'info' }
}

// 发布状态字典：1已发布 0草稿
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '已发布', type: 'success' },
  0: { label: '草稿', type: 'info' }
}

const columns = [
  { prop: 'title', label: '标题', minWidth: 200 },
  { prop: 'categoryId', label: '所属栏目', minWidth: 100 },
  { prop: 'articleType', label: '文章类型', minWidth: 100, type: 'tag', dict: articleTypeDict },
  { prop: 'isTop', label: '置顶', minWidth: 80, type: 'bool' },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: statusDict },
  { prop: 'publishTime', label: '发布时间', minWidth: 160, type: 'date' }
]

const filters = [
  { prop: 'categoryId', label: '所属栏目' },
  {
    prop: 'articleType',
    label: '文章类型',
    type: 'select',
    options: Object.entries(articleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  {
    prop: 'status',
    label: '状态',
    type: 'select',
    options: [
      { label: '已发布', value: 1 },
      { label: '草稿', value: 0 }
    ]
  }
]

const formFields = [
  { prop: 'categoryId', label: '所属栏目', type: 'number', precision: 0, span: 12 },
  { prop: 'title', label: '标题', required: true, span: 24 },
  { prop: 'titleEn', label: '英文标题', span: 12 },
  {
    prop: 'articleType',
    label: '文章类型',
    type: 'select',
    span: 12,
    options: Object.entries(articleTypeDict).map(([value, v]) => ({ label: v.label, value }))
  },
  { prop: 'summary', label: '摘要', type: 'textarea', span: 24 },
  { prop: 'content', label: '正文内容', type: 'richtext', span: 24 },
  { prop: 'cover', label: '封面图', type: 'image', span: 24 },
  { prop: 'isTop', label: '置顶', type: 'switch', span: 12 },
  { prop: 'status', label: '发布状态', type: 'switch', span: 12 }
]

// 发布文章
async function publish(row: any) {
  await request.get(`/cms/article/${row.id}/publish`)
  ElMessage.success('发布成功')
  crudRef.value?.loadData()
}
</script>
