<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="form.title"
      label="Job Title"
      :rules="[val => !!val || 'Title is required']"
    />
    
    <q-select
      v-model="form.category"
      :options="categories"
      label="Category"
      :rules="[val => !!val || 'Category is required']"
    />
    
    <q-editor
      v-model="form.description"
      min-height="200px"
      placeholder="Describe your project in detail..."
    />
    
    <q-input
      v-model.number="form.budget"
      label="Budget"
      type="number"
      prefix="$"
      :rules="[val => val > 0 || 'Budget must be greater than 0']"
    />
    
    <div class="row justify-end">
      <q-btn
        type="submit"
        color="primary"
        label="Post Job"
        :loading="loading"
      />
    </div>
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Job } from '../../types'

const emit = defineEmits<{
  submit: [job: Partial<Job>]
}>()

defineProps<{
  loading?: boolean
}>()

const categories = [
  'Web Development',
  'Mobile Development',
  'Design',
  'Data Science',
  'Marketing',
  'Writing',
  'Other'
]

const form = ref<Partial<Job>>({
  title: '',
  description: '',
  budget: 0,
  category: ''
})

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
