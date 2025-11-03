<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn flat dense round icon="menu" @click="drawer = !drawer" />
        <q-toolbar-title>Freelancer Marketplace</q-toolbar-title>
        <q-btn v-if="!authStore.isAuthenticated" flat label="Login" to="/login" />
        <q-btn v-if="!authStore.isAuthenticated" flat label="Register" to="/register" />
        <q-btn v-if="authStore.isAuthenticated" flat label="Dashboard" to="/dashboard" />
        <q-btn v-if="authStore.isAuthenticated" flat label="Logout" @click="logout" />
      </q-toolbar>
    </q-header>

    <q-drawer v-model="drawer" show-if-above bordered>
      <q-list>
        <q-item clickable v-ripple to="/">
          <q-item-section avatar><q-icon name="home" /></q-item-section>
          <q-item-section>Home</q-item-section>
        </q-item>
        <q-item clickable v-ripple to="/jobs">
          <q-item-section avatar><q-icon name="work" /></q-item-section>
          <q-item-section>Browse Jobs</q-item-section>
        </q-item>
        <q-item v-if="authStore.isAuthenticated" clickable v-ripple to="/post-job">
          <q-item-section avatar><q-icon name="add" /></q-item-section>
          <q-item-section>Post Job</q-item-section>
        </q-item>
        <q-item v-if="authStore.isAuthenticated" clickable v-ripple to="/projects">
          <q-item-section avatar><q-icon name="assignment" /></q-item-section>
          <q-item-section>My Projects</q-item-section>
        </q-item>
        <q-item v-if="authStore.isAuthenticated" clickable v-ripple to="/messages">
          <q-item-section avatar><q-icon name="message" /></q-item-section>
          <q-item-section>Messages</q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const drawer = ref(false)
const authStore = useAuthStore()
const router = useRouter()

const logout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script>
