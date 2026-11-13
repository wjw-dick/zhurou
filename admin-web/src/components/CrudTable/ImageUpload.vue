<template>
  <div class="image-upload">
    <div class="image-list">
      <div v-for="(url, index) in images" :key="url + index" class="image-item">
        <el-image :src="url" fit="cover" :preview-src-list="images" preview-teleported />
        <div class="image-actions">
          <el-icon v-if="index > 0" title="前移" @click="move(index, -1)"><Back /></el-icon>
          <el-icon v-if="index < images.length - 1" title="后移" @click="move(index, 1)"><Right /></el-icon>
          <el-icon title="删除" @click="remove(index)"><Delete /></el-icon>
        </div>
      </div>
      <el-upload
        v-if="!limit || images.length < limit"
        class="image-uploader"
        :show-file-list="false"
        :http-request="doUpload"
        accept="image/*"
        multiple
      >
        <div class="upload-slot" v-loading="uploading">
          <el-icon><Plus /></el-icon>
          <span>上传图片</span>
        </div>
      </el-upload>
    </div>
    <div class="upload-tip">支持多图，可拖拽顺序、批量删除；图片走对象存储（当前驱动可后台切换）</div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Delete, Back, Right } from '@element-plus/icons-vue'
import { getToken } from '@/utils/request'

const props = withDefaults(
  defineProps<{
    modelValue?: string | string[]
    limit?: number
    bizType?: string
  }>(),
  {}
)

const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()

const uploading = ref(false)

const images = computed<string[]>(() => {
  const v = props.modelValue
  if (!v) return []
  if (Array.isArray(v)) return v
  return String(v)
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
})

function update(list: string[]) {
  emit('update:modelValue', list.join(','))
}

function move(index: number, delta: number) {
  const list = [...images.value]
  const target = index + delta
  ;[list[index], list[target]] = [list[target], list[index]]
  update(list)
}

function remove(index: number) {
  const list = [...images.value]
  list.splice(index, 1)
  update(list)
}

async function doUpload(options: any) {
  const file: File = options.file
  const formData = new FormData()
  formData.append('file', file)
  if (props.bizType) formData.append('bizType', props.bizType)
  uploading.value = true
  try {
    const res = await fetch(`${import.meta.env.VITE_API_BASE || '/api'}/oss/file/upload`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${getToken()}` },
      body: formData
    })
    const json = await res.json()
    if (json.code === 200) {
      update([...images.value, json.data.url])
      ElMessage.success('上传成功')
    } else {
      ElMessage.error(json.msg || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败')
  } finally {
    uploading.value = false
  }
}
</script>

<style scoped>
.image-upload {
  width: 100%;
}

.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.image-item {
  position: relative;
  width: 96px;
  height: 96px;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #dcdfe6;
}

.image-item :deep(.el-image) {
  width: 100%;
  height: 100%;
}

.image-actions {
  position: absolute;
  inset: auto 0 0 0;
  display: flex;
  justify-content: space-around;
  background: rgba(0, 0, 0, 0.55);
  color: #fff;
  padding: 2px 0;
  font-size: 14px;
  cursor: pointer;
}

.upload-slot {
  width: 96px;
  height: 96px;
  border: 1px dashed #dcdfe6;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  color: #909399;
  font-size: 12px;
  cursor: pointer;
}

.upload-slot:hover {
  border-color: #409eff;
  color: #409eff;
}

.upload-tip {
  margin-top: 6px;
  color: #c0c4cc;
  font-size: 12px;
}
</style>
