import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { initLang } from './store/lang'
import { loadSiteConfig } from './store/site'
import './styles/global.scss'

const app = createApp(App)

app.use(router)
app.mount('#app')

// 初始化多语言词条与站点配置（失败静默降级）
initLang()
loadSiteConfig()
