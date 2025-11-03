import { defineStore } from 'pinia'
import { authAPI } from '../api/auth'
import type { User } from '../types'

interface AuthState {
  user: User | null
  isAuthenticated: boolean
  loading: boolean
  error: string | null
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    user: null,
    isAuthenticated: false,
    loading: false,
    error: null
  }),

  getters: {
    currentUser: (state) => state.user,
    isLoggedIn: (state) => state.isAuthenticated
  },

  actions: {
    async login(email: string, password: string): Promise<boolean> {
      this.loading = true
      this.error = null
      try {
        const response = await authAPI.login(email, password)
        this.user = response.data.message.user
        this.isAuthenticated = true
        localStorage.setItem('auth_token', response.data.message.sid)
        return true
      } catch (error: any) {
        this.error = error.response?.data?.message || 'Login failed'
        return false
      } finally {
        this.loading = false
      }
    },

    async register(userData: {
      email: string
      password: string
      first_name: string
      last_name: string
      user_type: 'Freelancer' | 'Client'
    }): Promise<boolean> {
      this.loading = true
      this.error = null
      try {
        await authAPI.register(userData)
        await this.login(userData.email, userData.password)
        return true
      } catch (error: any) {
        this.error = error.response?.data?.message || 'Registration failed'
        return false
      } finally {
        this.loading = false
      }
    },

    async logout(): Promise<void> {
      try {
        await authAPI.logout()
      } catch (error) {
        console.error('Logout error:', error)
      } finally {
        this.user = null
        this.isAuthenticated = false
        localStorage.removeItem('auth_token')
      }
    },

    async checkAuth(): Promise<void> {
      try {
        const response = await authAPI.checkAuth()
        if (response.data.message) {
          this.user = response.data.message
          this.isAuthenticated = true
        }
      } catch (error) {
        this.logout()
      }
    }
  }
})