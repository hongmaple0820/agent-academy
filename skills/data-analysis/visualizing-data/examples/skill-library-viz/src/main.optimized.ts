import { createApp } from 'vue'
import { createPinia } from 'pinia'
// ✅ 按需引入 - 由 unplugin 自动处理
// ❌ 删除全量引入：import ElementPlus from 'element-plus'
// ❌ 删除全量样式：import 'element-plus/dist/index.css'

// 如果需要全局样式，可以引入（可选）
// import 'element-plus/theme-chalk/index.css'

import App from './App.vue'
import router from './router'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
// ❌ 删除全量注册：app.use(ElementPlus)
// Element Plus 组件现在由 unplugin-vue-components 自动按需注册

app.mount('#app')