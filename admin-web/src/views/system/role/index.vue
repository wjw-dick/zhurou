<template>
  <div class="page-container">
    <CrudTable
      :api="{ base: '/system/role', perm: 'sys:role' }"
      title="角色"
      :columns="columns"
      :form-fields="formFields"
      :filters="filters"
      :default-form="{ platform: 'ADMIN', dataScope: 'SELF', status: 1, sort: 0 }"
      :action-width="220"
    >
      <template #row-actions="{ row }">
        <el-button link type="success" @click="openAssign(row)">分配权限</el-button>
      </template>
    </CrudTable>

    <el-drawer v-model="drawerVisible" :title="`分配权限 · ${assignRole?.name || ''}`" size="460px" destroy-on-close>
      <div class="assign-toolbar">
        <el-checkbox v-model="expandAll" @change="toggleExpandAll">展开/折叠</el-checkbox>
        <el-checkbox v-model="checkAll" @change="toggleCheckAll">全选/全不选</el-checkbox>
      </div>
      <el-tree
        ref="treeRef"
        :data="menuTree"
        :props="{ label: 'name', children: 'children' }"
        node-key="id"
        show-checkbox
        :default-expand-all="false"
        :check-strictly="false"
      >
        <template #default="{ data }">
          <span>
            {{ data.name }}
            <el-tag v-if="data.menuType === 'BUTTON'" size="small" type="info" effect="plain">按钮</el-tag>
          </span>
        </template>
      </el-tree>
      <template #footer>
        <el-button @click="drawerVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="saveAssign">保存权限</el-button>
      </template>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { nextTick, ref } from 'vue'
import { ElMessage } from 'element-plus'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const drawerVisible = ref(false)
const assignRole = ref<any>(null)
const menuTree = ref<any[]>([])
const treeRef = ref()
const expandAll = ref(false)
const checkAll = ref(false)
const saving = ref(false)

const columns = [
  { prop: 'code', label: '角色编码', minWidth: 140 },
  { prop: 'name', label: '角色名称', minWidth: 120 },
  { prop: 'platform', label: '平台', minWidth: 100 },
  { prop: 'dataScope', label: '数据范围', minWidth: 100 },
  { prop: 'sort', label: '排序', width: 80 },
  { prop: 'status', label: '状态', minWidth: 90, type: 'tag', dict: { 1: { label: '启用', type: 'success' }, 0: { label: '禁用', type: 'danger' } } },
  { prop: 'remark', label: '备注', minWidth: 140 }
]

const filters = [
  { prop: 'platform', label: '平台', type: 'select', options: ['ADMIN', 'STAFF', 'SUPPLIER', 'CHANNEL', 'CUSTOMER'].map((v) => ({ label: v, value: v })) },
  { prop: 'status', label: '状态', type: 'select', options: [{ label: '启用', value: 1 }, { label: '禁用', value: 0 }] }
]

const formFields = [
  { prop: 'code', label: '角色编码', required: true, span: 12 },
  { prop: 'name', label: '角色名称', required: true, span: 12 },
  { prop: 'platform', label: '所属平台', type: 'select', span: 12, options: ['ADMIN', 'STAFF', 'SUPPLIER', 'CHANNEL', 'CUSTOMER'].map((v) => ({ label: v, value: v })) },
  {
    prop: 'dataScope',
    label: '数据范围',
    type: 'select',
    span: 12,
    options: [
      { label: '全部数据', value: 'ALL' },
      { label: '本门店', value: 'STORE' },
      { label: '仅本人', value: 'SELF' }
    ]
  },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

async function openAssign(row: any) {
  assignRole.value = row
  drawerVisible.value = true
  const res = await request.get('/system/menu/options', { platform: row.platform || 'ADMIN' })
  menuTree.value = res.data || []
  const checkedRes = await request.get(`/system/role/${row.id}/menus`)
  const checkedIds = checkedRes.data || []
  await nextTick()
  treeRef.value?.setCheckedKeys(checkedIds.filter((id: number) => id > 0))
}

function toggleExpandAll(val: boolean) {
  const nodes = treeRef.value?.store.nodesMap || {}
  Object.values(nodes).forEach((node: any) => {
    node.expanded = val
  })
}

function toggleCheckAll(val: boolean) {
  if (!treeRef.value) return
  if (val) {
    const allIds: number[] = []
    const walk = (nodes: any[]) => nodes.forEach((n) => {
      allIds.push(n.id)
      if (n.children) walk(n.children)
    })
    walk(menuTree.value)
    treeRef.value.setCheckedKeys(allIds)
  } else {
    treeRef.value.setCheckedKeys([])
  }
}

async function saveAssign() {
  saving.value = true
  try {
    const checked = treeRef.value.getCheckedKeys()
    const halfChecked = treeRef.value.getHalfCheckedKeys()
    await request.put(`/system/role/${assignRole.value.id}/menus`, [...checked, ...halfChecked])
    ElMessage.success('权限分配成功')
    drawerVisible.value = false
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.assign-toolbar {
  display: flex;
  gap: 16px;
  margin-bottom: 10px;
}
</style>
