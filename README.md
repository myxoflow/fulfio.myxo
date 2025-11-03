# Freelancer Marketplace

Modern, mobile-responsive freelancer marketplace.

## Tech Stack
- Frontend: Vue3 + Quasar + Pinia
- Backend: Frappe + PostgreSQL
- Storage: Storj (25GB free)

## Setup

### Frontend
```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```

### Backend
```bash
# Install Frappe first
bench init freelancer-bench
cd freelancer-bench
bench new-site marketplace.local --db-type postgres
bench get-app freelancer_marketplace /path/to/backend
bench --site marketplace.local install-app freelancer_marketplace
bench start
```

## Features
- ✅ User authentication
- ✅ Job posting
- ✅ Bidding system
- ✅ Project management
- ✅ File uploads (Storj)
- ✅ Responsive design
