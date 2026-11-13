<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>对象存储配置</span>
          <div>
            <el-tag size="small" type="info">当前驱动：{{ currentDriverLabel }}</el-tag>
            <el-button :icon="RefreshRight" @click="load">刷新</el-button>
          </div>
        </div>
      </template>

      <!-- 5 驱动卡片单选 -->
      <div class="driver-cards">
        <div
          v-for="d in drivers"
          :key="d.value"
          class="driver-card"
          :class="{ active: form.driver === d.value }"
          @click="selectDriver(d.value)"
        >
          <div class="driver-icon">{{ d.icon }}</div>
          <div class="driver-name">{{ d.label }}</div>
          <div class="driver-desc">{{ d.desc }}</div>
          <el-icon v-if="form.driver === d.value" class="driver-check"><CircleCheckFilled /></el-icon>
        </div>
      </div>

      <!-- 滑出表单 -->
      <el-drawer v-model="drawerVisible" :title="`配置 · ${currentDriverLabel}`" size="480px" destroy-on-close>
        <el-form label-width="130px">
          <template v-if="form.driver === 'LOCAL'">
            <el-form-item label="上传根目录">
              <el-input v-model="props.uploadPath" placeholder="./uploads" />
            </el-form-item>
            <el-form-item label="访问前缀">
              <el-input v-model="props.urlPrefix" placeholder="/uploads" />
            </el-form-item>
          </template>
          <template v-else>
            <el-form-item label="Endpoint">
              <el-input v-model="props.endpoint" :placeholder="placeholderOf().endpoint" />
            </el-form-item>
            <el-form-item v-if="form.driver === 'S3' || form.driver === 'COS'" label="Region">
              <el-input v-model="props.region" :placeholder="placeholderOf().region" />
            </el-form-item>
            <el-form-item label="Bucket">
              <el-input v-model="props.bucket" placeholder="存储桶名称" />
            </el-form-item>
            <el-form-item label="AccessKey">
              <el-input v-model="props.accessKey" placeholder="AK（加密存储）" />
            </el-form-item>
            <el-form-item label="SecretKey">
              <el-input v-model="props.secretKey" type="password" show-password placeholder="SK（加密存储）" />
            </el-form-item>
            <el-form-item label="访问域名前缀">
              <el-input v-model="props.urlPrefix" placeholder="https://cdn.example.com" />
            </el-form-item>
          </template>
          <el-form-item label="设为默认">
            <el-switch v-model="form.isDefault" :active-value="1" :inactive-value="0" />
          </el-form-item>
          <el-form-item label="启用">
            <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button :icon="Connection" :loading="testing" @click="handleTest">连接测试</el-button>
          <el-button type="primary" :loading="saving" @click="handleSave">保存配置</el-button>
        </template>
      </el-drawer>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { RefreshRight, Connection, CircleCheckFilled } from '@element-plus/icons-vue'
import { request } from '@/utils/request'

const drivers = [
  { value: 'LOCAL', label: '本地存储', desc: '服务器磁盘', icon: '💾' },
  { value: 'MINIO', label: 'MinIO', desc: '自建对象存储', icon: '📦' },
  { value: 'S3', label: 'AWS S3', desc: '亚马逊 S3 / 兼容', icon: '☁️' },
  { value: 'OSS', label: '阿里云 OSS', desc: '阿里云对象存储', icon: '🟠' },
  { value: 'COS', label: '腾讯云 COS', desc: '腾讯云对象存储', icon: '🔵' }
]

const form = reactive<any>({ id: null, driver: 'LOCAL', isDefault: 1, status: 1 })
const props = reactive<any>({
  uploadPath: './uploads',
  urlPrefix: '/uploads',
  endpoint: '',
  region: 'us-east-1',
  bucket: '',
  accessKey: '',
  secretKey: ''
})

const drawerVisible = ref(false)
const saving = ref(false)
const testing = ref(false)

const currentDriverLabel = computed(() => drivers.find((d) => d.value === form.driver)?.label || form.driver)

function placeholderOf() {
  const map: Record<string, { endpoint: string; region: string }> = {
    MINIO: { endpoint: 'http://127.0.0.1:9000', region: 'us-east-1' },
    S3: { endpoint: 'https://s3.amazonaws.com', region: 'ap-southeast-1' },
    OSS: { endpoint: 'oss-cn-hangzhou.aliyuncs.com', region: '' },
    COS: { endpoint: 'https://cos.ap-guangzhou.myqcloud.com', region: 'ap-guangzhou' }
  }
  return map[form.driver] || { endpoint: '', region: '' }
}

async function load() {
  const res = await request.get('/oss/config/current')
  if (res.data) {
    Object.assign(form, {
      id: res.data.id,
      driver: res.data.driver || 'LOCAL',
      isDefault: res.data.isDefault ?? 1,
      status: res.data.status ?? 1
    })
    try {
      const cfg = typeof res.data.configJson === 'string' ? JSON.parse(res.data.configJson) : res.data.configJson
      if (cfg) Object.assign(props, cfg)
    } catch (e) {
      // ignore
    }
  }
}

function selectDriver(driver: string) {
  form.driver = driver
  drawerVisible.value = true
}

function buildConfigJson() {
  if (form.driver === 'LOCAL') {
    return JSON.stringify({ uploadPath: props.uploadPath, urlPrefix: props.urlPrefix })
  }
  return JSON.stringify({
    endpoint: props.endpoint,
    region: props.region,
    bucket: props.bucket,
    accessKey: props.accessKey,
    secretKey: props.secretKey,
    urlPrefix: props.urlPrefix
  })
}

async function handleTest() {
  testing.value = true
  try {
    const res = await request.post('/oss/config/test', { ...form, configJson: buildConfigJson() })
    if (res.data) {
      ElMessage.success('连接成功')
    } else {
      ElMessage.error('连接失败，请检查参数')
    }
  } finally {
    testing.value = false
  }
}

async function handleSave() {
  saving.value = true
  try {
    await request.put('/oss/config/save', { ...form, configJson: buildConfigJson() })
    ElMessage.success('保存成功')
    drawerVisible.value = false
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

.driver-cards {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

.driver-card {
  position: relative;
  width: 190px;
  padding: 18px 16px;
  border: 2px solid #ebeef5;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  background: #fff;
}

.driver-card:hover {
  border-color: #c6e2ff;
  transform: translateY(-2px);
}

.driver-card.active {
  border-color: #409eff;
  box-shadow: 0 4px 14px rgba(64, 158, 255, 0.18);
}

.driver-icon {
  font-size: 26px;
}

.driver-name {
  font-weight: 600;
  margin: 8px 0 4px;
}

.driver-desc {
  color: #909399;
  font-size: 12px;
}

.driver-check {
  position: absolute;
  top: 10px;
  right: 10px;
  color: #409eff;
  font-size: 18px;
}
</style>
