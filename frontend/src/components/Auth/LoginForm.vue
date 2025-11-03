<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="email"
      label="Email"
      type="email"
      :rules="[val => !!val || 'Email is required']"
    />
    
    <q-input
      v-model="password"
      label="Password"
      type="password"
      :rules="[val => !!val || 'Password is required']"
    />
    
    <q-btn
      type="submit"
      color="primary"
      label="Login"
      class="full-width"
      :loading="loading"
    />
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  submit: [credentials: { email: string; password: string }]
}>()

defineProps<{
  loading?: boolean
}>()

const email = ref('')
const password = ref('')

const onSubmit = () => {
  emit('submit', { email: email.value, password: password.value })
}
</script>
