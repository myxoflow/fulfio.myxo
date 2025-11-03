import { defineStore } from 'pinia'
import { usersAPI } from '../api/users'
import type { User } from '../types'

interface UserState {
  profile: User | null
  loading: boolean
  error: string | null
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    profile: null,
    loading: false,
    error: null
  }),

  actions: {
    async fetchProfile(userId: string): Promise<void> {
      this.loading = true
      try {
        const response = await usersAPI.getProfile(userId)
        this.profile = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch profile'
      } finally {
        this.loading = false
      }
    },

    async updateProfile(data: Partial<User>): Promise<void> {
      this.loading = true
      try {
        await usersAPI.updateProfile(data)
        if (this.profile) {
          Object.assign(this.profile, data)
        }
      } catch (error: any) {
        this.error = 'Failed to update profile'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
