import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'node:path'

// 猪事大吉 · PC 官网构建配置
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      // 路径别名 @ 指向 src
      '@': path.resolve(__dirname, 'src')
    }
  },
  server: {
    host: '0.0.0.0',
    port: 5174,
    open: false,
    proxy: {
      // 开发环境代理到后端
      '/api': {
        target: 'http://127.0.0.1:8090',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: 'dist',
    chunkSizeWarningLimit: 1500
  }
})
