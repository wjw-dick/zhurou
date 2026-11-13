<template>
  <div class="page-container">
    <!-- 顶部统计小卡 -->
    <el-row :gutter="16">
      <el-col v-for="card in cards" :key="card.label" :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" :style="{ background: card.color }">
            <el-icon :size="24"><component :is="card.icon" /></el-icon>
          </div>
          <div class="stat-body">
            <div class="stat-value">{{ card.value.value }}</div>
            <div class="stat-label">{{ card.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区 -->
    <el-row :gutter="16" style="margin-top: 16px">
      <el-col :span="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>订单状态分布</span>
              <el-tag size="small" type="info">示例数据</el-tag>
            </div>
          </template>
          <div ref="pieRef" class="chart"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>近 7 日销售趋势</span>
              <el-tag size="small" type="info">示例数据</el-tag>
            </div>
          </template>
          <div ref="lineRef" class="chart"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref } from 'vue'
import * as echarts from 'echarts'
import { request } from '@/utils/request'

const pieRef = ref<HTMLElement>()
const lineRef = ref<HTMLElement>()
let pieChart: echarts.ECharts | null = null
let lineChart: echarts.ECharts | null = null

// 顶部统计卡（用 ref 承载数值，便于异步刷新）
const cards = [
  { label: '订单总数', value: ref('0'), icon: 'Tickets', color: '#409eff' },
  { label: '会员总数', value: ref('0'), icon: 'UserFilled', color: '#67c23a' },
  { label: '商品总数', value: ref('0'), icon: 'Dish', color: '#e6a23c' },
  { label: '门店总数', value: ref('0'), icon: 'Shop', color: '#f56c6c' }
]

// 取分页总数，接口异常时降级为 0
async function loadCount(url: string) {
  try {
    const res = await request.get(url, { current: 1, size: 1 })
    return res.data?.total || 0
  } catch (e) {
    return 0
  }
}

async function loadStats() {
  const [orders, members, products, stores] = await Promise.all([
    loadCount('/order/info/page'),
    loadCount('/member/info/page'),
    loadCount('/product/info/page'),
    request
      .get('/store/info/options')
      .then((r) => (r.data || []).length)
      .catch(() => 0)
  ])
  cards[0].value.value = String(orders)
  cards[1].value.value = String(members)
  cards[2].value.value = String(products)
  cards[3].value.value = String(stores)
}

// 订单状态分布饼图
function initPie() {
  if (!pieRef.value) return
  pieChart = echarts.init(pieRef.value)
  pieChart.setOption({
    tooltip: { trigger: 'item' },
    legend: { bottom: 0 },
    series: [
      {
        name: '订单状态',
        type: 'pie',
        radius: ['40%', '68%'],
        avoidLabelOverlap: true,
        itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 },
        label: { formatter: '{b}: {c}' },
        data: [
          { name: '待付款', value: 32 },
          { name: '待备货', value: 48 },
          { name: '待取货', value: 26 },
          { name: '配送中', value: 18 },
          { name: '已完成', value: 96 },
          { name: '已取消', value: 8 }
        ]
      }
    ]
  })
}

// 近 7 日销售折线图
function initLine() {
  if (!lineRef.value) return
  lineChart = echarts.init(lineRef.value)
  const days = Array.from({ length: 7 }, (_, i) => {
    const d = new Date()
    d.setDate(d.getDate() - (6 - i))
    return `${d.getMonth() + 1}/${d.getDate()}`
  })
  lineChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: 50, right: 20, top: 30, bottom: 30 },
    xAxis: { type: 'category', data: days, boundaryGap: false },
    yAxis: { type: 'value' },
    series: [
      {
        name: '销售额',
        type: 'line',
        smooth: true,
        areaStyle: { opacity: 0.15 },
        data: [3200, 4100, 3800, 5200, 6800, 5900, 7400]
      }
    ]
  })
}

function onResize() {
  pieChart?.resize()
  lineChart?.resize()
}

onMounted(() => {
  loadStats()
  initPie()
  initLine()
  window.addEventListener('resize', onResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', onResize)
  pieChart?.dispose()
  lineChart?.dispose()
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
</style>
