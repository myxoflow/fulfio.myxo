<template>
  <q-page padding>
    <div class="text-h4 q-mb-md">Dashboard</div>
    <p>Welcome, {{ authStore.user?.first_name }}!</p>
  </q-page>
</template>

<script setup>
import { useAuthStore } from '../stores/auth'
const authStore = useAuthStore()
</script>
