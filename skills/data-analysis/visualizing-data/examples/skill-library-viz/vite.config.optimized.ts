import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({
  plugins: [
    vue(),
    // 自动导入 Element Plus API（如 ElMessage, ElMessageBox）
    AutoImport({
      resolvers: [ElementPlusResolver()],
      imports: ['vue', 'vue-router', 'pinia'],
      dts: 'src/auto-imports.d.ts',
    }),
    // 自动注册 Element Plus 组件
    Components({
      resolvers: [ElementPlusResolver()],
      dts: 'src/components.d.ts',
    }),
  ],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 3002,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
  build: {
    // 代码分割策略
    rollupOptions: {
      output: {
        manualChunks: (id) => {
          // Vue 核心生态 - 变化少，利于缓存
          if (id.includes('node_modules/vue/') || 
              id.includes('node_modules/vue-router/') || 
              id.includes('node_modules/pinia/')) {
            return 'vue-vendor'
          }
          // Element Plus - 单独打包，按需加载
          if (id.includes('node_modules/element-plus/')) {
            return 'element-plus'
          }
          // 工具库
          if (id.includes('node_modules/axios/') || 
              id.includes('node_modules/dayjs/')) {
            return 'utils'
          }
          // 如果使用 lodash-es
          if (id.includes('node_modules/lodash-es/')) {
            return 'lodash'
          }
        },
        // 优化 chunk 文件命名
        chunkFileNames: (chunkInfo) => {
          const facadeModuleId = chunkInfo.facadeModuleId 
            ? chunkInfo.facadeModuleId.split('/').pop() 
            : 'chunk'
          return `assets/js/${chunkInfo.name || facadeModuleId}-[hash].js`
        },
        entryFileNames: 'assets/js/[name]-[hash].js',
        assetFileNames: 'assets/[ext]/[name]-[hash].[ext]',
      },
    },
    // 启用 CSS 代码分割
    cssCodeSplit: true,
    // 启用 minify (使用 esbuild，比 terser 更快)
    minify: 'esbuild',
    // 构建目标
    target: 'es2020',
    // chunk 大小警告阈值
    chunkSizeWarningLimit: 500,
    // 启用 source map（生产环境可关闭以减小体积）
    sourcemap: false,
    // 内联动态导入的小模块
    dynamicImportVarsOptions: {
      warnOnError: true,
    },
  },
  // 优化依赖预构建
  optimizeDeps: {
    include: ['vue', 'vue-router', 'pinia', 'axios', 'dayjs'],
    exclude: ['element-plus'], // 按需引入，排除预构建
  },
})