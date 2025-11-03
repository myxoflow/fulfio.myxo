#!/bin/bash

# Freelancer Marketplace - Complete TypeScript Files Generator
# Run this inside your freelancer-marketplace folder
# Usage: bash add_typescript_and_remaining_files.sh

echo "🔧 Adding TypeScript support and remaining files..."

cd frontend

# ============================================
# UPDATE PACKAGE.JSON FOR TYPESCRIPT
# ============================================

echo "📦 Updating package.json for TypeScript..."

cat > package.json << 'EOF'
{
  "name": "freelancer-marketplace-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "quasar dev",
    "build": "quasar build",
    "lint": "eslint --ext .js,.ts,.vue src"
  },
  "dependencies": {
    "@quasar/extras": "^2.14.0",
    "axios": "^1.6.0",
    "pinia": "^2.1.0",
    "quasar": "^2.14.0",
    "vue": "^3.3.0",
    "vue-router": "^4.2.0"
  },
  "devDependencies": {
    "@quasar/app-webpack": "^3.9.0",
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-plugin-vue": "^9.0.0",
    "typescript": "^5.2.0"
  }
}
EOF

# ============================================
# CREATE TYPESCRIPT CONFIG
# ============================================

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "node",
    "strict": true,
    "jsx": "preserve",
    "sourceMap": true,
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "lib": ["ESNext", "DOM"],
    "types": ["node"],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"],
  "exclude": ["node_modules"]
}
EOF

# ============================================
# UPDATE QUASAR CONFIG FOR TYPESCRIPT
# ============================================

cat > quasar.conf.js << 'EOF'
module.exports = function (ctx) {
  return {
    supportTS: {
      tsCheckerConfig: {
        eslint: {
          enabled: true,
          files: './src/**/*.{ts,tsx,js,jsx,vue}'
        }
      }
    },
    boot: [],
    css: ['app.scss'],
    extras: ['roboto-font', 'material-icons'],
    build: {
      vueRouterMode: 'history',
      extendWebpack(cfg) {
        cfg.resolve.extensions.push('.ts', '.tsx')
      },
      env: {
        API_URL: process.env.VUE_APP_API_URL,
        STORJ_GATEWAY: process.env.VUE_APP_STORJ_GATEWAY
      }
    },
    devServer: {
      server: { type: 'http' },
      port: 8080,
      open: true
    },
    framework: {
      config: {},
      plugins: ['Notify', 'Dialog', 'Loading']
    }
  }
}
EOF

# ============================================
# CREATE TYPE DEFINITIONS
# ============================================

mkdir -p src/types

cat > src/types/index.ts << 'EOF'
export interface User {
  name: string
  email: string
  first_name: string
  last_name: string
  user_type: 'Freelancer' | 'Client'
  bio?: string
  skills?: string[]
  hourly_rate?: number
  rating?: number
  profile_image?: string
}

export interface Job {
  name: string
  title: string
  description: string
  budget: number
  category: string
  status: 'Open' | 'In Progress' | 'Closed'
  posted_by: string
  created_on: string
  skills_required?: string[]
}

export interface Bid {
  name: string
  job_posting: string
  freelancer: string
  proposed_price: number
  message: string
  status: 'Pending' | 'Accepted' | 'Rejected'
  delivery_time?: number
}

export interface Project {
  name: string
  title: string
  job_posting: string
  client: string
  freelancer: string
  amount: number
  status: 'Active' | 'Completed' | 'Cancelled'
  start_date?: string
  end_date?: string
  payment_status?: 'Pending' | 'Paid' | 'Released'
}

export interface Message {
  name: string
  sender: string
  receiver: string
  content: string
  created_on: string
  read: boolean
}

export interface Review {
  name: string
  from_user: string
  to_user: string
  project: string
  rating: number
  comment: string
  created_on: string
}

export interface Portfolio {
  name: string
  freelancer: string
  title: string
  description: string
  file_url: string
  thumbnail?: string
  project_link?: string
  created_on: string
}

export interface Notification {
  id: string
  type: 'bid' | 'message' | 'project' | 'payment' | 'review'
  title: string
  message: string
  read: boolean
  created_on: string
  link?: string
}
EOF

# ============================================
# UPDATE API FILES TO TYPESCRIPT
# ============================================

cat > src/api/auth.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { User } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: { 'Content-Type': 'application/json' }
})

