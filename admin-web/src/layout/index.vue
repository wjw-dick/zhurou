<template>
  <el-container class="app-layout">
    <el-aside :width="collapsed ? '64px' : '220px'" class="app-aside">
      <div class="logo">
        <span class="logo-icon">🐷</span>
        <span v-show="!collapsed" class="logo-text">猪事大吉</span>
      </div>
      <el-scrollbar>
        <el-menu
          :default-active="activeMenu"
          :collapse="collapsed"
          :collapse-transition="false"
          background-color="#1f2d3d"
          text-color="#c0c4cc"
          active-text-color="#ffd04b"
          router
          unique-opened
        >
          <SidebarItem v-for="item in menuRoutes" :key="item.path" :item="item" />
        </el-menu>
      </el-scrollbar>
    </el-aside>

    <el-container>
      <el-header class="app-header">
        <div class="header-left">
          <el-icon class="collapse-btn" @click="collapsed = !collapsed">
            <Fold v-if="!collapsed" />
            <Expand v-else />
          </el-icon>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item v-for="(bc, i) in breadcrumbs" :key="i">{{ bc }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-tag v-if="userStore.isSuperAdmin" type="danger" effect="dark" size="small">超级管理员</el-tag>
          <el-dropdown @command="onCommand">
            <span class="user-info">
              <el-avatar :size="30" :src="userStore.userInfo?.avatar">
                {{ (userStore.userInfo?.nickname || 'U').slice(0, 1) }}
              </el-avatar>
              <span class="username">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人信息</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="app-main">
        <router-view v-slot="{ Component, route }">
          <keep-alive>
            <component :is="Component" :key="route.path" />
          </keep-alive>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import SidebarItem from './components/SidebarItem.vue'
import { useUserStore } from '@/store/user'
import { usePermissionStore } from '@/store/permission'

const collapsed = ref(false)
const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const permissionStore = usePermissionStore()

const menuRoutes = computed(() => permissionStore.routes[0]?.children || [])
const activeMenu = computed(() => route.path)

const breadcrumbs = computed(() => {
  const matched = route.matched.filter((m) => m.meta?.title)
  return matched.map((m) => m.meta.title as string)
})

function onCommand(command: string) {
  if (command === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', { type: 'warning' }).then(async () => {
      await userStore.logout()
      permissionStore.reset()
      router.push('/login')
    })
  } else if (command === 'profile') {
    router.push('/dashboard')
  }
}
</script>

<style scoped>
.app-layout {
  height: 100vh;
}

.app-aside {
  background: #1f2d3d;
  transition: width 0.2s;
  overflow: hidden;
}

.logo {
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #fff;
  font-weight: 600;
  font-size: 16px;
  border-bottom: 1px solid #2b3a4d;
}

.logo-icon {
  font-size: 20px;
}

.app-aside :deep(.el-menu) {
  border-right: none;
}

.app-header {
  height: 56px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #ebeef5;
  padding: 0 16px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  outline: none;
}

.username {
  font-size: 14px;
}

.app-main {
  background: #f5f7fa;
  padding: 0;
}
</style>
