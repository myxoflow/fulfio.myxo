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
