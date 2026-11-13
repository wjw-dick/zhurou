<template>
  <div class="page qualification-page">
    <PageBanner
      title="资质证照"
      subtitle="两证两章 · 亮证经营 · 来源可溯"
      :crumbs="[{ label: '资质证照' }]"
    />

    <div class="container">
      <!-- 说明 -->
      <section class="intro">
        <div class="intro__text">
          <h2 class="section-title">亮证经营，敢查敢看</h2>
          <p>
            猪事大吉所有门店均依法取得营业执照与食品经营许可，猪肉类商品严格执行
            「两证两章」制度；加工类产品公示食品生产许可（SC）编号与产品检测报告。
          </p>
          <p>
            你可以在门店要求查看上述证照原件，也可以对照商品详情页「检疫资质证明」栏目核验证书编号；
            如发现证照与实物不符，欢迎随时拨打客服电话
            <a :href="`tel:${servicePhone}`">{{ servicePhone }}</a> 反馈。
          </p>
        </div>

        <div class="intro__badge">
          <div class="intro__seal">
            <strong>两证两章</strong>
            <span>两证齐全 · 两章清晰</span>
          </div>
        </div>
      </section>

      <!-- 两证两章拆解 -->
      <section class="section two-cert">
        <div class="section-head">
          <div>
            <h2 class="section-title">什么是「两证两章」</h2>
            <p class="section-sub">猪肉产品上市销售的法定凭证</p>
          </div>
        </div>

        <div class="two-cert__grid">
          <div v-for="item in twoCert" :key="item.title" class="cert-explain card">
            <span class="cert-explain__icon">{{ item.icon }}</span>
            <strong class="cert-explain__title">{{ item.title }}</strong>
            <span class="cert-explain__en">{{ item.en }}</span>
            <p class="cert-explain__desc">{{ item.desc }}</p>
          </div>
        </div>

        <div class="two-cert__note">
          <span>※</span>
          <p>
            「两章」指猪胴体上加盖的<strong>检疫验讫印章</strong>（蓝色滚筒章）与
            <strong>肉品品质检验印章</strong>（红色圆形章）。门店销售的每一块猪肉均可追溯到对应批次。
          </p>
        </div>
      </section>

      <!-- 证照展示 -->
      <section class="section certs">
        <div class="section-head">
          <div>
            <h2 class="section-title">企业资质证照</h2>
            <p class="section-sub">以下是公司依法公开的资质类别，原件在门店与办公场所公示</p>
          </div>
        </div>

        <div class="certs__grid">
          <div v-for="cert in certificates" :key="cert.code" class="cert-card card">
            <!-- 证照图片占位 -->
            <div class="cert-card__preview">
              <div class="cert-card__preview-inner">
                <span class="cert-card__preview-icon">📄</span>
                <strong>{{ cert.name }}</strong>
                <small>证照扫描件公示中</small>
              </div>
              <span class="cert-card__badge">有效</span>
            </div>

            <div class="cert-card__body">
              <span class="cert-card__code">{{ cert.code }}</span>
              <h3 class="cert-card__name">{{ cert.name }}</h3>
              <ul class="cert-card__list">
                <li><span>发证机构</span>{{ cert.issuer }}</li>
                <li><span>有效期</span>{{ cert.validity }}</li>
                <li><span>公示范围</span>{{ cert.scope }}</li>
              </ul>
              <p class="cert-card__desc">{{ cert.desc }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- 查验指引 -->
      <section class="section how">
        <div class="section-head">
          <div>
            <h2 class="section-title">如何查验</h2>
            <p class="section-sub">三步确认你买到的肉是放心肉</p>
          </div>
        </div>

        <div class="how__steps">
          <div v-for="(step, index) in howSteps" :key="step.title" class="how__step">
            <span class="how__index">{{ index + 1 }}</span>
            <strong>{{ step.title }}</strong>
            <p>{{ step.desc }}</p>
          </div>
        </div>
      </section>

      <!-- 行动区 -->
      <section class="cta">
        <div class="cta__inner">
          <div>
            <h2 class="cta__title">对资质有任何疑问？</h2>
            <p class="cta__sub">欢迎联系我们索取证照扫描件或到店查验原件</p>
          </div>
          <router-link to="/contact" class="btn btn-gold">联系我们 →</router-link>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import PageBanner from '@/components/PageBanner.vue'
import { siteValue } from '@/store/site'

const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))

