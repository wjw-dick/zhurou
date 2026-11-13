<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>系统参数配置</span>
          <div>
            <el-tag size="small" type="info">加密参数以 **** 掩码显示，留空或保持掩码即不修改</el-tag>
            <el-button type="primary" :loading="saving" :icon="Check" @click="handleSave">保存全部</el-button>
          </div>
        </div>
      </template>

      <el-tabs v-model="activeGroup" tab-position="left" class="config-tabs">
        <el-tab-pane
          v-for="(items, group) in grouped"
          :key="group"
          :name="group"
          :label="groupName(group)"
        >
          <el-form label-width="180px" style="max-width: 720px">
            <el-form-item v-for="item in items" :key="item.id" :label="item.configName">
              <el-input
                v-if="item.valueType === 'TEXT'"
                v-model="editValues[item.id]"
                type="textarea"
                :rows="3"
              />
              <el-switch
                v-else-if="item.valueType === 'BOOLEAN'"
                v-model="editValues[item.id]"
                active-value="true"
                inactive-value="false"
              />
              <ImageUpload
                v-else-if="item.valueType === 'IMAGE'"
                v-model="editValues[item.id]"
                class="upload-full-row"
              />
              <el-input
                v-else
                v-model="editValues[item.id]"
                :placeholder="item.encrypted === 1 ? '加密参数' : `请输入${item.configName}`"
              >
                <template #prefix>
                  <el-icon v-if="item.encrypted === 1"><Lock /></el-icon>
                </template>
              </el-input>
              <div v-if="item.remark" class="field-tip">{{ item.remark }}</div>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Check, Lock } from '@element-plus/icons-vue'
import ImageUpload from '@/components/CrudTable/ImageUpload.vue'
import { request } from '@/utils/request'

const grouped = ref<Record<string, any[]>>({})
const editValues = reactive<Record<number, any>>({})
const activeGroup = ref('')
const saving = ref(false)

const groupNames: Record<string, string> = {
  site: '站点信息',
  wechat: '微信配置',
  pay: '支付配置',
  delivery: '配送配置',
  commission: '佣金提成',
  reserve: '鲜肉预订',
  sms: '短信配置',
  oss: '对象存储'
}

function groupName(code: string) {
  return groupNames[code] || code
}

async function load() {
  const res = await request.get('/system/config/grouped')
  grouped.value = res.data || {}
  const keys = Object.keys(grouped.value)
  activeGroup.value = keys[0] || ''
  Object.values(grouped.value).forEach((items) => {
    items.forEach((item: any) => {
      editValues[item.id] = item.configValue
    })
  })
}

async function handleSave() {
  saving.value = true
  try {
    const items = Object.entries(editValues).map(([id, value]) => ({ id: Number(id), configValue: value }))
    await request.put('/system/config/batch', items)
    ElMessage.success('保存成功')
    await load()
  } finally {
    saving.value = false
  }
}

onMounted(load)
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

.config-tabs {
  min-height: 420px;
}

.field-tip {
  color: #c0c4cc;
  font-size: 12px;
  line-height: 1.6;
}
</style>
