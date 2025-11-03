<template>
  <q-form @submit="onSubmit" class="row q-gutter-sm">
    <q-input
      v-model="message"
      placeholder="Type a message..."
      outlined
      class="col"
      @keyup.enter="onSubmit"
    />
    <q-btn
      type="submit"
      color="primary"
      icon="send"
      round
      :disable="!message.trim()"
    />
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  send: [message: string]
}>()

const message = ref('')

const onSubmit = () => {
  if (message.value.trim()) {
    emit('send', message.value)
    message.value = ''
  }
}
</script>
