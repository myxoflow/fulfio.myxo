<template>
  <div>
    <div v-if="loading" class="flex flex-center q-pa-xl">
      <q-spinner size="50px" color="primary" />
    </div>
    
    <div v-else-if="jobs.length === 0" class="text-center q-pa-xl">
      <q-icon name="work_off" size="64px" color="grey-5" />
      <div class="text-h6 text-grey-6 q-mt-md">No jobs found</div>
    </div>
    
    <div v-else class="row q-col-gutter-md">
      <div v-for="job in jobs" :key="job.name" class="col-12 col-sm-6 col-md-4">
        <JobCard :job="job" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import JobCard from './JobCard.vue'
import type { Job } from '../../types'

defineProps<{
  jobs: Job[]
  loading?: boolean
}>()
</script>
