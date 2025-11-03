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
