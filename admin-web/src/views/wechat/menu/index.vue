<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>公众号自定义菜单</span>
          <div>
            <el-button :icon="Plus" @click="openForm(null, 0)">新增一级菜单</el-button>
            <el-button type="success" :icon="Promotion" :loading="publishing" @click="publish">发布到公众号</el-button>
            <el-button :icon="RefreshRight" @click="loadMenus">刷新</el-button>
          </div>
        </div>
      </template>

      <el-alert
        type="info"
        :closable="false"
        show-icon
        title="最多 3 个一级菜单，每个一级菜单最多 5 个子菜单；设置完成后点击「发布到公众号」生成发布快照。"
        style="margin-bottom: 14px"
      />

      <!-- 公众号菜单预览 -->
      <div class="mp-preview">
        <div class="mp-bar">
          <div v-for="root in roots" :key="root.id" class="mp-menu">
            <div class="mp-menu-title">
              <span>{{ root.name }}</span>
              <span class="mp-ops">
                <el-icon title="编辑" @click="openForm(root, root.parentId)"><EditPen /></el-icon>
                <el-icon title="删除" @click="removeMenu(root)"><Delete /></el-icon>
              </span>
            </div>
            <div class="mp-sub-list">
              <div v-for="child in childrenOf(root.id)" :key="child.id" class="mp-sub-item">
                <span>{{ child.name }}</span>
                <span class="mp-ops">
                  <el-icon title="编辑" @click="openForm(child, root.id)"><EditPen /></el-icon>
                  <el-icon title="删除" @click="removeMenu(child)"><Delete /></el-icon>
                </span>
              </div>
              <div v-if="childrenOf(root.id).length < 5" class="mp-sub-add" @click="openForm(null, root.id)">
                + 添加子菜单
              </div>
            </div>
          </div>
          <div v-if="!roots.length" class="mp-empty">暂无菜单，点击右上角「新增一级菜单」开始配置</div>
        </div>
      </div>

      <el-divider content-position="left">发布记录</el-divider>
      <CrudTable
        ref="crudRef"
        :api="{ base: '/wechat/menu', perm: 'wechat:menu' }"
        title="发布记录"
        :columns="columns"
        :form-fields="[]"
        :searchable="false"
        :show-add="false"
        :show-edit="false"
        :show-delete="false"
        :show-actions="false"
        :action-width="0"
      />
    </el-card>

    <!-- 菜单表单 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑菜单' : '新增菜单'" width="560px" destroy-on-close>
      <el-form :model="form" label-width="120px">
        <el-form-item label="上级菜单">
          <el-select v-model="form.parentId" style="width: 100%">
            <el-option :value="0" label="一级菜单" />
            <el-option v-for="r in roots" :key="r.id" :value="r.id" :label="`子菜单 of ${r.name}`" />
          </el-select>
        </el-form-item>
        <el-form-item label="菜单名称" required>
          <el-input v-model="form.name" placeholder="如：品牌故事" maxlength="16" show-word-limit />
        </el-form-item>
        <el-form-item label="菜单类型">
          <el-select v-model="form.linkType" style="width: 100%">
            <el-option value="PAGE" label="跳转网页(PAGE)" />
            <el-option value="MINIAPP" label="跳转小程序(MINIAPP)" />
            <el-option value="PAGEVIEW" label="图文消息(PAGEVIEW)" />
            <el-option value="WEBVIEW" label="内嵌网页(WEBVIEW)" />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.linkType === 'MINIAPP'" label="小程序 AppID">
          <el-input v-model="form.appid" placeholder="小程序 AppID" />
        </el-form-item>
        <el-form-item v-if="form.linkType === 'MINIAPP'" label="页面路径">
          <el-input v-model="form.pagePath" placeholder="如 pages/index/index" />
        </el-form-item>
        <el-form-item v-else label="链接 URL">
          <el-input v-model="form.linkUrl" placeholder="https://..." />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="saveForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Promotion, RefreshRight, EditPen, Delete } from '@element-plus/icons-vue'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()
const rawList = ref<any[]>([])
const dialogVisible = ref(false)
const saving = ref(false)
const publishing = ref(false)

const form = reactive<any>({
  id: null,
  parentId: 0,
  platform: 'WECHAT',
  menuType: 'MENU',
  name: '',
  linkType: 'PAGE',
  linkUrl: '',
  appid: '',
  pagePath: '',
  sort: 0,
  visible: 1,
  status: 1
})

