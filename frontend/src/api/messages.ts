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
