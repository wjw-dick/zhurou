<template>
  <div class="page contact-page">
    <PageBanner
      title="联系我们"
      subtitle="企业团单 · 渠道合作 · 售后咨询，欢迎随时联系"
      :crumbs="[{ label: '联系我们' }]"
    />

    <div class="container contact-body">
      <!-- 左侧：联系信息 -->
      <div class="contact-info">
        <h2 class="section-title">联系方式</h2>
        <p class="section-sub">工作日 09:00 - 18:00，节假日不休</p>

        <div class="info-list">
          <div v-for="item in contactItems" :key="item.label" class="info-card card">
            <span class="info-card__icon">{{ item.icon }}</span>
            <div class="info-card__body">
              <span class="info-card__label">{{ item.label }}</span>
              <a v-if="item.href" class="info-card__value" :href="item.href">{{ item.value }}</a>
              <strong v-else class="info-card__value">{{ item.value }}</strong>
              <p v-if="item.desc" class="info-card__desc">{{ item.desc }}</p>
            </div>
          </div>
        </div>

        <!-- 线下门店 -->
        <div v-if="stores.length" class="offline">
          <h3 class="offline__title">线下门店</h3>
          <ul class="offline__list">
            <li v-for="store in stores" :key="store.id">
              <strong>{{ store.name }}</strong>
              <span>{{ fullAddress(store) }}</span>
              <a v-if="store.phone" :href="`tel:${store.phone}`">{{ store.phone }}</a>
            </li>
          </ul>
        </div>
      </div>

      <!-- 右侧：表单 -->
      <div class="form-wrap card">
        <!-- 提交成功 -->
        <div v-if="submitted" class="success">
          <span class="success__icon">✅</span>
          <h3 class="success__title">提交成功！</h3>
          <p class="success__desc">
            我们已收到你的咨询，专属顾问将在 1 个工作日内与你联系。<br />
            急需沟通可拨打
            <a :href="`tel:${servicePhone}`">{{ servicePhone }}</a>。
          </p>
          <button class="btn btn-ghost" @click="resetForm">再提交一条</button>
        </div>

        <!-- 表单 -->
        <form v-else class="form" @submit.prevent="handleSubmit">
          <h2 class="form__title">团购 / 企业团单咨询</h2>
          <p class="form__sub">填写以下信息，我们将在 1 个工作日内回复</p>

          <!-- 咨询类型 -->
          <div class="field">
            <label class="field__label">咨询类型 <em>*</em></label>
            <div class="radio-group">
              <label
                v-for="type in msgTypes"
                :key="type.value"
                class="radio"
                :class="{ active: form.msgType === type.value }"
              >
                <input v-model="form.msgType" type="radio" :value="type.value" />
                <span>{{ type.label }}</span>
              </label>
            </div>
          </div>

          <div class="field-row">
            <div class="field">
              <label class="field__label">姓名 <em>*</em></label>
              <input
                v-model.trim="form.name"
                class="field__input"
                type="text"
                placeholder="请输入您的称呼"
                maxlength="20"
              />
              <span v-if="errors.name" class="field__error">{{ errors.name }}</span>
            </div>

            <div class="field">
              <label class="field__label">手机号 <em>*</em></label>
              <input
                v-model.trim="form.phone"
                class="field__input"
                type="tel"
                placeholder="用于联系您的手机号"
                maxlength="11"
              />
              <span v-if="errors.phone" class="field__error">{{ errors.phone }}</span>
            </div>
          </div>

          <div class="field-row">
            <div class="field">
              <label class="field__label">公司 / 单位</label>
              <input
                v-model.trim="form.company"
                class="field__input"
                type="text"
                placeholder="如：某某科技有限公司"
                maxlength="50"
              />
            </div>

            <div class="field">
              <label class="field__label">所在城市</label>
              <input
                v-model.trim="form.city"
                class="field__input"
                type="text"
                placeholder="如：北京市"
                maxlength="20"
              />
            </div>
          </div>

          <div class="field">
            <label class="field__label">需求说明 <em>*</em></label>
            <textarea
              v-model.trim="form.content"
              class="field__textarea"
              rows="5"
              placeholder="请描述您的采购需求，如：预计采购量、期望配送时间、需要的品类（鲜猪肉 / 火锅食材 / 套餐礼盒）等"
              maxlength="500"
            ></textarea>
            <div class="field__counter">
              <span v-if="errors.content" class="field__error">{{ errors.content }}</span>
              <span class="field__count">{{ form.content.length }} / 500</span>
            </div>
          </div>

          <p v-if="errorMessage" class="form__error">{{ errorMessage }}</p>

          <button class="btn btn-primary form__submit" type="submit" :disabled="submitting">
            {{ submitting ? '提交中…' : '提交咨询' }}
          </button>

          <p class="form__privacy">
            提交即表示同意我们使用上述信息与你联系，信息仅用于本次咨询回复。
          </p>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import PageBanner from '@/components/PageBanner.vue'
