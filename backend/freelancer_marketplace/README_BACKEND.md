# Freelancer Marketplace Backend

Frappe Framework backend for the freelancer marketplace.

## Structure

```
freelancer_marketplace/
├── api/
│   └── api.py              # REST API endpoints
├── doctype/                # All DocTypes (database tables)
├── fixtures/               # Default data and configurations
├── templates/              # Email templates
├── utils.py                # Utility functions
├── validators.py           # Validation logic
├── permissions.py          # Permission handlers
├── search.py               # Search functionality
├── analytics.py            # Statistics and analytics
├── webhooks.py             # Webhook handlers
├── background_jobs.py      # Scheduled tasks
├── storj_utils.py          # File storage (Storj)
├── payment.py              # Payment gateway integration
└── notifications.py        # Real-time notifications
```

## API Endpoints

### Authentication
- POST `/api/method/freelancer_marketplace.api.register`
- POST `/api/method/freelancer_marketplace.api.login`
- POST `/api/method/freelancer_marketplace.api.logout`

### Jobs
- GET `/api/resource/JobPosting` - List jobs
- GET `/api/resource/JobPosting/{id}` - Get job details
- POST `/api/resource/JobPosting` - Create job
- PUT `/api/resource/JobPosting/{id}` - Update job
- DELETE `/api/resource/JobPosting/{id}` - Delete job
- POST `/api/method/freelancer_marketplace.api.search_jobs` - Search jobs

### Bids
- GET `/api/resource/Bid` - List bids
- POST `/api/resource/Bid` - Create bid
- POST `/api/method/freelancer_marketplace.api.accept_bid` - Accept bid
- GET `/api/method/freelancer_marketplace.api.get_user_bids` - Get user's bids

### Projects
- GET `/api/resource/Project` - List projects
- GET `/api/method/freelancer_marketplace.api.get_user_projects` - Get user's projects
- POST `/api/method/freelancer_marketplace.api.complete_project` - Complete project

### Messages
- GET `/api/resource/Message` - List messages
- POST `/api/resource/Message` - Send message
- GET `/api/method/freelancer_marketplace.api.get_messages` - Get conversation

### Reviews
- GET `/api/resource/Review` - List reviews
- POST `/api/resource/Review` - Create review

### Portfolio
- GET `/api/resource/Portfolio` - List portfolio items
- POST `/api/resource/Portfolio` - Add portfolio item

### Files
- POST `/api/method/freelancer_marketplace.api.upload_file` - Upload file

## Setup

1. Install Frappe Framework
2. Get this app: `bench get-app freelancer_marketplace /path/to/app`
3. Install on site: `bench --site your-site install-app freelancer_marketplace`
4. Migrate: `bench --site your-site migrate`
5. Configure Storj in site_config.json

## Configuration

Add to `sites/your-site/site_config.json`:

```json
{
  "storj_access_key_id": "your-key",
  "storj_secret_access_key": "your-secret",
  "storj_bucket": "your-bucket"
}
```

## Development

```bash
# Start development server
bench start

# Run migrations
bench --site your-site migrate

# Console
bench --site your-site console

# Clear cache
bench --site your-site clear-cache
```
