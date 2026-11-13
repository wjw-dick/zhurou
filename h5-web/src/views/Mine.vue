<script setup lang="ts">
/**
 * 我的
 * 会员信息：GET /public/member/{id}
 * 我的订单：GET /public/orders?memberId=&status=&current=&size=
 */
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getMember, getMemberId, getOrders, type MemberInfo, type OrderInfo } from '@/api'

const router = useRouter()

const memberId = ref<number | null>(null)
const member = ref<MemberInfo | null>(null)
const orders = ref<OrderInfo[]>([])
const loading = ref(false)

// 订单状态（与后端字典一致）
const STATUS_TABS = [
  { label: '全部', value: '' },
  { label: '待支付', value: 'UNPAID' },
  { label: '待备货', value: 'PREPARING' },
  { label: '待取货', value: 'READY' },
  { label: '配送中', value: 'DELIVERING' },
  { label: '已完成', value: 'COMPLETED' }
]
const STATUS_LABEL: Record<string, string> = {
  UNPAID: '待支付',
  PREPARING: '待备货',
  READY: '待取货',
  DELIVERING: '配送中',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
  AFTERSALE: '售后'
}

const activeStatus = ref('')

async function loadMember() {
  if (!memberId.value) return
  try {
    member.value = await getMember(memberId.value)
  } catch {
    member.value = null
  }
}

async function loadOrders() {
  if (!memberId.value) return
  loading.value = true
  try {
    const page = await getOrders({
      memberId: memberId.value,
      status: activeStatus.value || undefined,
      current: 1,
      size: 20
    })
    orders.value = page?.records || []
  } catch {
    orders.value = []
  } finally {
    loading.value = false
  }
}

function changeStatus(value: string) {
  activeStatus.value = value
  loadOrders()
}

onMounted(() => {
  memberId.value = getMemberId()
  loadMember()
  loadOrders()
})
</script>

<template>
  <div class="mine">
    <!-- 会员卡片 -->
    <div class="member-card">
      <img class="avatar" :src="member?.avatar || ''" alt="头像" />
      <div class="member-info">
        <p class="nickname">{{ member?.nickname || (memberId ? `会员 ${memberId}` : '未登录') }}</p>
        <p class="phone">{{ member?.phone || '微信登录后展示手机号' }}</p>
      </div>
    </div>

    <div class="stats zs-card" v-if="member">
      <div class="stat">
        <p class="stat-num">{{ member.balance ?? 0 }}</p>
        <p class="stat-label">储值余额</p>
      </div>
      <div class="stat">
        <p class="stat-num">{{ member.points ?? 0 }}</p>
        <p class="stat-label">积分</p>
      </div>
      <div class="stat">
        <p class="stat-num">{{ member.totalAmount ?? 0 }}</p>
        <p class="stat-label">累计消费</p>
      </div>
    </div>

    <p class="zs-section-title">我的订单</p>

    <div class="tabs">
      <span
        v-for="t in STATUS_TABS"
        :key="t.value"
        class="tab"
        :class="{ active: activeStatus === t.value }"
        @click="changeStatus(t.value)"
      >
        {{ t.label }}
      </span>
    </div>

    <div class="order-list">
      <div v-for="o in orders" :key="o.id" class="order-card" @click="router.push(`/order/${o.orderNo}`)">
        <div class="order-head">
          <span class="order-no">{{ o.orderNo }}</span>
          <span class="order-status">{{ STATUS_LABEL[o.status] || o.status }}</span>
        </div>
        <div class="order-body">
          <span class="order-type">{{ o.orderType }}</span>
          <span class="order-amount zs-price">{{ o.payAmount ?? o.totalAmount ?? 0 }}</span>
        </div>
        <p class="order-time">{{ o.createTime || '' }}</p>
      </div>
    </div>

    <p v-if="!memberId" class="zs-empty">未获取到会员信息，请从微信菜单或分享链接进入</p>
    <p v-else-if="!loading && !orders.length" class="zs-empty">暂无订单</p>
  </div>
</template>

<style scoped>
.member-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px 14px;
  color: #fff;
  background: linear-gradient(135deg, var(--zs-primary), #f0632f);
}

.avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
}

.nickname {
  margin: 0;
  font-size: 17px;
  font-weight: 600;
}

.phone {
  margin: 6px 0 0;
  font-size: 12px;
  opacity: 0.85;
}

.stats {
  display: flex;
  margin-top: -14px;
}

.stat {
  flex: 1;
  text-align: center;
}

.stat-num {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: var(--zs-primary);
}

.stat-label {
  margin: 4px 0 0;
  font-size: 12px;
  color: var(--zs-text-gray);
}

.tabs {
  display: flex;
  gap: 6px;
  padding: 0 10px 8px;
  overflow-x: auto;
}

.tab {
  flex: none;
  padding: 5px 12px;
  border-radius: 14px;
  font-size: 12px;
  color: var(--zs-text-gray);
  background: #f2f2f4;
}

.tab.active {
  color: #fff;
  background: var(--zs-primary);
}

.order-list {
  padding: 0 10px;
}

.order-card {
  margin-bottom: 10px;
  padding: 10px 12px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.order-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 12px;
}

.order-no {
  color: var(--zs-text-gray);
}

.order-status {
  color: var(--zs-primary);
  font-weight: 600;
}

.order-body {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 8px;
  font-size: 14px;
}

.order-amount {
  font-size: 16px;
}

.order-time {
  margin: 8px 0 0;
  font-size: 11px;
  color: #bbb;
}
</style>
