<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="form.first_name"
      label="First Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.last_name"
      label="Last Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.email"
      label="Email"
      type="email"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.password"
      label="Password"
      type="password"
      :rules="[val => !!val || 'Required', val => val.length >= 6 || 'Min 6 characters']"
    />
    
    <q-select
      v-model="form.user_type"
      :options="['Freelancer', 'Client']"
      label="I am a"
    />
    
    <q-btn
      type="submit"
      color="primary"
      label="Register"
      class="full-width"
      :loading="loading"
    />
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  submit: [data: {
    email: string
    password: string
    first_name: string
    last_name: string
    user_type: 'Freelancer' | 'Client'
  }]
}>()

defineProps<{
  loading?: boolean
}>()

const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  password: '',
  user_type: 'Freelancer' as 'Freelancer' | 'Client'
})

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