const columns = [
  { prop: 'publishUser', label: '发布人', minWidth: 110 },
  { prop: 'status', label: '结果', minWidth: 100, type: 'tag', dict: { SUCCESS: { label: '成功', type: 'success' }, FAILED: { label: '失败', type: 'danger' } } },
  { prop: 'message', label: '说明', minWidth: 240 },
  { prop: 'createTime', label: '发布时间', minWidth: 160, type: 'date' }
]

const roots = computed(() => rawList.value.filter((m) => !m.parentId || m.parentId === 0))

function childrenOf(id: number) {
  return rawList.value.filter((m) => m.parentId === id)
}

async function loadMenus() {
  const res = await request.get('/system/menu/tree/WECHAT')
  rawList.value = res.data || []
}

function openForm(node: any, parentId: number) {
  Object.keys(form).forEach((k) => (form[k] = ''))
  Object.assign(form, {
    id: node?.id || null,
    parentId: parentId || 0,
    platform: 'WECHAT',
    menuType: 'MENU',
    name: node?.name || '',
    linkType: node?.linkType || 'PAGE',
    linkUrl: node?.linkUrl || '',
    appid: node?.appid || '',
    pagePath: node?.pagePath || '',
    sort: node?.sort ?? 0,
    visible: 1,
    status: node?.status ?? 1
  })
  dialogVisible.value = true
}

async function saveForm() {
  if (!form.name) {
    ElMessage.warning('请输入菜单名称')
    return
  }
  saving.value = true
  try {
    if (form.id) {
      await request.put('/system/menu', form)
    } else {
      await request.post('/system/menu', form)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await loadMenus()
  } finally {
    saving.value = false
  }
}

async function removeMenu(node: any) {
  await ElMessageBox.confirm(`确定删除菜单「${node.name}」吗？`, '提示', {
    type: 'warning',
    confirmButtonText: '确定删除',
    confirmButtonClass: 'el-button--danger'
  })
  await request.delete(`/system/menu/${node.id}`)
  ElMessage.success('删除成功')
  await loadMenus()
}

async function publish() {
  const menuJson = JSON.stringify(
    roots.value.map((r) => ({
      name: r.name,
      sub_button: childrenOf(r.id).map((c) => ({
        name: c.name,
        type: c.linkType,
        url: c.linkUrl || undefined,
        appid: c.appid || undefined,
        pagepath: c.pagePath || undefined
      }))
    }))
  )
  publishing.value = true
  try {
    await request.post('/wechat/menu/publish', { menuJson })
    ElMessage.success('发布快照已生成')
    crudRef.value?.loadData()
  } finally {
    publishing.value = false
  }
}

onMounted(loadMenus)
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header > div {
  display: flex;
  align-items: center;
  gap: 8px;
}

.mp-preview {
  max-width: 420px;
  margin: 0 auto;
  border: 1px solid #ebeef5;
  border-radius: 8px 8px 0 0;
  overflow: visible;
}

.mp-bar {
  display: flex;
  background: #fafafa;
  border-top: 2px solid #eaeaea;
  min-height: 90px;
  position: relative;
}

.mp-menu {
  flex: 1;
  text-align: center;
  border-right: 1px solid #f0f0f0;
  position: relative;
  min-width: 0;
}

.mp-menu:last-child {
  border-right: none;
}

.mp-menu-title {
  padding: 10px 4px;
  font-size: 13px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.mp-sub-list {
  position: absolute;
  bottom: 100%;
  left: 0;
  right: 0;
  background: #fff;
  border: 1px solid #eaeaea;
  display: none;
  z-index: 10;
}

.mp-menu:hover .mp-sub-list {
  display: block;
}

.mp-sub-item {
  padding: 8px 6px;
  font-size: 12px;
  border-bottom: 1px solid #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.mp-sub-add {
  padding: 8px 6px;
  font-size: 12px;
  color: #909399;
  cursor: pointer;
}

.mp-sub-add:hover {
  color: #409eff;
}

.mp-ops {
  display: inline-flex;
  gap: 4px;
  color: #909399;
  cursor: pointer;
}

.mp-ops .el-icon:hover {
  color: #409eff;
}

.mp-empty {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  font-size: 13px;
}
</style>
