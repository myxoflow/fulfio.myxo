import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/',
    component: () => import('../layouts/MainLayout.vue'),
    children: [
      { path: '', name: 'home', component: () => import('../pages/Home.vue') },
      { path: 'jobs', name: 'jobs', component: () => import('../pages/Jobs.vue') },
      { path: 'jobs/:id', name: 'job-detail', component: () => import('../pages/JobDetail.vue') },
      { path: 'post-job', name: 'post-job', component: () => import('../pages/PostJob.vue'), meta: { requiresAuth: true } },
      { path: 'profile/:id', name: 'profile', component: () => import('../pages/Profile.vue') },
      { path: 'projects', name: 'projects', component: () => import('../pages/Projects.vue'), meta: { requiresAuth: true } },
      { path: 'messages', name: 'messages', component: () => import('../pages/Messages.vue'), meta: { requiresAuth: true } },
      { path: 'dashboard', name: 'dashboard', component: () => import('../pages/Dashboard.vue'), meta: { requiresAuth: true } }
    ]
  },
  { path: '/login', name: 'login', component: () => import('../pages/Login.vue') },
  { path: '/register', name: 'register', component: () => import('../pages/Register.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
