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
