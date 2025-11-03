export interface User {
  name: string
  email: string
  first_name: string
  last_name: string
  user_type: 'Freelancer' | 'Client'
  bio?: string
  skills?: string[]
  hourly_rate?: number
  rating?: number
  profile_image?: string
}

export interface Job {
  name: string
  title: string
  description: string
  budget: number
  category: string
  status: 'Open' | 'In Progress' | 'Closed'
  posted_by: string
  created_on: string
  skills_required?: string[]
}

export interface Bid {
  name: string
  job_posting: string
  freelancer: string
  proposed_price: number
  message: string
  status: 'Pending' | 'Accepted' | 'Rejected'
  delivery_time?: number
}

export interface Project {
  name: string
  title: string
  job_posting: string
  client: string
  freelancer: string
  amount: number
  status: 'Active' | 'Completed' | 'Cancelled'
  start_date?: string
  end_date?: string
  payment_status?: 'Pending' | 'Paid' | 'Released'
}

export interface Message {
  name: string
  sender: string
  receiver: string
  content: string
  created_on: string
  read: boolean
}

export interface Review {
  name: string
  from_user: string
  to_user: string
  project: string
  rating: number
  comment: string
  created_on: string
}

export interface Portfolio {
  name: string
  freelancer: string
  title: string
  description: string
  file_url: string
  thumbnail?: string
  project_link?: string
  created_on: string
}

export interface Notification {
  id: string
  type: 'bid' | 'message' | 'project' | 'payment' | 'review'
  title: string
  message: string
  read: boolean
  created_on: string
  link?: string
}
