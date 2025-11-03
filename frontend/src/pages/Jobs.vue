<template>
  <q-page padding>
    <div class="text-h4 q-mb-md">Browse Jobs</div>
    <div v-if="jobsStore.loading" class="flex flex-center q-mt-xl">
      <q-spinner size="50px" color="primary" />
    </div>
    <div v-else class="row q-col-gutter-md">
      <div v-for="job in jobsStore.jobs" :key="job.name" class="col-12 col-md-6">
        <q-card>
          <q-card-section>
            <div class="text-h6">{{ job.title }}</div>
            <div class="text-subtitle2">${{ job.budget }}</div>
          </q-card-section>
          <q-card-actions>
            <q-btn flat color="primary" :to="`/jobs/${job.name}`">View Details</q-btn>
          </q-card-actions>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { onMounted } from 'vue'
import { useJobsStore } from '../stores/jobs'

const jobsStore = useJobsStore()

onMounted(() => {
  jobsStore.fetchJobs()
})
</script>
