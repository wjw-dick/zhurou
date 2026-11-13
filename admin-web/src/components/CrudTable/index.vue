<template>
  <div class="crud-table">
    <!-- 筛选区：可折叠 -->
    <div v-if="filters && filters.length" class="filter-bar">
      <el-form :inline="true" :model="query" size="default" @submit.prevent>
        <el-form-item v-if="searchable" label="关键词">
          <el-input
            v-model="query.keyword"
            placeholder="请输入关键词"
            clearable
            style="width: 200px"
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item
          v-for="f in visibleFilters"
          :key="f.prop"
          :label="f.label"
        >
          <el-select
            v-if="f.type === 'select'"
            v-model="query[f.prop]"
            placeholder="全部"
            clearable
            style="width: 160px"
          >
            <el-option v-for="o in f.options || []" :key="o.value" :label="o.label" :value="o.value" />
          </el-select>
          <el-date-picker
            v-else-if="f.type === 'date'"
            v-model="query[f.prop]"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="选择日期"
            style="width: 160px"
          />
          <el-input v-else v-model="query[f.prop]" placeholder="请输入" clearable style="width: 160px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :icon="Search" @click="handleSearch">查询</el-button>
          <el-button :icon="Refresh" @click="handleReset">重置</el-button>
          <el-button v-if="filters.length > 3" link type="primary" @click="filterExpanded = !filterExpanded">
            {{ filterExpanded ? '收起' : '展开' }}
            <el-icon><component :is="filterExpanded ? 'ArrowUp' : 'ArrowDown'" /></el-icon>
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="table-card">
      <div class="toolbar">
        <div class="toolbar-left">
          <el-button v-if="showAdd" v-perm="addPerm" type="primary" :icon="Plus" @click="handleAdd">新增</el-button>
          <el-button v-if="showBatchDelete" v-perm="delPerm" type="danger" :icon="Delete" :disabled="!selected.length" @click="handleBatchDelete">
            批量删除
          </el-button>
          <slot name="toolbar" :selected="selected" />
        </div>
        <div class="toolbar-right">
          <slot name="toolbar-right" />
        </div>
      </div>

      <el-table
        ref="tableRef"
        v-loading="loading"
        :data="list"
        stripe
        border
        row-key="id"
        @selection-change="onSelectionChange"
      >
        <el-table-column v-if="showBatchDelete" type="selection" width="46" />
        <el-table-column type="index" label="#" width="56" align="center" />
        <el-table-column
          v-for="col in columns"
          :key="col.prop"
          :prop="col.prop"
          :label="col.label"
          :width="col.width"
          :min-width="col.minWidth || 120"
          :align="col.align || 'left'"
          show-overflow-tooltip
        >
          <template #default="{ row }">
            <template v-if="col.type === 'tag'">
              <el-tag :type="tagType(col, row[col.prop])" size="small" effect="light">
                {{ tagLabel(col, row[col.prop]) }}
              </el-tag>
            </template>
            <template v-else-if="col.type === 'image'">
              <el-image
                v-if="row[col.prop]"
                :src="firstImage(row[col.prop])"
                :preview-src-list="imageList(row[col.prop])"
                fit="cover"
                style="width: 44px; height: 44px; border-radius: 4px"
                preview-teleported
              />
              <span v-else>-</span>
            </template>
            <template v-else-if="col.type === 'bool'">
              <el-tag :type="row[col.prop] ? 'success' : 'info'" size="small">
                {{ row[col.prop] ? '是' : '否' }}
              </el-tag>
            </template>
            <template v-else-if="col.type === 'date'">
              {{ formatDate(row[col.prop], col.dateFormat) }}
            </template>
            <template v-else-if="col.formatter">
              {{ col.formatter(row) }}
            </template>
            <template v-else>
              {{ row[col.prop] ?? '-' }}
            </template>
          </template>
        </el-table-column>

        <el-table-column v-if="showActions" label="操作" :width="actionWidth" fixed="right" align="center">
          <template #default="{ row }">
            <el-button v-perm="editPerm" link type="primary" @click="handleEdit(row)">编辑</el-button>
            <slot name="row-actions" :row="row" />
            <el-button v-perm="delPerm" link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="query.current"
          v-model:page-size="query.size"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </div>

    <!-- 表单弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="720px"
      top="6vh"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="120px">
        <el-row :gutter="16">
          <el-col v-for="fd in formFields" :key="fd.prop" :span="fd.span || 12">
            <el-form-item :label="fd.label" :prop="fd.prop">
              <el-input
                v-if="!fd.type || fd.type === 'input'"
                v-model="formData[fd.prop]"
                :placeholder="fd.placeholder || `请输入${fd.label}`"
                clearable
              />
              <el-input-number
                v-else-if="fd.type === 'number'"
                v-model="formData[fd.prop]"
                :precision="fd.precision ?? 2"
                :min="fd.min ?? 0"
                controls-position="right"
                style="width: 100%"
              />
              <el-select
                v-else-if="fd.type === 'select'"
                v-model="formData[fd.prop]"
                :placeholder="`请选择${fd.label}`"
                :multiple="fd.multiple"
                clearable
                filterable
                style="width: 100%"
              >
                <el-option
                  v-for="o in optionsOf(fd)"
                  :key="o.value"
                  :label="o.label"
                  :value="o.value"
                />
              </el-select>
              <el-switch
                v-else-if="fd.type === 'switch'"
                v-model="formData[fd.prop]"
                :active-value="fd.activeValue ?? 1"
                :inactive-value="fd.inactiveValue ?? 0"
              />
              <el-date-picker
                v-else-if="fd.type === 'date'"
                v-model="formData[fd.prop]"
                type="date"
                value-format="YYYY-MM-DD"
                style="width: 100%"
              />
              <el-input
                v-else-if="fd.type === 'textarea'"
                v-model="formData[fd.prop]"
                type="textarea"
                :rows="fd.rows || 3"
                :placeholder="fd.placeholder || `请输入${fd.label}`"
              />
              <ImageUpload
                v-else-if="fd.type === 'image'"
                v-model="formData[fd.prop]"
                class="upload-full-row"
              />
              <RichEditor v-else-if="fd.type === 'richtext'" v-model="formData[fd.prop]" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { Plus, Delete, Search, Refresh } from '@element-plus/icons-vue'
