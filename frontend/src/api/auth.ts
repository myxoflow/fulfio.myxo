import axios from 'axios'

const API_URL = process.env.API_URL || 'http://localhost:3000'

export const authAPI = {
  login: (email: string, password: string) => 
    axios.post(`${API_URL}/api/auth/login`, { email, password }),
  
  register: (userData: any) => 
    axios.post(`${API_URL}/api/auth/register`, userData),
  
  logout: () => 
    axios.post(`${API_URL}/api/auth/logout`),
  
  checkAuth: () => 
    axios.get(`${API_URL}/api/auth/me`)
}