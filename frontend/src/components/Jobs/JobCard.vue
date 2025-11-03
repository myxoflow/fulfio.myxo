<template>
  <q-card class="job-card">
    <q-card-section>
      <div class="text-h6">{{ job.title }}</div>
      <div class="text-subtitle2 text-positive">${{ job.budget }}</div>
      <div class="text-caption text-grey-7">{{ job.category }}</div>
    </q-card-section>
    <q-card-section>
      <div class="text-body2 line-clamp-3" v-html="job.description"></div>
    </q-card-section>
    <q-card-actions>
      <q-btn flat color="primary" :to="`/jobs/${job.name}`">View Details</q-btn>
      <q-space />
      <q-chip v-if="job.status === 'Open'" color="positive" text-color="white" size="sm">
        {{ job.status }}
      </q-chip>
    </q-card-actions>
  </q-card>
</template>

<script setup lang="ts">
import type { Job } from '../../types'

defineProps<{
  job: Job
}>()
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