import { request, default as service } from '@/utils/request'
import ImageUpload from './ImageUpload.vue'
import RichEditor from './RichEditor.vue'

export interface ColumnDef {
  prop: string
  label: string
  width?: number | string
  minWidth?: number | string
  align?: string
  type?: 'text' | 'tag' | 'image' | 'bool' | 'date' | 'money'
  dateFormat?: string
  dict?: Record<string, { label: string; type?: string }>
  formatter?: (row: any) => string
}

export interface FilterDef {
  prop: string
  label: string
  type?: 'input' | 'select' | 'date'
  options?: { label: string; value: any }[]
}

export interface FormFieldDef {
  prop: string
  label: string
  type?: string
  options?: { label: string; value: any }[]
  optionsUrl?: string
  optionsMap?: (rows: any[]) => { label: string; value: any }[]
  multiple?: boolean
  span?: number
  required?: boolean
  precision?: number
  min?: number
  rows?: number
  placeholder?: string
  activeValue?: any
  inactiveValue?: any
}

const props = withDefaults(
  defineProps<{
    api: { base: string; perm?: string }
    columns: ColumnDef[]
    formFields?: FormFieldDef[]
    filters?: FilterDef[]
    title?: string
    searchable?: boolean
    showAdd?: boolean
    showEdit?: boolean
    showDelete?: boolean
    showBatchDelete?: boolean
    showActions?: boolean
    actionWidth?: number | string
    defaultForm?: Record<string, any>
    idField?: string
    pageParams?: Record<string, any>
  }>(),
  {
    formFields: () => [],
    filters: () => [],
    searchable: true,
    showAdd: true,
    showEdit: true,
    showDelete: true,
    showBatchDelete: false,
    showActions: true,
    actionWidth: 180,
    idField: 'id'
  }
)

const emit = defineEmits<{ (e: 'loaded', rows: any[]): void }>()

const tableRef = ref()
const formRef = ref<FormInstance>()
const loading = ref(false)
const submitting = ref(false)
const list = ref<any[]>([])
const total = ref(0)
const selected = ref<any[]>([])
const filterExpanded = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)

const query = reactive<any>({
  current: 1,
  size: 10,
  keyword: ''
})

const formData = reactive<any>({})

const perm = computed(() => props.api.perm || '')
const addPerm = computed(() => (perm.value ? `${perm.value}:add` : ''))
const editPerm = computed(() => (perm.value ? `${perm.value}:edit` : ''))
const delPerm = computed(() => (perm.value ? `${perm.value}:del` : ''))

