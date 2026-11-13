<template>
  <div class="page-container menu-page">
    <el-card shadow="never">
      <div class="menu-header">
        <el-radio-group v-model="platform" @change="loadTree">
          <el-radio-button v-for="p in platforms" :key="p.value" :value="p.value">{{ p.label }}</el-radio-button>
        </el-radio-group>
        <div class="header-actions">
          <el-button type="primary" v-perm="'sys:menu:add'" :icon="Plus" @click="handleAdd()">新增菜单</el-button>
          <el-button :icon="RefreshRight" @click="loadTree">刷新</el-button>
          <el-tag type="info" size="small">支持拖拽排序 / 调整层级，松手即保存</el-tag>
        </div>
      </div>

      <div class="menu-body">
        <!-- 左：树 -->
        <div class="menu-tree">
          <el-input v-model="filterText" placeholder="搜索菜单" clearable :prefix-icon="Search" style="margin-bottom: 10px" />
          <el-tree
            ref="treeRef"
            :data="treeData"
            :props="{ label: 'name', children: 'children' }"
            node-key="id"
            default-expand-all
            highlight-current
            draggable
            :filter-node-method="filterNode"
            @node-click="handleNodeClick"
            @node-drop="handleDrop"
          >
            <template #default="{ data }">
              <span class="tree-node">
                <el-tag :type="typeTag(data.menuType)" size="small" effect="plain">{{ typeLabel(data.menuType) }}</el-tag>
                <span class="node-name">{{ data.name }}</span>
                <el-tag v-if="data.status === 0" type="danger" size="small">停用</el-tag>
                <el-tag v-else-if="data.visible === 0" type="warning" size="small">隐藏</el-tag>
              </span>
            </template>
          </el-tree>
        </div>

        <!-- 右：属性 -->
        <div class="menu-prop">
          <el-empty v-if="!current" description="请选择左侧菜单，或点击「新增菜单」" />
          <el-form v-else ref="formRef" :model="form" :rules="rules" label-width="110px">
            <el-form-item label="上级菜单">
              <el-tree-select
                v-model="form.parentId"
                :data="treeSelectData"
                :props="{ label: 'name', children: 'children', value: 'id' }"
                check-strictly
                node-key="id"
                placeholder="顶级菜单"
                clearable
                style="width: 100%"
              />
            </el-form-item>
            <el-form-item label="菜单类型">
              <el-radio-group v-model="form.menuType">
                <el-radio-button value="DIR">目录</el-radio-button>
                <el-radio-button value="MENU">菜单</el-radio-button>
                <el-radio-button value="BUTTON">按钮</el-radio-button>
                <el-radio-button value="LINK">外链</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item label="名称" prop="name">
                  <el-input v-model="form.name" placeholder="菜单名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="英文名称">
                  <el-input v-model="form.nameEn" placeholder="i18n 英文名" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item v-if="form.menuType !== 'BUTTON'" label="路由地址">
                  <el-input v-model="form.path" placeholder="如 /system/user" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item v-if="form.menuType === 'MENU'" label="组件路径">
                  <el-input v-model="form.component" placeholder="如 system/user/index" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item label="图标">
                  <el-input v-model="form.icon" placeholder="如 ep:user">
                    <template #append>
                      <el-icon v-if="form.icon"><component :is="iconName(form.icon)" /></el-icon>
                      <span v-else>预览</span>
                    </template>
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="权限标识">
                  <el-input v-model="form.perm" placeholder="如 sys:user:add" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item label="排序">
                  <el-input-number v-model="form.sort" :min="0" controls-position="right" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="状态">
                  <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="12">
              <el-col :span="12">
                <el-form-item v-if="platform === 'ADMIN'" label="是否显示">
                  <el-switch v-model="form.visible" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item v-if="platform === 'ADMIN'" label="是否缓存">
                  <el-switch v-model="form.keepAlive" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>

            <!-- 公众号菜单专属 -->
            <template v-if="platform === 'WECHAT'">
              <el-row :gutter="12">
                <el-col :span="12">
                  <el-form-item label="菜单类型">
                    <el-select v-model="form.linkType" placeholder="选择类型" style="width: 100%">
                      <el-option label="跳转网页(PAGE)" value="PAGE" />
                      <el-option label="跳转小程序(MINIAPP)" value="MINIAPP" />
                      <el-option label="图文消息(PAGEVIEW)" value="PAGEVIEW" />
                      <el-option label="内嵌网页(WEBVIEW)" value="WEBVIEW" />
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="小程序 AppID">
                    <el-input v-model="form.appid" placeholder="跳转小程序时填写" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-form-item label="页面路径">
                <el-input v-model="form.pagePath" placeholder="如 pages/index/index" />
              </el-form-item>
              <el-form-item label="链接 URL">
                <el-input v-model="form.linkUrl" placeholder="网页类型填写 URL" />
              </el-form-item>
            </template>

            <el-form-item v-if="form.menuType === 'LINK'" label="外链地址">
              <el-input v-model="form.linkUrl" placeholder="https://..." />
            </el-form-item>

            <el-form-item label="备注">
              <el-input v-model="form.remark" type="textarea" :rows="2" />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" :loading="saving" @click="handleSubmit">保存</el-button>
              <el-button v-if="form.id" @click="handleAdd(form.parentId)">新增子菜单</el-button>
              <el-button v-if="form.id" type="danger" plain @click="handleDelete">删除</el-button>
            </el-form-item>
          </el-form>
        </div>

        <!-- 实时预览 -->
        <div class="menu-preview">
          <div class="preview-title">实时预览</div>
          <div v-if="platform === 'WECHAT'" class="preview-wechat">
            <div class="mp-bottom">
              <div v-for="(m, i) in wechatRoots" :key="i" class="mp-item">
                <span>{{ m.name || '菜单' }}</span>
                <div v-if="m.children && m.children.length" class="mp-pop">
                  <div v-for="(c, j) in m.children" :key="j" class="mp-pop-item">{{ c.name || '子菜单' }}</div>
                </div>
              </div>
              <div v-if="!wechatRoots.length" class="mp-item mp-placeholder">当前菜单</div>
            </div>
          </div>
          <div v-else class="preview-admin">
            <div class="pv-menu-item" :class="{ active: current && current.id === form.id }">
              <el-icon v-if="form.icon"><component :is="iconName(form.icon)" /></el-icon>
              <el-icon v-else><Menu /></el-icon>
              <span>{{ form.name || '菜单名称' }}</span>
            </div>
            <div class="pv-tip">
              {{ typeLabel(form.menuType) }} · {{ form.path || form.pagePath || form.linkUrl || '未设置路径' }}
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { Plus, RefreshRight, Search, Menu } from '@element-plus/icons-vue'
import { request } from '@/utils/request'

