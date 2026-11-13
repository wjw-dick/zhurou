<script setup lang="ts">
/**
 * 订单详情
 * 详情：GET /public/orders/{orderNo} → { order, items }
 */
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { getOrderDetail, type OrderInfo, type OrderItem } from '@/api'

const route = useRoute()

const order = ref<OrderInfo | null>(null)
const items = ref<OrderItem[]>([])
const loading = ref(true)

const STATUS_LABEL: Record<string, string> = {
  UNPAID: '待支付',
  PREPARING: '待备货',
  READY: '待取货',
  DELIVERING: '配送中',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
  AFTERSALE: '售后'
}
const DELIVERY_LABEL: Record<string, string> = {
  SELF_PICKUP: '到店自提',
  DELIVERY: '门店配送'
}
const SPLIT_LABEL: Record<string, string> = {
  CUBE: '切块',
  MINCED: '绞肉',
  SLICED: '切片',
  NONE: '不分割'
}

async function load() {
  loading.value = true
  try {
    const data = await getOrderDetail(String(route.params.orderNo))
    order.value = data?.order || null
    items.value = data?.items || []
  } catch {
    order.value = null
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<template>
  <div class="order-detail">
    <p v-if="loading" class="zs-empty">加载中…</p>
    <p v-else-if="!order" class="zs-empty">订单不存在</p>

    <template v-else>
      <div class="status-bar">
        <p class="status-text">{{ STATUS_LABEL[order.status] || order.status }}</p>
        <p class="status-tip">订单号：{{ order.orderNo }}</p>
      </div>

      <div class="zs-card" v-if="order.deliveryType">
        <p class="card-title">{{ DELIVERY_LABEL[order.deliveryType] || order.deliveryType }}</p>
        <p class="line" v-if="order.receiverName">{{ order.receiverName }} {{ order.receiverPhone }}</p>
        <p class="line" v-if="order.receiverAddress">{{ order.receiverAddress }}</p>
        <p class="line" v-if="order.appointDate">期望日期：{{ order.appointDate }}</p>
      </div>

      <div class="zs-card">
        <p class="card-title">商品明细</p>
        <div v-for="it in items" :key="it.id" class="item">
          <div class="item-info">
            <p class="item-name">{{ it.productName }}</p>
            <p class="item-sub">
              {{ it.skuName || '' }}
              <span v-if="it.splitType"> · {{ SPLIT_LABEL[it.splitType] || it.splitType }}</span>
            </p>
          </div>
          <div class="item-right">
            <span class="zs-price">{{ it.price }}</span>
            <span class="item-qty">x{{ it.quantity }}</span>
          </div>
        </div>
        <p v-if="!items.length" class="zs-empty">暂无明细</p>
      </div>

      <div class="zs-card">
        <p class="card-title">费用明细</p>
        <div class="fee-row"><span>商品金额</span><em class="zs-price">{{ order.totalAmount ?? 0 }}</em></div>
        <div class="fee-row" v-if="order.splitFee"><span>分割加工费</span><em>¥{{ order.splitFee }}</em></div>
        <div class="fee-row" v-if="order.deliveryFee"><span>配送费</span><em>¥{{ order.deliveryFee }}</em></div>
        <div class="fee-row" v-if="order.discountAmount"><span>优惠</span><em>-¥{{ order.discountAmount }}</em></div>
        <div class="fee-row total"><span>实付金额</span><em class="zs-price">{{ order.payAmount ?? order.totalAmount ?? 0 }}</em></div>
      </div>

      <div class="zs-card" v-if="order.remark || order.createTime">
        <p class="card-title">订单信息</p>
        <div class="fee-row" v-if="order.createTime"><span>下单时间</span><em>{{ order.createTime }}</em></div>
        <div class="fee-row" v-if="order.remark"><span>备注</span><em>{{ order.remark }}</em></div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.status-bar {
  padding: 18px 14px;
  color: #fff;
  background: linear-gradient(135deg, var(--zs-primary), #f0632f);
}

.status-text {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
}

.status-tip {
  margin: 6px 0 0;
  font-size: 12px;
  opacity: 0.85;
}

.card-title {
  margin: 0 0 8px;
  font-size: 14px;
  font-weight: 600;
}

.line {
  margin: 4px 0;
  font-size: 13px;
  color: #555;
}

.item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #f7f7f7;
}

.item:last-child {
  border-bottom: none;
}

.item-info {
  min-width: 0;
}

.item-name {
  margin: 0;
  font-size: 14px;
}

.item-sub {
  margin: 4px 0 0;
  font-size: 12px;
  color: var(--zs-text-gray);
}

.item-right {
  flex: none;
  text-align: right;
  font-size: 13px;
}

.item-qty {
  display: block;
  margin-top: 2px;
  color: var(--zs-text-gray);
}

.fee-row {
  display: flex;
  justify-content: space-between;
  padding: 7px 0;
  font-size: 13px;
  border-bottom: 1px solid #f7f7f7;
}

.fee-row:last-child {
  border-bottom: none;
}

.fee-row span {
  color: var(--zs-text-gray);
}

.fee-row em {
  font-style: normal;
}

.fee-row.total em {
  font-size: 16px;
  font-weight: 700;
}
</style>
