import { defineStore } from 'pinia'
import type { Notification } from '../types'

interface NotificationsState {
  notifications: Notification[]
  unreadCount: number
}

export const useNotificationsStore = defineStore('notifications', {
  state: (): NotificationsState => ({
    notifications: [],
    unreadCount: 0
  }),

  actions: {
    addNotification(notification: Notification): void {
      this.notifications.unshift(notification)
      if (!notification.read) {
        this.unreadCount++
      }
    },

    markAsRead(id: string): void {
      const notification = this.notifications.find(n => n.id === id)
      if (notification && !notification.read) {
        notification.read = true
        this.unreadCount--
      }
    },

    markAllAsRead(): void {
      this.notifications.forEach(n => n.read = true)
      this.unreadCount = 0
    }
  }
})
