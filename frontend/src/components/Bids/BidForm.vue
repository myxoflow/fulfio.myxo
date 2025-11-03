<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model.number="form.proposed_price"
      label="Your Bid Amount"
      type="number"
      prefix="$"
      :rules="[val => val > 0 || 'Amount must be greater than 0']"
    />
    
    <q-input
      v-model.number="form.delivery_time"
      label="Delivery Time (days)"
      type="number"
    />
    
    <q-input
      v-model="form.message"
      label="Cover Letter"
      type="textarea"
      rows="5"
      placeholder="Explain why you're the best fit for this job..."
    />
    
    <div class="row justify-end">
      <q-btn
        type="submit"
        color="primary"
        label="Submit Bid"
        :loading="loading"
      />
    </div>
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Bid } from '../../types'

const emit = defineEmits<{
  submit: [bid: Partial<Bid>]
}>()

defineProps<{
  loading?: boolean
}>()

const form = ref<Partial<Bid>>({
  proposed_price: 0,
  message: '',
  delivery_time: 7
})

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
