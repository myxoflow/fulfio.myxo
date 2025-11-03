<template>
  <q-page padding>
    <div class="text-h4 q-mb-md">Post a Job</div>
    <q-form @submit="onSubmit" style="max-width: 600px">
      <q-input v-model="form.title" label="Job Title" :rules="[val => !!val || 'Required']" />
      <q-input v-model="form.description" label="Description" type="textarea" rows="5" />
      <q-input v-model.number="form.budget" label="Budget" type="number" prefix="$" />
      <q-btn type="submit" color="primary" label="Post Job" :loading="jobsStore.loading" />
    </q-form>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useJobsStore } from '../stores/jobs'
import { useQuasar } from 'quasar'

const form = ref({ title: '', description: '', budget: 0 })
const jobsStore = useJobsStore()
const router = useRouter()
const $q = useQuasar()

const onSubmit = async () => {
  try {
    await jobsStore.createJob(form.value)
    $q.notify({ type: 'positive', message: 'Job posted successfully' })
    router.push('/jobs')
  } catch (error) {
    $q.notify({ type: 'negative', message: 'Failed to post job' })
  }
}
</script>
