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