/** 两证两章说明 */
const twoCert = [
  {
    icon: '🔵',
    title: '动物产品检疫合格证明',
    en: 'Animal Quarantine Certificate',
    desc: '由动物卫生监督机构出具，证明该批动物产品经检疫合格、无规定动物疫病，对应猪胴体加盖检疫验讫印章。'
  },
  {
    icon: '🔴',
    title: '肉品品质检验合格证',
    en: 'Meat Quality Inspection Certificate',
    desc: '由定点屠宰企业肉品品质检验机构出具，证明瘦肉精、注水、病害肉等检验项目合格，对应加盖肉品品质检验印章。'
  },
  {
    icon: '🏭',
    title: '食品生产许可（SC）',
    en: 'Food Production License',
    desc: '肉制品、底料蘸料等加工类产品由取得 SC 许可的工厂生产，包装上印有 SC 编号，可在国家企业信用信息公示系统查验。'
  },
  {
    icon: '🧪',
    title: '产品检测报告',
    en: 'Product Test Report',
    desc: '定期委托第三方检测机构对兽药残留、微生物等指标抽检，报告随批次归档备查。'
  }
]

/** 企业资质证照（静态占位，实际以门店/办公场所公示原件为准） */
const certificates = [
  {
    code: 'BUSINESS',
    name: '营业执照',
    issuer: '市场监督管理局',
    validity: '长期（以执照为准）',
    scope: '公司主体',
    desc: '载明统一社会信用代码、经营范围与注册资本，可在国家企业信用信息公示系统核验。'
  },
  {
    code: 'FOOD_BUSINESS',
    name: '食品经营许可证',
    issuer: '市场监督管理局',
    validity: '有效期 5 年',
    scope: '各门店',
    desc: '经营项目包含散装食品销售（含冷藏冷冻食品），门店亮证经营，持证在店内显著位置公示。'
  },
  {
    code: 'SC',
    name: '食品生产许可证（SC）',
    issuer: '省级市场监督管理局',
    validity: '有效期 5 年',
    scope: '加工类产品',
    desc: '用于肉制品、火锅底料蘸料等自加工或委托加工产品，编号形如 SC102xxxxxxxxxx。'
  },
  {
    code: 'QUARANTINE',
    name: '动物产品检疫合格证明',
    issuer: '动物卫生监督机构',
    validity: '按批次出具',
    scope: '猪肉类商品',
    desc: '每批猪肉随货同行，可在商品详情页查看证书编号与发证日期。'
  },
  {
    code: 'QUALITY',
    name: '肉品品质检验合格证',
    issuer: '定点屠宰企业肉品品质检验机构',
    validity: '按批次出具',
    scope: '猪肉类商品',
    desc: '与检疫合格证明配套查验，两证齐全方可上架销售。'
  },
  {
    code: 'INSPECTION',
    name: '第三方检测报告',
    issuer: '具备 CMA 资质的检测机构',
    validity: '按抽检批次',
    scope: '重点品类',
    desc: '对兽药残留、微生物、食品添加剂等指标进行检测，报告结论为合格。'
  }
]

/** 查验步骤 */
const howSteps = [
  {
    title: '看证',
    desc: '在门店查看《动物产品检疫合格证明》与《肉品品质检验合格证》，确认批次与日期在有效期内。'
  },
  {
    title: '看章',
    desc: '检查猪胴体上的检疫验讫印章与肉品品质检验印章，印章清晰、可辨识。'
  },
  {
    title: '对码',
    desc: '打开商品详情页「检疫资质证明」栏目，核对证书编号、发证机构与有效期是否一致。'
  }
]
</script>

<style scoped>
/* ---------------- 说明 ---------------- */
.intro {
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  gap: 40px;
  align-items: center;
  padding: 44px 0 10px;
}

.intro__text p {
  margin-top: 14px;
  color: var(--text-sub);
  line-height: 2;
}

.intro__text a {
  color: var(--brand-red);
  font-weight: 700;
}

.intro__badge {
  display: flex;
  align-items: center;
  justify-content: center;
}

.intro__seal {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 210px;
  height: 210px;
  border-radius: 50%;
  color: var(--brand-red);
  border: 6px double var(--brand-red);
  box-shadow: 0 18px 38px rgba(200, 22, 29, 0.16);
  background: #fff;
  transform: rotate(-8deg);
}

.intro__seal strong {
  font-size: 32px;
  font-weight: 900;
  letter-spacing: 4px;
}

.intro__seal span {
  margin-top: 8px;
  font-size: 13px;
  letter-spacing: 1px;
  color: var(--brand-gold-dark);
}

