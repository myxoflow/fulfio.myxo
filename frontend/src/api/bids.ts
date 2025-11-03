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