import { getStores, submitMessage, type MessagePayload, type Store } from '@/api'
import { siteValue } from '@/store/site'

const servicePhone = computed(() => siteValue('site.service_phone', '400-000-0000'))

const stores = ref<Store[]>([])
const submitting = ref(false)
const submitted = ref(false)
const errorMessage = ref('')

/** 咨询类型（对应 msgType） */
const msgTypes = [
  { label: '企业团购', value: 'GROUP' },
  { label: '联系 / 合作', value: 'CONTACT' }
]

const form = reactive<MessagePayload>({
  msgType: 'GROUP',
  name: '',
  phone: '',
  company: '',
  city: '',
  content: ''
})

const errors = reactive<Record<string, string>>({})

const contactItems = computed(() => [
  {
    icon: '📞',
    label: '客服热线',
    value: servicePhone.value,
    href: `tel:${servicePhone.value}`,
    desc: '门店咨询 / 售后处理'
  },
  {
    icon: '🤝',
    label: '企业团购',
    value: siteValue('site.group_phone', '400-000-8888'),
    href: `tel:${siteValue('site.group_phone', '400-000-8888')}`,
    desc: '企业团单 / 节日礼盒定制'
  },
  {
    icon: '✉️',
    label: '商务邮箱',
    value: siteValue('site.email', 'business@zhushidaji.com'),
    href: `mailto:${siteValue('site.email', 'business@zhushidaji.com')}`,
    desc: '渠道合作 / 供应商洽谈'
  },
  {
    icon: '🕘',
    label: '服务时间',
    value: siteValue('site.service_time', '09:00 - 18:00'),
    desc: '门店营业时间以门店公示为准'
  }
])

function fullAddress(store: Store) {
  return [store.province, store.city, store.district, store.address].filter(Boolean).join(' ')
}

/** 表单校验 */
function validate() {
  errors.name = form.name ? '' : '请填写姓名'
  if (!form.phone) {
    errors.phone = '请填写手机号'
  } else if (!/^1[3-9]\d{9}$/.test(form.phone)) {
    errors.phone = '手机号格式不正确'
  } else {
    errors.phone = ''
  }
  errors.content = form.content ? '' : '请填写需求说明'
  return !errors.name && !errors.phone && !errors.content
}

/** 提交表单 */
async function handleSubmit() {
  errorMessage.value = ''
  if (!validate()) return

  submitting.value = true
  try {
    await submitMessage({
      msgType: form.msgType,
      name: form.name,
      phone: form.phone,
      company: form.company,
      city: form.city,
      content: form.content
    })
    submitted.value = true
  } catch (e: any) {
    errorMessage.value = e?.message || '提交失败，请稍后重试'
  } finally {
    submitting.value = false
  }
}

function resetForm() {
  submitted.value = false
  errorMessage.value = ''
  form.name = ''
  form.phone = ''
  form.company = ''
  form.city = ''
  form.content = ''
  errors.name = ''
  errors.phone = ''
  errors.content = ''
}

onMounted(async () => {
  try {
    stores.value = (await getStores()) || []
  } catch (e) {
    stores.value = []
  }
})
</script>

<style scoped>
.contact-body {
  display: grid;
  grid-template-columns: 1fr 1.25fr;
  gap: 40px;
  padding-top: 40px;
}

/* ---------------- 联系信息 ---------------- */
.info-list {
  display: grid;
  gap: 16px;
  margin-top: 26px;
}

.info-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 22px;
  border: 1px solid var(--border-color);
}

