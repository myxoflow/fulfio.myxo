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
