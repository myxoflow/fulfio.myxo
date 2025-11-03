<template>
  <div class="q-gutter-md">
    <div v-if="bids.length === 0" class="text-center q-pa-md">
      <div class="text-grey-6">No bids yet</div>
    </div>
    
    <BidCard
      v-for="bid in bids"
      :key="bid.name"
      :bid="bid"
      :show-actions="showActions"
      @accept="$emit('accept', $event)"
      @reject="$emit('reject', $event)"
    />
  </div>
</template>

<script setup lang="ts">
import BidCard from './BidCard.vue'
import type { Bid } from '../../types'

defineProps<{
  bids: Bid[]
  showActions?: boolean
}>()

defineEmits<{
  accept: [bidId: string]
  reject: [bidId: string]
}>()
</script>