const platforms = [
  { label: '后台管理', value: 'ADMIN' },
  { label: 'PC 官网导航', value: 'PC' },
  { label: '公众号菜单', value: 'WECHAT' },
  { label: '小程序 tabBar', value: 'MINIAPP' },
  { label: 'H5 底栏', value: 'H5' }
]

const platform = ref('ADMIN')
const rawList = ref<any[]>([])
const current = ref<any>(null)
const filterText = ref('')
const saving = ref(false)
const formRef = ref<FormInstance>()
const treeRef = ref()

const form = reactive<any>({
  id: null,
  parentId: 0,
  platform: 'ADMIN',
  menuType: 'MENU',
  name: '',
  nameEn: '',
  path: '',
  component: '',
  icon: '',
  perm: '',
  linkUrl: '',
  linkType: 'PAGE',
  appid: '',
  pagePath: '',
  sort: 0,
  visible: 1,
  keepAlive: 1,
  status: 1,
  remark: ''
})

const rules = {
  name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  menuType: [{ required: true, message: '请选择菜单类型', trigger: 'change' }]
}

function buildTree(list: any[]) {
  const map = new Map<number, any>()
  const roots: any[] = []
  list.forEach((item) => map.set(item.id, { ...item, children: [] }))
  list.forEach((item) => {
    const node = map.get(item.id)
    const parent = map.get(item.parentId)
    if (item.parentId && parent) {
      parent.children.push(node)
    } else {
      roots.push(node)
    }
  })
  const sortNodes = (nodes: any[]) => {
    nodes.sort((a, b) => (a.sort || 0) - (b.sort || 0))
    nodes.forEach((n) => sortNodes(n.children))
  }
  sortNodes(roots)
  return roots
}

const treeData = computed(() => buildTree(rawList.value))
const treeSelectData = computed(() => [{ id: 0, name: '顶级菜单', children: treeData.value }])

const wechatRoots = computed(() => {
  const list = rawList.value.filter((m) => m.parentId === 0)
  return list.map((m) => ({
    ...m,
    children: rawList.value.filter((c) => c.parentId === m.id)
  }))
})

async function loadTree() {
  const res = await request.get(`/system/menu/tree/${platform.value}`)
  rawList.value = res.data || []
  current.value = null
}

function filterNode(value: string, data: any) {
  if (!value) return true
  return (data.name || '').includes(value)
}

watch(filterText, (v) => treeRef.value?.filter(v))

