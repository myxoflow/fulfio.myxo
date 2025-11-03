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