/* ---------------- 两证两章 ---------------- */
.two-cert {
  background: #fff;
  margin-top: 34px;
  border-radius: var(--radius-lg);
  padding: 44px 34px;
}

.two-cert__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.cert-explain {
  padding: 26px 22px;
  border: 1px solid var(--border-color);
  border-top: 4px solid var(--brand-red);
}

.cert-explain__icon {
  font-size: 28px;
}

.cert-explain__title {
  display: block;
  margin: 12px 0 4px;
  font-size: 16px;
  font-weight: 800;
}

.cert-explain__en {
  display: block;
  margin-bottom: 10px;
  font-size: 11.5px;
  letter-spacing: 0.5px;
  color: var(--brand-gold-dark);
}

.cert-explain__desc {
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

.two-cert__note {
  display: flex;
  gap: 10px;
  margin-top: 22px;
  padding: 16px 20px;
  border-radius: var(--radius);
  background: var(--bg-soft);
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

.two-cert__note span {
  color: var(--brand-red);
  font-weight: 800;
}

.two-cert__note strong {
  color: var(--brand-red);
}

/* ---------------- 证照卡片 ---------------- */
.certs__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}

.cert-card {
  display: flex;
  flex-direction: column;
  border: 1px solid var(--border-color);
}

.cert-card__preview {
  position: relative;
  padding: 22px;
  background: linear-gradient(150deg, #fffaf3, #fdf1e2);
  border-bottom: 1px solid rgba(212, 163, 91, 0.28);
}

.cert-card__preview-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 150px;
  border-radius: 10px;
  border: 2px dashed rgba(212, 163, 91, 0.55);
  background: rgba(255, 255, 255, 0.6);
  text-align: center;
}

.cert-card__preview-icon {
  font-size: 30px;
}

.cert-card__preview-inner strong {
  font-size: 15px;
  color: var(--brand-gold-dark);
}

.cert-card__preview-inner small {
  font-size: 12px;
  color: var(--text-muted);
}

.cert-card__badge {
  position: absolute;
  right: 14px;
  top: 14px;
  padding: 3px 12px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-red-light));
}

.cert-card__body {
  padding: 20px 22px 24px;
}

.cert-card__code {
  font-size: 11.5px;
  letter-spacing: 1px;
  color: var(--brand-gold-dark);
}

.cert-card__name {
  margin: 6px 0 14px;
  font-size: 17px;
  font-weight: 800;
}

.cert-card__list li {
  display: flex;
  gap: 12px;
  margin-bottom: 7px;
  font-size: 13.5px;
  color: var(--text-sub);
}

.cert-card__list li span {
  flex-shrink: 0;
  width: 62px;
  color: var(--text-muted);
}

.cert-card__desc {
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px dashed var(--border-color);
  font-size: 13px;
  line-height: 1.9;
  color: var(--text-muted);
}

/* ---------------- 查验步骤 ---------------- */
.how__steps {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}

.how__step {
  padding: 28px 26px;
  border-radius: var(--radius);
  background: #fff;
  box-shadow: var(--shadow-sm);
}

.how__index {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  margin-bottom: 14px;
  border-radius: 50%;
  font-size: 16px;
  font-weight: 800;
  color: #fff;
  background: linear-gradient(135deg, var(--brand-red), var(--brand-gold));
}

.how__step strong {
  display: block;
  margin-bottom: 8px;
  font-size: 17px;
}

.how__step p {
  font-size: 13.5px;
  line-height: 1.9;
  color: var(--text-sub);
}

/* ---------------- CTA ---------------- */
.cta {
  margin-top: 20px;
  border-radius: var(--radius-lg);
  background: linear-gradient(120deg, var(--brand-red-dark), var(--brand-red) 70%, #e0503f);
  color: #fff;
}

.cta__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 38px 34px;
}

.cta__title {
  font-size: 24px;
  font-weight: 800;
}

.cta__sub {
  margin-top: 8px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.82);
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 1200px) {
  .certs__grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .two-cert__grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 992px) {
  .intro {
    grid-template-columns: 1fr;
    gap: 26px;
  }
}

@media (max-width: 768px) {
  .certs__grid,
  .two-cert__grid,
  .how__steps {
    grid-template-columns: 1fr;
  }

  .two-cert {
    padding: 28px 18px;
  }

  .intro__seal {
    width: 160px;
    height: 160px;
  }

  .intro__seal strong {
    font-size: 24px;
  }

  .cta__inner {
    flex-direction: column;
    text-align: center;
    padding: 28px 20px;
  }
}
</style>