const visibleFilters = computed(() => (filterExpanded.value ? props.filters : props.filters.slice(0, 3)))

const dialogTitle = computed(() => `${isEdit.value ? '编辑' : '新增'}${props.title || ''}`)

const formRules = computed(() => {
  const rules: any = {}
  props.formFields.forEach((f) => {
    if (f.required) {
      rules[f.prop] = [{ required: true, message: `请填写${f.label}`, trigger: 'blur' }]
    }
  })
  return rules
})

const optionCache = reactive<Record<string, any[]>>({})

function optionsOf(fd: FormFieldDef) {
  if (fd.options) return fd.options
  if (fd.optionsUrl) {
    if (!optionCache[fd.prop]) {
      optionCache[fd.prop] = []
      request.get(fd.optionsUrl).then((res) => {
        const rows = res.data || []
        optionCache[fd.prop] = fd.optionsMap ? fd.optionsMap(rows) : rows
      })
    }
    return optionCache[fd.prop]
  }
  return []
}

async function loadData() {
  loading.value = true
  try {
    const params = { ...query, ...(props.pageParams || {}) }
    const res = await request.get(`${props.api.base}/page`, params)
    list.value = res.data.records || []
    total.value = res.data.total || 0
    emit('loaded', list.value)
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  query.current = 1
  loadData()
}

function handleReset() {
  Object.keys(query).forEach((k) => {
    if (k !== 'current' && k !== 'size') query[k] = ''
  })
  query.current = 1
  loadData()
}

function onSelectionChange(rows: any[]) {
  selected.value = rows
}

function resetForm() {
  Object.keys(formData).forEach((k) => delete formData[k])
  Object.assign(formData, JSON.parse(JSON.stringify(props.defaultForm || {})))
  props.formFields.forEach((f) => {
    if (formData[f.prop] === undefined) {
      formData[f.prop] = f.type === 'switch' ? f.inactiveValue ?? 0 : null
    }
  })
}

function handleAdd() {
  isEdit.value = false
  resetForm()
  dialogVisible.value = true
}

async function handleEdit(row: any) {
  isEdit.value = true
  resetForm()
  const res = await request.get(`${props.api.base}/${row[props.idField]}`)
  Object.assign(formData, res.data || row)
  dialogVisible.value = true
}

async function handleSubmit() {
  await formRef.value?.validate()
  submitting.value = true
  try {
    if (isEdit.value) {
      await request.put(props.api.base, formData)
      ElMessage.success('修改成功')
    } else {
      await request.post(props.api.base, formData)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } finally {
    submitting.value = false
  }
}

async function handleDelete(row: any) {
  await ElMessageBox.confirm(`确定删除该${props.title || '记录'}吗？`, '提示', {
    type: 'warning',
    confirmButtonText: '确定删除',
    confirmButtonClass: 'el-button--danger'
  })
  await request.delete(`${props.api.base}/${row[props.idField]}`)
  ElMessage.success('删除成功')
  loadData()
}

async function handleBatchDelete() {
  if (!selected.value.length) return
  await ElMessageBox.confirm(`确定删除选中的 ${selected.value.length} 条记录吗？`, '提示', {
    type: 'warning',
    confirmButtonText: '确定删除',
    confirmButtonClass: 'el-button--danger'
  })
  const ids = selected.value.map((r) => r[props.idField])
  await service.delete(`${props.api.base}/batch`, { data: ids })
  ElMessage.success('删除成功')
  loadData()
}

function firstImage(val: any) {
  return imageList(val)[0]
}

function imageList(val: any) {
  if (!val) return []
  if (Array.isArray(val)) return val
  return String(val)
    .split(',')
    .filter(Boolean)
    .map((v) => v.trim())
}

function tagType(col: ColumnDef, value: any) {
  return col.dict?.[String(value)]?.type || 'info'
}

function tagLabel(col: ColumnDef, value: any) {
  return col.dict?.[String(value)]?.label ?? value ?? '-'
}

function formatDate(value: any, fmt?: string) {
  if (!value) return '-'
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return value
  const pad = (n: number) => String(n).padStart(2, '0')
  if (fmt === 'date') return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(
    d.getMinutes()
  )}:${pad(d.getSeconds())}`
}

onMounted(loadData)

defineExpose({ loadData, refresh: loadData, getSelected: () => selected.value })
</script>
