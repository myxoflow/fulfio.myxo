<template>
  <q-page padding>
    <div v-if="jobsStore.loading">Loading...</div>
    <div v-else-if="jobsStore.currentJob">
      <div class="text-h4">{{ jobsStore.currentJob.title }}</div>
      <div class="text-h6">${{ jobsStore.currentJob.budget }}</div>
      <div class="q-mt-md" v-html="jobsStore.currentJob.description"></div>
    </div>
  </q-page>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useJobsStore } from '../stores/jobs'

const route = useRoute()
const jobsStore = useJobsStore()

onMounted(() => {
  jobsStore.fetchJob(route.params.id)
})
</script>
