<template>
  <q-card>
    <q-card-section class="text-center">
      <q-avatar size="100px">
        <img :src="user.profile_image || '/avatar-placeholder.png'" />
      </q-avatar>
      <div class="text-h5 q-mt-md">{{ user.first_name }} {{ user.last_name }}</div>
      <div class="text-subtitle2 text-grey-7">{{ user.user_type }}</div>
      
      <div v-if="user.rating" class="q-mt-sm">
        <q-rating
          :model-value="user.rating"
          readonly
          color="orange"
          size="sm"
        />
      </div>
    </q-card-section>
    
    <q-card-section v-if="user.bio">
      <div class="text-body2">{{ user.bio }}</div>
    </q-card-section>
    
    <q-card-section v-if="user.skills && user.skills.length > 0">
      <div class="q-gutter-sm">
        <q-chip
          v-for="skill in user.skills"
          :key="skill"
          color="primary"
          text-color="white"
          size="sm"
        >
          {{ skill }}
        </q-chip>
      </div>
    </q-card-section>
    
    <q-card-section v-if="user.hourly_rate">
      <div class="text-h6 text-positive">${{ user.hourly_rate }}/hr</div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import type { User } from '../../types'

defineProps<{
  user: User
}>()
</script>
