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
