<template>
  <div class="rich-editor">
    <Toolbar :editor="editorRef" :default-config="toolbarConfig" mode="default" class="editor-toolbar" />
    <Editor
      v-model="valueHtml"
      :default-config="editorConfig"
      mode="default"
      class="editor-body"
      @on-created="onCreated"
      @on-change="onChange"
    />
  </div>
</template>

<script setup lang="ts">
import { onBeforeUnmount, ref, shallowRef } from 'vue'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import '@wangeditor/editor/dist/css/style.css'
import { getToken } from '@/utils/request'

const props = defineProps<{ modelValue?: string }>()
const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()

const editorRef = shallowRef()
const valueHtml = ref(props.modelValue || '')

const toolbarConfig = {
  excludeKeys: ['group-video', 'insertVideo']
}

const editorConfig = {
  placeholder: '请输入内容…',
  MENU_CONF: {
    uploadImage: {
      server: `${import.meta.env.VITE_API_BASE || '/api'}/oss/file/upload`,
      fieldName: 'file',
      headers: { Authorization: `Bearer ${getToken()}` },
      customInsert(res: any, insertFn: any) {
        if (res.code === 200) {
          insertFn(res.data.url, '', res.data.url)
        }
      }
    }
  }
}

function onCreated(editor: any) {
  editorRef.value = editor
}

function onChange(editor: any) {
  emit('update:modelValue', editor.getHtml())
}

onBeforeUnmount(() => {
  editorRef.value?.destroy()
})
</script>

<style scoped>
.rich-editor {
  width: 100%;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  z-index: 1;
}

.editor-toolbar {
  border-bottom: 1px solid #ebeef5;
}

.editor-body {
  height: 320px;
  overflow-y: hidden;
}
</style>