interface LoginResponse {
  status: string
  user: User
  sid: string
}

interface RegisterData {
  email: string
  password: string
  first_name: string
  last_name: string
  user_type: 'Freelancer' | 'Client'
}

export const authAPI = {
  login: (email: string, password: string): Promise<AxiosResponse<{ message: LoginResponse }>> =>
    client.post('/method/freelancer_marketplace.api.login', { email, password }),
  
  register: (data: RegisterData): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.register', data),
  
  logout: (): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.logout'),
  
  checkAuth: (): Promise<AxiosResponse<{ message: User }>> =>
    client.get('/method/frappe.auth.get_logged_user'),
  
  resetPassword: (email: string): Promise<AxiosResponse> =>
    client.post('/method/frappe.core.doctype.user.user.reset_password', { user: email })
}
EOF

cat > src/api/jobs.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Job } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface JobsResponse {
  data: Job[]
}

interface JobResponse {
  data: Job
}

export const jobsAPI = {
  getJobs: (filters: Record<string, any> = {}): Promise<AxiosResponse<JobsResponse>> =>
    client.get('/resource/JobPosting', { params: { filters: JSON.stringify(filters), limit_page_length: 20 } }),
  
  getJob: (id: string): Promise<AxiosResponse<JobResponse>> =>
    client.get(`/resource/JobPosting/${id}`),
  
  createJob: (data: Partial<Job>): Promise<AxiosResponse<JobResponse>> =>
    client.post('/resource/JobPosting', data),
  
  updateJob: (id: string, data: Partial<Job>): Promise<AxiosResponse<JobResponse>> =>
    client.put(`/resource/JobPosting/${id}`, data),
  
  deleteJob: (id: string): Promise<AxiosResponse> =>
    client.delete(`/resource/JobPosting/${id}`),
  
  searchJobs: (query: string): Promise<AxiosResponse<JobsResponse>> =>
    client.post('/method/freelancer_marketplace.api.search_jobs', { query })
}
EOF

cat > src/api/bids.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Bid } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface BidsResponse {
  data: Bid[]
}

export const bidsAPI = {
  getBids: (jobId: string): Promise<AxiosResponse<BidsResponse>> =>
    client.get('/resource/Bid', { params: { filters: JSON.stringify({ job_posting: jobId }) } }),
  
  getMyBids: (): Promise<AxiosResponse<BidsResponse>> =>
    client.get('/method/freelancer_marketplace.api.get_user_bids'),
  
  createBid: (data: Partial<Bid>): Promise<AxiosResponse> =>
    client.post('/resource/Bid', data),
  
  acceptBid: (bidId: string): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.accept_bid', { bid_id: bidId }),
  
  rejectBid: (bidId: string): Promise<AxiosResponse> =>
    client.put(`/resource/Bid/${bidId}`, { status: 'Rejected' })
}
EOF

cat > src/api/projects.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Project } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface ProjectsResponse {
  data: Project[]
}

export const projectsAPI = {
  getMyProjects: (): Promise<AxiosResponse<ProjectsResponse>> =>
    client.get('/method/freelancer_marketplace.api.get_user_projects'),
  
  getProject: (id: string): Promise<AxiosResponse<{ data: Project }>> =>
    client.get(`/resource/Project/${id}`),
  
  updateProject: (id: string, data: Partial<Project>): Promise<AxiosResponse> =>
    client.put(`/resource/Project/${id}`, data),
  
  completeProject: (id: string): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.complete_project', { project_id: id })
}
EOF

cat > src/api/messages.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Message } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface MessagesResponse {
  data: Message[]
}

export const messagesAPI = {
  getMessages: (userId: string): Promise<AxiosResponse<MessagesResponse>> =>
    client.get('/method/freelancer_marketplace.api.get_messages', { params: { user_id: userId } }),
  
  sendMessage: (receiver: string, content: string): Promise<AxiosResponse> =>
    client.post('/resource/Message', { receiver, content }),
  
  markAsRead: (messageId: string): Promise<AxiosResponse> =>
    client.put(`/resource/Message/${messageId}`, { read: 1 })
}
EOF

cat > src/api/reviews.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Review } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface ReviewsResponse {
  data: Review[]
}

