<template>
  <q-card>
    <q-card-section>
      <div class="row items-center">
        <div class="col">
          <div class="text-subtitle1">{{ bid.freelancer }}</div>
          <div class="text-h6 text-positive">${{ bid.proposed_price }}</div>
        </div>
        <q-chip :color="statusColor" text-color="white">
          {{ bid.status }}
        </q-chip>
      </div>
    </q-card-section>
    
    <q-card-section v-if="bid.message">
      <div v-html="bid.message"></div>
    </q-card-section>
    
    <q-card-actions v-if="showActions">
      <q-btn
        flat
        color="positive"
        label="Accept"
        @click="$emit('accept', bid.name)"
      />
      <q-btn
        flat
        color="negative"
        label="Reject"
        @click="$emit('reject', bid.name)"
      />
    </q-card-actions>
  </q-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { Bid } from '../../types'

const props = defineProps<{
  bid: Bid
  showActions?: boolean
}>()

defineEmits<{
  accept: [bidId: string]
  reject: [bidId: string]
}>()

const statusColor = computed(() => {
  switch (props.bid.status) {
    case 'Accepted': return 'positive'
    case 'Rejected': return 'negative'
    default: return 'orange'
  }
})
</script>
