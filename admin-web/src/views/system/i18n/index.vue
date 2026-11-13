<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>多语言词条</span>
          <div>
            <el-select v-model="langCode" style="width: 160px" @change="reload">
              <el-option v-for="l in langs" :key="l.code" :label="l.name" :value="l.code" />
            </el-select>
            <el-button :icon="Plus" type="primary" @click="crudRef?.handleAdd()">新增词条</el-button>
          </div>
        </div>
      </template>
      <CrudTable
        ref="crudRef"
        :key="langCode"
        :api="{ base: '/system/i18n', perm: 'sys:i18n' }"
        title="词条"
        :columns="columns"
        :form-fields="formFields"
        :filters="filters"
        :page-params="{ langCode }"
        :default-form="{ langCode, module: 'common' }"
        :action-width="160"
      />
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import CrudTable from '@/components/CrudTable/index.vue'
import { request } from '@/utils/request'

const crudRef = ref()
const langCode = ref('zh-CN')
const langs = ref<any[]>([{ code: 'zh-CN', name: '简体中文' }, { code: 'en-US', name: 'English' }])

const columns = [
  { prop: 'module', label: '模块', minWidth: 100 },
  { prop: 'i18nKey', label: '键', minWidth: 160 },
  { prop: 'i18nValue', label: '值', minWidth: 200 }
]

const filters = [
  { prop: 'module', label: '模块' },
  { prop: 'langCode', label: '语言', type: 'select', options: [{ label: '简体中文', value: 'zh-CN' }, { label: 'English', value: 'en-US' }] }
]

const formFields = computed(() => [
  {
    prop: 'langCode',
    label: '语言',
    type: 'select',
    required: true,
    span: 12,
    options: langs.value.map((l) => ({ label: l.name, value: l.code }))
  },
  { prop: 'module', label: '模块', required: true, span: 12, placeholder: '如 common / order' },
  { prop: 'i18nKey', label: '键', required: true, span: 24, placeholder: '如 app.name' },
  { prop: 'i18nValue', label: '值', required: true, span: 24 }
])

function reload() {
  // key 变化会重建表格
}

async function loadLangs() {
  try {
    const res = await request.get('/system/lang/list')
    if (res.data && res.data.length) langs.value = res.data
  } catch (e) {
    // ignore
  }
}

onMounted(loadLangs)
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
  gap: 10px;
}
</style>