export const reviewsAPI = {
  getUserReviews: (userId: string): Promise<AxiosResponse<ReviewsResponse>> =>
    client.get('/resource/Review', { params: { filters: JSON.stringify({ to_user: userId }) } }),
  
  createReview: (data: Partial<Review>): Promise<AxiosResponse> =>
    client.post('/resource/Review', data)
}
EOF

cat > src/api/portfolio.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { Portfolio } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface PortfolioResponse {
  data: Portfolio[]
}

export const portfolioAPI = {
  getPortfolio: (userId: string): Promise<AxiosResponse<PortfolioResponse>> =>
    client.get('/resource/Portfolio', { params: { filters: JSON.stringify({ freelancer: userId }) } }),
  
  createPortfolio: (data: Partial<Portfolio>): Promise<AxiosResponse> =>
    client.post('/resource/Portfolio', data),
  
  deletePortfolio: (id: string): Promise<AxiosResponse> =>
    client.delete(`/resource/Portfolio/${id}`)
}
EOF

cat > src/api/users.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'
import type { User } from '../types'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

export const usersAPI = {
  getProfile: (userId: string): Promise<AxiosResponse<{ data: User }>> =>
    client.get(`/resource/User/${userId}`),
  
  updateProfile: (data: Partial<User>): Promise<AxiosResponse> =>
    client.put(`/resource/User/${data.name}`, data),
  
  searchFreelancers: (query: string): Promise<AxiosResponse<{ data: User[] }>> =>
    client.post('/method/freelancer_marketplace.api.search_freelancers', { query })
}
EOF

cat > src/api/payments.ts << 'EOF'
import axios, { AxiosResponse } from 'axios'

const API_URL = process.env.VUE_APP_API_URL

const client = axios.create({
  baseURL: API_URL,
  withCredentials: true
})

interface PaymentSession {
  url: string
  session_id: string
}

export const paymentsAPI = {
  createPaymentSession: (projectId: string): Promise<AxiosResponse<{ data: PaymentSession }>> =>
    client.post('/method/freelancer_marketplace.api.create_payment_session', { project_id: projectId }),
  
  verifyPayment: (projectId: string, paymentId: string): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.verify_payment', { project_id: projectId, payment_id: paymentId }),
  
  releasePayment: (projectId: string): Promise<AxiosResponse> =>
    client.post('/method/freelancer_marketplace.api.release_payment', { project_id: projectId })
}
EOF

# ============================================
# UPDATE STORES TO TYPESCRIPT
# ============================================

cat > src/stores/auth.ts << 'EOF'
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
EOF

cat > src/stores/jobs.ts << 'EOF'
import { defineStore } from 'pinia'
import { jobsAPI } from '../api/jobs'
import type { Job } from '../types'

interface JobsState {
  jobs: Job[]
  currentJob: Job | null
  loading: boolean
  error: string | null
}

export const useJobsStore = defineStore('jobs', {
  state: (): JobsState => ({
    jobs: [],
    currentJob: null,
    loading: false,
    error: null
  }),

  actions: {
    async fetchJobs(filters: Record<string, any> = {}): Promise<void> {
      this.loading = true
      this.error = null
      try {
        const response = await jobsAPI.getJobs(filters)
        this.jobs = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch jobs'
      } finally {
        this.loading = false
      }
    },

    async fetchJob(id: string): Promise<void> {
      this.loading = true
      try {
        const response = await jobsAPI.getJob(id)
        this.currentJob = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch job'
      } finally {
        this.loading = false
      }
    },

    async createJob(jobData: Partial<Job>): Promise<Job | null> {
      this.loading = true
      try {
        const response = await jobsAPI.createJob(jobData)
        this.jobs.unshift(response.data.data)
        return response.data.data
      } catch (error: any) {
        this.error = 'Failed to create job'
        throw error
      } finally {
        this.loading = false
      }
    },

    async searchJobs(query: string): Promise<void> {
      this.loading = true
      try {
        const response = await jobsAPI.searchJobs(query)
        this.jobs = response.data.data
      } catch (error: any) {
        this.error = 'Search failed'
      } finally {
        this.loading = false
      }
    }
  }
})
EOF

cat > src/stores/bids.ts << 'EOF'
import { defineStore } from 'pinia'
import { bidsAPI } from '../api/bids'
import type { Bid } from '../types'

interface BidsState {
  bids: Bid[]
  myBids: Bid[]
  loading: boolean
  error: string | null
}