.info-card__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border-radius: 12px;
  font-size: 22px;
  background: linear-gradient(150deg, #fff6f6, #fdf3e8);
  border: 1px solid rgba(212, 163, 91, 0.3);
}

.info-card__label {
  display: block;
  font-size: 12.5px;
  color: var(--text-muted);
}

.info-card__value {
  display: block;
  font-size: 17px;
  font-weight: 800;
  color: var(--text-main);
}

a.info-card__value:hover {
  color: var(--brand-red);
}

.info-card__desc {
  font-size: 12px;
  color: var(--text-muted);
}

/* ---------------- 线下门店 ---------------- */
.offline {
  margin-top: 34px;
}

.offline__title {
  margin-bottom: 16px;
  font-size: 17px;
  font-weight: 800;
}

.offline__list li {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 14px 18px;
  margin-bottom: 12px;
  border-radius: var(--radius);
  background: #fff;
  border: 1px solid var(--border-color);
  font-size: 13.5px;
  color: var(--text-sub);
}

.offline__list strong {
  font-size: 15px;
  color: var(--text-main);
}

.offline__list a {
  font-weight: 700;
  color: var(--brand-red);
}

/* ---------------- 表单 ---------------- */
.form-wrap {
  padding: 34px 36px;
  border: 1px solid var(--border-color);
  align-self: start;
}

.form__title {
  font-size: 22px;
  font-weight: 800;
}

.form__sub {
  margin: 8px 0 24px;
  font-size: 13.5px;
  color: var(--text-muted);
}

.field {
  margin-bottom: 18px;
  flex: 1;
}

.field-row {
  display: flex;
  gap: 16px;
}

.field__label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-sub);
}

.field__label em {
  font-style: normal;
  color: var(--brand-red);
}

.field__input,
.field__textarea {
  width: 100%;
  padding: 11px 14px;
  border-radius: 10px;
  border: 1px solid var(--border-color);
  background: var(--bg-page);
  outline: none;
  transition: var(--transition);
}

.field__input:focus,
.field__textarea:focus {
  border-color: var(--brand-red);
  background: #fff;
  box-shadow: 0 0 0 3px rgba(200, 22, 29, 0.08);
}

.field__textarea {
  resize: vertical;
  min-height: 120px;
  line-height: 1.8;
}

.field__error {
  display: block;
  margin-top: 6px;
  font-size: 12.5px;
  color: var(--brand-red);
}

.field__counter {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.field__count {
  margin-top: 6px;
  font-size: 12px;
  color: var(--text-muted);
}

.radio-group {
  display: flex;
  gap: 12px;
}

.radio {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 11px;
  border-radius: 10px;
  border: 1px solid var(--border-color);
  background: var(--bg-page);
  font-size: 14px;
  cursor: pointer;
  transition: var(--transition);
}

.radio input {
  display: none;
}

.radio.active {
  color: var(--brand-red);
  font-weight: 700;
  border-color: var(--brand-red);
  background: rgba(200, 22, 29, 0.06);
}

.form__error {
  margin-bottom: 14px;
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 13.5px;
  color: var(--brand-red);
  background: rgba(200, 22, 29, 0.08);
}

.form__submit {
  width: 100%;
  padding: 14px;
  font-size: 16px;
}

.form__privacy {
  margin-top: 14px;
  font-size: 12px;
  color: var(--text-muted);
  text-align: center;
}

/* ---------------- 成功态 ---------------- */
.success {
  padding: 40px 20px;
  text-align: center;
}

.success__icon {
  font-size: 46px;
}

.success__title {
  margin: 14px 0 10px;
  font-size: 22px;
  font-weight: 800;
  color: var(--brand-red);
}

.success__desc {
  margin-bottom: 24px;
  color: var(--text-sub);
  line-height: 2;
}

.success__desc a {
  color: var(--brand-red);
  font-weight: 700;
}

/* ---------------- 响应式 ---------------- */
@media (max-width: 992px) {
  .contact-body {
    grid-template-columns: 1fr;
    gap: 28px;
  }
}

@media (max-width: 768px) {
  .field-row {
    flex-direction: column;
    gap: 0;
  }

  .form-wrap {
    padding: 24px 18px;
  }
}
</style>
