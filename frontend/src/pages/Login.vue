<template>
  <q-page class="flex flex-center">
    <q-card style="width: 400px; max-width: 90vw">
      <q-card-section>
        <div class="text-h6">Login</div>
      </q-card-section>
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-input v-model="email" label="Email" type="email" :rules="[val => !!val || 'Email is required']" />
          <q-input v-model="password" label="Password" type="password" :rules="[val => !!val || 'Password is required']" />
          <q-btn type="submit" color="primary" label="Login" class="full-width q-mt-md" :loading="authStore.loading" />
        </q-form>
      </q-card-section>
      <q-card-section>
        <div class="text-center">
          Don't have an account? <router-link to="/register">Register</router-link>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useQuasar } from 'quasar'

const email = ref('')
const password = ref('')
const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()
const $q = useQuasar()

const onSubmit = async () => {
  const success = await authStore.login(email.value, password.value)
  if (success) {
    $q.notify({ type: 'positive', message: 'Login successful' })
    router.push(route.query.redirect || '/dashboard')
  } else {
    $q.notify({ type: 'negative', message: authStore.error })
  }
}
</script>