function handleNodeClick(data: any) {
  current.value = data
  Object.keys(form).forEach((k) => (form[k] = ''));
  Object.assign(form, {
    id: data.id,
    parentId: data.parentId,
    platform: data.platform,
    menuType: data.menuType,
    name: data.name,
    nameEn: data.nameEn,
    path: data.path,
    component: data.component,
    icon: data.icon,
    perm: data.perm,
    linkUrl: data.linkUrl,
    linkType: data.linkType || 'PAGE',
    appid: data.appid,
    pagePath: data.pagePath,
    sort: data.sort,
    visible: data.visible,
    keepAlive: data.keepAlive,
    status: data.status,
    remark: data.remark
  })
}

function handleAdd(parentId?: number) {
  current.value = null
  Object.keys(form).forEach((k) => (form[k] = ''))
  Object.assign(form, {
    id: null,
    parentId: parentId || 0,
    platform: platform.value,
    menuType: platform.value === 'ADMIN' ? 'MENU' : 'MENU',
    sort: 0,
    visible: 1,
    keepAlive: 1,
    status: 1,
    linkType: 'PAGE'
  })
}

async function handleSubmit() {
  await formRef.value?.validate()
  saving.value = true
  try {
    form.platform = platform.value
    if (form.id) {
      await request.put('/system/menu', form)
    } else {
      await request.post('/system/menu', form)
    }
    ElMessage.success('保存成功')
    await loadTree()
  } finally {
    saving.value = false
  }
}

async function handleDelete() {
  await ElMessageBox.confirm('确定删除该菜单及其子菜单吗？', '提示', {
    type: 'warning',
    confirmButtonText: '确定删除',
    confirmButtonClass: 'el-button--danger'
  })
  await request.delete(`/system/menu/${form.id}`)
  ElMessage.success('删除成功')
  current.value = null
  await loadTree()
}

/** 拖拽后保存层级与排序 */
async function handleDrop() {
  const payload: any[] = []
  const walk = (nodes: any[], parentId: number) => {
    nodes.forEach((node, index) => {
      payload.push({ id: node.id, parentId, sort: index + 1 })
      if (node.children && node.children.length) {
        walk(node.children, node.id)
      }
    })
  }
  walk(treeData.value, 0)
  await request.put('/system/menu/sort', payload)
  ElMessage.success('排序已保存')
  await loadTree()
}

const typeLabelMap: Record<string, string> = {
  DIR: '目录',
  MENU: '菜单',
  BUTTON: '按钮',
  LINK: '外链'
}
const typeTagMap: Record<string, string> = {
  DIR: 'warning',
  MENU: 'primary',
  BUTTON: 'info',
  LINK: 'success'
}

function typeLabel(type?: string) {
  return typeLabelMap[type || 'MENU'] || type
}

function typeTag(type?: string) {
  return typeTagMap[type || 'MENU'] || 'info'
}

function iconName(icon?: string) {
  if (!icon) return 'Menu'
  const name = icon.startsWith('ep:') ? icon.slice(3) : icon
  return name.charAt(0).toUpperCase() + name.slice(1).replace(/-([a-z])/g, (_, c) => c.toUpperCase())
}

onMounted(loadTree)
</script>

<style scoped>
.menu-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 14px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.menu-body {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.menu-tree {
  width: 320px;
  border-right: 1px solid #ebeef5;
  padding-right: 16px;
  max-height: 680px;
  overflow: auto;
}

.menu-prop {
  flex: 1;
  min-width: 420px;
}

.menu-preview {
  width: 300px;
  border-left: 1px solid #ebeef5;
  padding-left: 16px;
}

.preview-title {
  font-weight: 600;
  margin-bottom: 12px;
  color: #303133;
}

.preview-admin {
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 12px;
  background: #1f2d3d;
}

.pv-menu-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #c0c4cc;
  padding: 8px 12px;
  border-radius: 4px;
}

.pv-menu-item.active {
  background: #409eff;
  color: #fff;
}

.pv-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
}

.preview-wechat {
  border: 1px solid #ebeef5;
  border-radius: 6px;
  overflow: hidden;
}

.mp-bottom {
  display: flex;
  background: #fff;
  border-top: 3px solid #eaeaea;
}

.mp-item {
  flex: 1;
  text-align: center;
  padding: 12px 0;
  font-size: 13px;
  position: relative;
  border-right: 1px solid #f0f0f0;
}

.mp-item:last-child {
  border-right: none;
}

.mp-placeholder {
  color: #c0c4cc;
}

.mp-pop {
  position: absolute;
  bottom: 100%;
  left: 0;
  right: 0;
  background: #fff;
  border: 1px solid #eaeaea;
  display: none;
}

.mp-item:hover .mp-pop {
  display: block;
}

.mp-pop-item {
  padding: 8px 0;
  font-size: 12px;
  border-bottom: 1px solid #f5f5f5;
}

.tree-node {
  display: flex;
  align-items: center;
  gap: 6px;
}

.node-name {
  font-size: 13px;
}
</style>
