<template>
  <q-page class="flex flex-center">
    <q-card style="width: 400px; max-width: 90vw">
      <q-card-section>
        <div class="text-h6">Register</div>
      </q-card-section>
      <q-card-section>
        <q-form @submit="onSubmit">
          <q-input v-model="form.first_name" label="First Name" :rules="[val => !!val || 'Required']" />
          <q-input v-model="form.last_name" label="Last Name" :rules="[val => !!val || 'Required']" />
          <q-input v-model="form.email" label="Email" type="email" :rules="[val => !!val || 'Required']" />
          <q-input v-model="form.password" label="Password" type="password" :rules="[val => !!val || 'Required']" />
          <q-select v-model="form.user_type" :options="['Freelancer', 'Client']" label="I am a" />
          <q-btn type="submit" color="primary" label="Register" class="full-width q-mt-md" :loading="authStore.loading" />
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useQuasar } from 'quasar'

const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  password: '',
  user_type: 'Freelancer'
})
const authStore = useAuthStore()
const router = useRouter()
const $q = useQuasar()

const onSubmit = async () => {
  const success = await authStore.register(form.value)
  if (success) {
    $q.notify({ type: 'positive', message: 'Registration successful' })
    router.push('/dashboard')
  } else {
    $q.notify({ type: 'negative', message: authStore.error })
  }
}
</script>
