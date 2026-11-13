<template>
  <div class="page-container">
    <el-row :gutter="16">
      <el-col :span="9">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>字典类型</span>
              <el-button type="primary" size="small" :icon="Plus" @click="typeCrud?.handleAdd()">新增</el-button>
            </div>
          </template>
          <CrudTable
            ref="typeCrud"
            :api="{ base: '/system/dict/type', perm: 'sys:dict' }"
            title="字典类型"
            :columns="typeColumns"
            :form-fields="typeFormFields"
            :searchable="false"
            :show-batch-delete="false"
            :action-width="140"
            :default-form="{ status: 1, sort: 0 }"
            @loaded="onTypesLoaded"
          >
            <template #row-actions="{ row }">
              <el-button link type="success" @click="selectType(row)">查看数据</el-button>
            </template>
          </CrudTable>
        </el-card>
      </el-col>
      <el-col :span="15">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>字典数据 {{ currentType ? `· ${currentType.name} (${currentType.code})` : '' }}</span>
              <el-button type="primary" size="small" :icon="Plus" :disabled="!currentType" @click="dataCrud?.handleAdd()">
                新增字典项
              </el-button>
            </div>
          </template>
          <CrudTable
            v-if="currentType"
            ref="dataCrud"
            :key="currentType.id"
            :api="{ base: '/system/dict/data', perm: 'sys:dict' }"
            title="字典项"
            :columns="dataColumns"
            :form-fields="dataFormFields"
            :searchable="true"
            :page-params="{ dictCode: currentType.code }"
            :default-form="{ dictCode: currentType.code, status: 1 }"
            :action-width="140"
          />
          <el-empty v-else description="请选择左侧字典类型" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import CrudTable from '@/components/CrudTable/index.vue'

const typeCrud = ref()
const dataCrud = ref()
const currentType = ref<any>(null)

const typeColumns = [
  { prop: 'name', label: '字典名称', minWidth: 120 },
  { prop: 'code', label: '字典编码', minWidth: 120 },
  { prop: 'status', label: '状态', width: 80, type: 'tag', dict: { 1: { label: '启用', type: 'success' }, 0: { label: '停用', type: 'danger' } } }
]

const typeFormFields = [
  { prop: 'name', label: '字典名称', required: true, span: 24 },
  { prop: 'code', label: '字典编码', required: true, span: 24, placeholder: '英文唯一编码，如 biz_type' },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 },
  { prop: 'remark', label: '备注', type: 'textarea', span: 24 }
]

const dataColumns = [
  { prop: 'label', label: '标签', minWidth: 120 },
  { prop: 'labelEn', label: '英文标签', minWidth: 120 },
  { prop: 'value', label: '值', minWidth: 100 },
  { prop: 'sort', label: '排序', width: 80 },
  { prop: 'status', label: '状态', width: 80, type: 'tag', dict: { 1: { label: '启用', type: 'success' }, 0: { label: '停用', type: 'danger' } } }
]

const dataFormFields = [
  { prop: 'label', label: '标签', required: true, span: 12 },
  { prop: 'labelEn', label: '英文标签', span: 12 },
  { prop: 'value', label: '值', required: true, span: 12 },
  { prop: 'sort', label: '排序', type: 'number', precision: 0, span: 12 },
  { prop: 'status', label: '状态', type: 'switch', span: 12 }
]

function onTypesLoaded(rows: any[]) {
  if (!currentType.value && rows.length) {
    currentType.value = rows[0]
  }
}

function selectType(row: any) {
  currentType.value = row
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
