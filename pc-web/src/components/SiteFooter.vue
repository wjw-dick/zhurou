<template>
  <footer class="site-footer">
    <div class="container footer-top">
      <!-- 品牌信息 -->
      <div class="footer-col footer-col--brand">
        <div class="footer-brand">
          <span class="footer-brand__mark">猪</span>
          <strong class="footer-brand__name">{{ siteName }}</strong>
        </div>
        <p class="footer-brand__desc">{{ siteDesc }}</p>
        <div class="footer-badges">
          <span class="tag tag-gold">当日冷链</span>
          <span class="tag tag-gold">两证两章</span>
          <span class="tag tag-gold">来源可溯</span>
        </div>
      </div>

      <!-- 快速导航 -->
      <div class="footer-col">
        <h4 class="footer-col__title">快速导航</h4>
        <ul class="footer-links">
          <li v-for="menu in menus" :key="menu.path">
            <router-link :to="menu.path">{{ menu.name }}</router-link>
          </li>
        </ul>
      </div>

      <!-- 产品分类 -->
      <div class="footer-col">
        <h4 class="footer-col__title">产品分类</h4>
        <ul class="footer-links">
          <li v-for="biz in bizList" :key="biz.value">
            <router-link :to="`/products?bizType=${biz.value}`">{{ biz.label }}</router-link>
          </li>
        </ul>
      </div>

      <!-- 联系方式 -->
      <div class="footer-col">
        <h4 class="footer-col__title">联系方式</h4>
        <ul class="footer-contact">
          <li>
            <span class="footer-contact__label">客服电话</span>
            <a class="footer-contact__phone" :href="`tel:${servicePhone}`">{{ servicePhone }}</a>
          </li>
          <li>
            <span class="footer-contact__label">服务时间</span>
            <span>07:00 - 21:30</span>
          </li>
          <li>
            <span class="footer-contact__label">团购热线</span>
            <router-link to="/contact">企业团单咨询 →</router-link>
          </li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="container footer-bottom__inner">
        <span>{{ copyright }}</span>
        <span v-if="icp" class="footer-bottom__icp">
          <a href="https://beian.miit.gov.cn" target="_blank" rel="noopener">{{ icp }}</a>
        </span>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { getMenus, type MenuItem } from '@/api'
import { siteValue } from '@/store/site'

/** 兜底菜单 */
const fallbackMenus: MenuItem[] = [
  { id: 90001, parentId: 0, platform: 'PC', menuType: 'LINK', name: '首页', path: '/' },
  { id: 90002, parentId: 0, platform: 'PC', menuType: 'LINK', name: '品牌故事', path: '/brand' },
  { id: 90003, parentId: 0, platform: 'PC', menuType: 'LINK', name: '产品展示', path: '/products' },
  { id: 90004, parentId: 0, platform: 'PC', menuType: 'LINK', name: '门店导航', path: '/stores' },
  { id: 90005, parentId: 0, platform: 'PC', menuType: 'LINK', name: '新闻资讯', path: '/news' },
  { id: 90006, parentId: 0, platform: 'PC', menuType: 'LINK', name: '联系我们', path: '/contact' },
  { id: 90007, parentId: 0, platform: 'PC', menuType: 'LINK', name: '资质证照', path: '/qualification' }
]

/** 品类快捷入口 */
const bizList = [
  { value: 'PORK', label: '鲜猪肉' },
  { value: 'HOTPOT', label: '火锅食材' },
  { value: 'PROCESSED', label: '肉制品' },
  { value: 'BASE', label: '底料蘸料' },
  { value: 'SET', label: '套餐礼盒' }
]

const menus = ref<MenuItem[]>([...fallbackMenus])

const siteName = computed(() => siteValue('site.name', '猪事大吉'))
const icp = computed(() => siteValue('site.icp', ''))
const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))
const copyright = computed(
  () => siteValue('site.copyright', `© ${new Date().getFullYear()} 猪事大吉 保留所有权利`)
)
const siteDesc = computed(() =>
  siteValue(
    'site.description',
    '猪事大吉 · 社区一站式鲜肉与火锅食材超市，当日冷链直供，两证两章，支持到店自提与门店配送。'
  )
)

onMounted(async () => {
  try {
    const list = await getMenus('PC')
    if (list && list.length) {
      menus.value = list
        .filter((m) => m.status !== 0 && m.visible !== 0 && m.path)
        .sort((a, b) => (a.sort || 0) - (b.sort || 0))
        .concat([{ id: -1, parentId: 0, platform: 'PC', menuType: 'LINK', name: '资质证照', path: '/qualification' }])
    }
  } catch (e) {
    menus.value = [...fallbackMenus]
  }
})
</script>

<style scoped>
.site-footer {
  background: #1c1e22;
  color: rgba(255, 255, 255, 0.72);
  font-size: 14px;
}

.footer-top {
  display: grid;
  grid-template-columns: 1.6fr 1fr 1fr 1.2fr;
  gap: 32px;
  padding-top: 52px;
  padding-bottom: 40px;
}

.footer-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}

.footer-brand__mark {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 11px;
  font-size: 20px;
  font-weight: 800;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-gold));
}

.footer-brand__name {
  font-size: 19px;
  font-weight: 800;
  letter-spacing: 2px;
  color: #fff;
}

.footer-brand__desc {
  line-height: 1.9;
  font-size: 13.5px;
  color: rgba(255, 255, 255, 0.6);
}

.footer-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 16px;
}

.footer-col__title {
  position: relative;
  margin-bottom: 18px;
  padding-bottom: 10px;
  font-size: 16px;
  font-weight: 700;
  color: #fff;
}

.footer-col__title::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: 0;
  width: 34px;
  height: 3px;
  border-radius: 3px;
  background: linear-gradient(90deg, var(--brand-red), var(--brand-gold));
}

.footer-links li {
  margin-bottom: 10px;
}

.footer-links a {
  transition: var(--transition);
}

.footer-links a:hover {
  color: var(--brand-gold);
  padding-left: 4px;
}

.footer-contact li {
  display: flex;
  flex-direction: column;
  gap: 2px;
  margin-bottom: 14px;
}

.footer-contact__label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.4);
}

.footer-contact__phone {
  font-size: 20px;
  font-weight: 700;
  color: var(--brand-gold);
}

.footer-contact a:hover {
  color: var(--brand-gold-light);
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.footer-bottom__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
  padding-top: 18px;
  padding-bottom: 18px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.45);
}

.footer-bottom__icp a:hover {
  color: var(--brand-gold);
}

@media (max-width: 992px) {
  .footer-top {
    grid-template-columns: 1fr 1fr;
    gap: 28px;
  }
}

@media (max-width: 768px) {
  .footer-top {
    grid-template-columns: 1fr;
    padding-top: 36px;
  }

  .footer-bottom__inner {
    justify-content: center;
    text-align: center;
  }
}
</style>
