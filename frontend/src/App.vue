<template>
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from './stores/auth'

const authStore = useAuthStore()

onMounted(() => {
  const token = localStorage.getItem('auth_token')
  if (token) {
    authStore.checkAuth()
  }
})
</script>
