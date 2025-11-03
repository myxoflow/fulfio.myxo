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
      v-model="form.bio"
      label="Bio"
      type="textarea"
      rows="4"
    />
    
    <q-input
      v-model.number="form.hourly_rate"
      label="Hourly Rate"
      type="number"
      prefix="$"
    />
    
    <q-select
      v-model="form.skills"
      :options="skillOptions"
      label="Skills"
      multiple
      use-chips
    />
    
    <div class="row justify-end">
      <q-btn
        type="submit"
        color="primary"
        label="Save Changes"
        :loading="loading"
      />
    </div>
  </q-form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import type { User } from '../../types'

const props = defineProps<{
  user: User
  loading?: boolean
}>()

const emit = defineEmits<{
  submit: [data: Partial<User>]
}>()

const skillOptions = [
  'JavaScript', 'Python', 'Vue.js', 'React', 'Node.js',
  'Design', 'UI/UX', 'Marketing', 'Writing', 'Data Science'
]

const form = ref<Partial<User>>({ ...props.user })

watch(() => props.user, (newUser) => {
  form.value = { ...newUser }
}, { deep: true })

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
