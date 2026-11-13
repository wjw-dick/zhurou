<template>
  <div class="page-container">
    <el-row :gutter="16">
      <el-col v-for="card in cards" :key="card.label" :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" :style="{ background: card.color }">
            <el-icon :size="24"><component :is="card.icon" /></el-icon>
          </div>
          <div class="stat-body">
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-label">{{ card.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16" style="margin-top: 16px">
      <el-col :span="16">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>近 7 日订单趋势</span>
              <el-tag size="small" type="info">示例数据</el-tag>
            </div>
          </template>
          <div ref="chartRef" class="chart"></div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="never">
          <template #header>
            <div class="card-header"><span>快捷入口</span></div>
          </template>
          <div class="quick-links">
            <div v-for="link in quickLinks" :key="link.path" class="quick-link" @click="$router.push(link.path)">
              <el-icon><component :is="link.icon" /></el-icon>
              <span>{{ link.label }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref, reactive } from 'vue'
import * as echarts from 'echarts'
import { request } from '@/utils/request'

const chartRef = ref<HTMLElement>()
let chart: echarts.ECharts | null = null

const state = reactive({ orders: 0, members: 0, products: 0, stores: 0 })

const cards = [
  { label: '订单总数', value: ref('0'), icon: 'Tickets', color: '#409eff', key: 'orders' },
  { label: '会员总数', value: ref('0'), icon: 'UserFilled', color: '#67c23a', key: 'members' },
  { label: '在售商品', value: ref('0'), icon: 'Dish', color: '#e6a23c', key: 'products' },
  { label: '营业门店', value: ref('0'), icon: 'Shop', color: '#f56c6c', key: 'stores' }
]

const quickLinks = [
  { label: '鲜肉预订备货', path: '/reserve/stock', icon: 'Box' },
  { label: '订单中心', path: '/order/list', icon: 'DocumentCopy' },
  { label: '菜单维护', path: '/system/menu', icon: 'Menu' },
  { label: '系统参数', path: '/system/config', icon: 'Tools' },
  { label: '供应商对账', path: '/supplier/settlement', icon: 'Money' },
  { label: '渠道报单审核', path: '/channel/order', icon: 'EditPen' }
]

async function loadStats() {
  const safe = async (url: string, params?: any) => {
    try {
      const res = await request.get(url, { ...params, current: 1, size: 1 })
      return res.data?.total || 0
    } catch (e) {
      return 0
    }
  }
  const [orders, members, products, stores] = await Promise.all([
    safe('/order/info/page'),
    safe('/member/info/page'),
    safe('/product/info/page'),
    request.get('/store/info/options').then((r) => (r.data || []).length).catch(() => 0)
  ])
  cards[0].value.value = String(orders)
  cards[1].value.value = String(members)
  cards[2].value.value = String(products)
  cards[3].value.value = String(stores)
}

function initChart() {
  if (!chartRef.value) return
  chart = echarts.init(chartRef.value)
  const days = Array.from({ length: 7 }, (_, i) => {
    const d = new Date()
    d.setDate(d.getDate() - (6 - i))
    return `${d.getMonth() + 1}/${d.getDate()}`
  })
  chart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: 40, right: 20, top: 30, bottom: 30 },
    xAxis: { type: 'category', data: days },
    yAxis: { type: 'value' },
    series: [
      {
        name: '订单数',
        type: 'line',
        smooth: true,
        areaStyle: { opacity: 0.15 },
        data: [12, 18, 15, 22, 30, 26, 34]
      }
    ]
  })
}

function onResize() {
  chart?.resize()
}

onMounted(() => {
  loadStats()
  initChart()
  window.addEventListener('resize', onResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', onResize)
  chart?.dispose()
})
</script>

<style scoped>
.stat-card :deep(.el-card__body) {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 10px;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
}

.stat-label {
  color: #909399;
  font-size: 13px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart {
  height: 320px;
}

.quick-links {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.quick-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 12px;
  border-radius: 6px;
  background: #f5f7fa;
  cursor: pointer;
  transition: all 0.2s;
}

.quick-link:hover {
  background: #ecf5ff;
  color: #409eff;
}
</style>
