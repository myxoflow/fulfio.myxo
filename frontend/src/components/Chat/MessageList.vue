<template>
  <q-scroll-area style="height: 400px">
    <q-chat-message
      v-for="message in messages"
      :key="message.name"
      :text="[message.content]"
      :stamp="formatDate(message.created_on)"
      :sent="message.sender === currentUser"
      :bg-color="message.sender === currentUser ? 'primary' : 'grey-3'"
    />
  </q-scroll-area>
</template>

<script setup lang="ts">
import type { Message } from '../../types'

defineProps<{
  messages: Message[]
  currentUser: string
}>()

const formatDate = (date: string) => {
  return new Date(date).toLocaleTimeString()
}
</script>
