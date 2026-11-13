<template>
  <div class="page-container">
    <CrudTable
      ref="crudRef"
      :api="{ base: '/wechat/log', perm: 'wechat:log' }"
      title="发送日志"
      :columns="columns"
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

// 发送状态字典
const statusDict: Record<string, { label: string; type?: string }> = {
  1: { label: '成功', type: 'success' },
  0: { label: '失败', type: 'danger' }
}

const columns = [
  { prop: 'openid', label: 'OpenID', minWidth: 200 },
  { prop: 'bizType', label: '业务类型', minWidth: 140 },
  { prop: 'templateId', label: '微信模板ID', minWidth: 200 },
  { prop: 'status', label: '发送状态', minWidth: 100, type: 'tag', dict: statusDict },
  { prop: 'createTime', label: '发送时间', minWidth: 160, type: 'date' }
]
</script>
