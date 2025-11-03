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