export const useBidsStore = defineStore('bids', {
  state: (): BidsState => ({
    bids: [],
    myBids: [],
    loading: false,
    error: null
  }),

  actions: {
    async fetchBids(jobId: string): Promise<void> {
      this.loading = true
      try {
        const response = await bidsAPI.getBids(jobId)
        this.bids = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch bids'
      } finally {
        this.loading = false
      }
    },

    async fetchMyBids(): Promise<void> {
      this.loading = true
      try {
        const response = await bidsAPI.getMyBids()
        this.myBids = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch bids'
      } finally {
        this.loading = false
      }
    },

    async createBid(bidData: Partial<Bid>): Promise<void> {
      this.loading = true
      try {
        await bidsAPI.createBid(bidData)
        if (bidData.job_posting) {
          await this.fetchBids(bidData.job_posting)
        }
      } catch (error: any) {
        this.error = 'Failed to create bid'
        throw error
      } finally {
        this.loading = false
      }
    },

    async acceptBid(bidId: string): Promise<void> {
      this.loading = true
      try {
        await bidsAPI.acceptBid(bidId)
      } catch (error: any) {
        this.error = 'Failed to accept bid'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
EOF

cat > src/stores/projects.ts << 'EOF'
import { defineStore } from 'pinia'
import { projectsAPI } from '../api/projects'
import type { Project } from '../types'

interface ProjectsState {
  projects: Project[]
  currentProject: Project | null
  loading: boolean
  error: string | null
}

export const useProjectsStore = defineStore('projects', {
  state: (): ProjectsState => ({
    projects: [],
    currentProject: null,
    loading: false,
    error: null
  }),

  actions: {
    async fetchMyProjects(): Promise<void> {
      this.loading = true
      try {
        const response = await projectsAPI.getMyProjects()
        this.projects = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch projects'
      } finally {
        this.loading = false
      }
    },

    async fetchProject(id: string): Promise<void> {
      this.loading = true
      try {
        const response = await projectsAPI.getProject(id)
        this.currentProject = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch project'
      } finally {
        this.loading = false
      }
    }
  }
})
EOF

cat > src/stores/notifications.ts << 'EOF'
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
EOF

cat > src/stores/user.ts << 'EOF'
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
EOF

# ============================================
# ADD COMPONENT FILES
# ============================================

echo "📝 Creating component files..."

# Job Components
cat > src/components/Jobs/JobCard.vue << 'EOF'
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
EOF

cat > src/components/Jobs/JobForm.vue << 'EOF'
<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="form.title"
      label="Job Title"
      :rules="[val => !!val || 'Title is required']"
    />
    
    <q-select
      v-model="form.category"
      :options="categories"
      label="Category"
      :rules="[val => !!val || 'Category is required']"
    />
    
    <q-editor
      v-model="form.description"
      min-height="200px"
      placeholder="Describe your project in detail..."
    />
    
    <q-input
      v-model.number="form.budget"
      label="Budget"
      type="number"
      prefix="$"
      :rules="[val => val > 0 || 'Budget must be greater than 0']"
    />
    
    <div class="row justify-end">
      <q-btn
        type="submit"
        color="primary"
        label="Post Job"
        :loading="loading"
      />
    </div>
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Job } from '../../types'

const emit = defineEmits<{
  submit: [job: Partial<Job>]
}>()

defineProps<{
  loading?: boolean
}>()

const categories = [
  'Web Development',
  'Mobile Development',
  'Design',
  'Data Science',
  'Marketing',
  'Writing',
  'Other'
]

const form = ref<Partial<Job>>({
  title: '',
  description: '',
  budget: 0,
  category: ''
})

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
EOF

cat > src/components/Jobs/JobList.vue << 'EOF'
<template>
  <div>
    <div v-if="loading" class="flex flex-center q-pa-xl">
      <q-spinner size="50px" color="primary" />
    </div>
    
    <div v-else-if="jobs.length === 0" class="text-center q-pa-xl">
      <q-icon name="work_off" size="64px" color="grey-5" />
      <div class="text-h6 text-grey-6 q-mt-md">No jobs found</div>
    </div>
    
    <div v-else class="row q-col-gutter-md">
      <div v-for="job in jobs" :key="job.name" class="col-12 col-sm-6 col-md-4">
        <JobCard :job="job" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import JobCard from './JobCard.vue'
import type { Job } from '../../types'

defineProps<{
  jobs: Job[]
  loading?: boolean
}>()
</script>
EOF

# Bid Components
cat > src/components/Bids/BidCard.vue << 'EOF'
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
EOF

cat > src/components/Bids/BidForm.vue << 'EOF'
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
EOF

cat > src/components/Bids/BidList.vue << 'EOF'
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
EOF

# User Components
cat > src/components/User/ProfileCard.vue << 'EOF'
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
EOF

cat > src/components/User/ProfileEdit.vue << 'EOF'
<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="form.first_name"
      label="First Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.last_name"
      label="Last Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.bio"
      label="Bio"
      type="textarea"
      rows="4"
    />
    
    <q-input
      v-model.number="form.hourly_rate"
      label="Hourly Rate"
      type="number"
      prefix="$"
    />
    
    <q-select
      v-model="form.skills"
      :options="skillOptions"
      label="Skills"
      multiple
      use-chips
    />
    
    <div class="row justify-end">
      <q-btn
        type="submit"
        color="primary"
        label="Save Changes"
        :loading="loading"
      />
    </div>
  </q-form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import type { User } from '../../types'

const props = defineProps<{
  user: User
  loading?: boolean
}>()

const emit = defineEmits<{
  submit: [data: Partial<User>]
}>()

const skillOptions = [
  'JavaScript', 'Python', 'Vue.js', 'React', 'Node.js',
  'Design', 'UI/UX', 'Marketing', 'Writing', 'Data Science'
]

const form = ref<Partial<User>>({ ...props.user })

watch(() => props.user, (newUser) => {
  form.value = { ...newUser }
}, { deep: true })

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
EOF

# Chat Components
cat > src/components/Chat/MessageList.vue << 'EOF'
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
EOF

cat > src/components/Chat/MessageForm.vue << 'EOF'
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
EOF

# Auth Components
cat > src/components/Auth/LoginForm.vue << 'EOF'
<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="email"
      label="Email"
      type="email"
      :rules="[val => !!val || 'Email is required']"
    />
    
    <q-input
      v-model="password"
      label="Password"
      type="password"
      :rules="[val => !!val || 'Password is required']"
    />
    
    <q-btn
      type="submit"
      color="primary"
      label="Login"
      class="full-width"
      :loading="loading"
    />
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  submit: [credentials: { email: string; password: string }]
}>()

defineProps<{
  loading?: boolean
}>()

const email = ref('')
const password = ref('')

const onSubmit = () => {
  emit('submit', { email: email.value, password: password.value })
}
</script>
EOF

cat > src/components/Auth/RegisterForm.vue << 'EOF'
<template>
  <q-form @submit="onSubmit" class="q-gutter-md">
    <q-input
      v-model="form.first_name"
      label="First Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.last_name"
      label="Last Name"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.email"
      label="Email"
      type="email"
      :rules="[val => !!val || 'Required']"
    />
    
    <q-input
      v-model="form.password"
      label="Password"
      type="password"
      :rules="[val => !!val || 'Required', val => val.length >= 6 || 'Min 6 characters']"
    />
    
    <q-select
      v-model="form.user_type"
      :options="['Freelancer', 'Client']"
      label="I am a"
    />
    
    <q-btn
      type="submit"
      color="primary"
      label="Register"
      class="full-width"
      :loading="loading"
    />
  </q-form>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  submit: [data: {
    email: string
    password: string
    first_name: string
    last_name: string
    user_type: 'Freelancer' | 'Client'
  }]
}>()

defineProps<{
  loading?: boolean
}>()

const form = ref({
  first_name: '',
  last_name: '',
  email: '',
  password: '',
  user_type: 'Freelancer' as 'Freelancer' | 'Client'
})

const onSubmit = () => {
  emit('submit', form.value)
}
</script>
EOF

# ============================================
# CREATE SCSS FILE
# ============================================

cat > src/css/app.scss << 'EOF'
// App styles
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.full-height {
  height: 100vh;
}
EOF

echo ""
echo "✅ TypeScript support and all remaining files created!"
echo ""
echo "📦 Next steps:"
echo "   1. cd frontend"
echo "   2. rm -rf node_modules package-lock.json (if exists)"
echo "   3. npm install"
echo "   4. npm run dev"
echo ""
echo "🎉 Your marketplace now has TypeScript + complete component library!"
