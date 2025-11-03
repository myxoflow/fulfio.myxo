#!/bin/bash

# Freelancer Marketplace - Extra Backend Support Files
# Run this in: freelancer-marketplace/backend/
# Usage: bash add_extra_backend_files.sh

echo "🔧 Adding extra backend support files for Frappe..."

cd freelancer_marketplace

# ============================================
# CREATE FIXTURES DIRECTORY
# ============================================

mkdir -p fixtures

echo "📝 Creating fixtures and configuration files..."

# ============================================
# CUSTOM FIELDS JSON
# ============================================

cat > fixtures/custom_fields.json << 'EOF'
[
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "user_type",
  "label": "User Type",
  "fieldtype": "Select",
  "options": "Freelancer\nClient",
  "insert_after": "email"
 },
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "bio",
  "label": "Bio",
  "fieldtype": "Text Editor",
  "insert_after": "user_type"
 },
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "skills",
  "label": "Skills",
  "fieldtype": "Small Text",
  "insert_after": "bio"
 },
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "hourly_rate",
  "label": "Hourly Rate",
  "fieldtype": "Currency",
  "insert_after": "skills"
 },
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "rating",
  "label": "Rating",
  "fieldtype": "Float",
  "read_only": 1,
  "insert_after": "hourly_rate"
 },
 {
  "doctype": "Custom Field",
  "dt": "User",
  "fieldname": "profile_image",
  "label": "Profile Image",
  "fieldtype": "Data",
  "insert_after": "rating"
 }
]
EOF

# ============================================
# ROLES JSON
# ============================================

cat > fixtures/roles.json << 'EOF'
[
 {
  "doctype": "Role",
  "role_name": "Freelancer",
  "desk_access": 0
 },
 {
  "doctype": "Role",
  "role_name": "Client",
  "desk_access": 0
 }
]
EOF

# ============================================
# EMAIL TEMPLATES
# ============================================

mkdir -p templates/emails

cat > templates/emails/welcome.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background: #f9f9f9; }
        .button { background: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; display: inline-block; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome to Freelancer Marketplace!</h1>
        </div>
        <div class="content">
            <p>Hi {{ user.first_name }},</p>
            <p>Welcome to our platform! We're excited to have you join our community.</p>
            <p>Get started by:</p>
            <ul>
                <li>Completing your profile</li>
                <li>Browsing available jobs</li>
                <li>Connecting with talented freelancers</li>
            </ul>
            <p style="text-align: center; margin-top: 30px;">
                <a href="{{ site_url }}" class="button">Get Started</a>
            </p>
        </div>
    </div>
</body>
</html>
EOF

cat > templates/emails/new_bid.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #2196F3; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background: #f9f9f9; }
        .button { background: #2196F3; color: white; padding: 10px 20px; text-decoration: none; display: inline-block; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>New Bid Received!</h1>
        </div>
        <div class="content">
            <p>Hi {{ job.posted_by }},</p>
            <p>Great news! You have received a new bid on your job posting:</p>
            <h3>{{ job.title }}</h3>
            <p><strong>Bid Amount:</strong> ${{ bid.proposed_price }}</p>
            <p><strong>Freelancer:</strong> {{ bid.freelancer }}</p>
            <p><strong>Message:</strong></p>
            <p>{{ bid.message }}</p>
            <p style="text-align: center; margin-top: 30px;">
                <a href="{{ site_url }}/jobs/{{ job.name }}" class="button">View Bid</a>
            </p>
        </div>
    </div>
</body>
</html>
EOF

cat > templates/emails/bid_accepted.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background: #f9f9f9; }
        .button { background: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; display: inline-block; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 Your Bid Was Accepted!</h1>
        </div>
        <div class="content">
            <p>Hi {{ bid.freelancer }},</p>
            <p>Congratulations! Your bid has been accepted for:</p>
            <h3>{{ job.title }}</h3>
            <p><strong>Project Amount:</strong> ${{ project.amount }}</p>
            <p>You can now start working on this project. Stay in touch with your client through our messaging system.</p>
            <p style="text-align: center; margin-top: 30px;">
                <a href="{{ site_url }}/projects/{{ project.name }}" class="button">View Project</a>
            </p>
        </div>
    </div>
</body>
</html>
EOF

# ============================================
# UTILITY MODULES
# ============================================

cat > utils.py << 'EOF'
import frappe
from frappe.utils import now_datetime, add_days, get_url
from frappe.utils.password import get_decrypted_password

def send_email_template(template, recipients, context):
    """Send email using template"""
    try:
        frappe.sendmail(
            recipients=recipients,
            subject=context.get('subject', 'Notification'),
            template=template,
            args=context,
            delayed=False
        )
    except Exception as e:
        frappe.log_error(f"Email send error: {str(e)}")

def get_user_full_name(email):
    """Get user's full name from email"""
    user = frappe.get_doc('User', email)
    return f"{user.first_name} {user.last_name}"

def calculate_user_rating(user_email):
    """Calculate average rating for user"""
    ratings = frappe.get_all('Review',
        filters={'to_user': user_email},
        fields=['rating']
    )
    
    if not ratings:
        return 0
    
    total = sum([r.rating for r in ratings])
    return round(total / len(ratings), 2)

def get_unread_message_count(user_email):
    """Get count of unread messages for user"""
    count = frappe.db.count('Message', {
        'receiver': user_email,
        'read': 0
    })
    return count

def mark_messages_as_read(user_email, sender_email):
    """Mark all messages from sender as read"""
    frappe.db.sql("""
        UPDATE `tabMessage`
        SET `read` = 1
        WHERE receiver = %s AND sender = %s AND `read` = 0
    """, (user_email, sender_email))
    frappe.db.commit()
EOF

# ============================================
# VALIDATORS MODULE
# ============================================

cat > validators.py << 'EOF'
import frappe
from frappe import _

def validate_bid_amount(bid_amount, job_budget):
    """Validate bid amount is reasonable"""
    if bid_amount <= 0:
        frappe.throw(_("Bid amount must be greater than 0"))
    
    if bid_amount > job_budget * 2:
        frappe.throw(_("Bid amount cannot be more than 2x the job budget"))

def validate_user_can_bid(job_posting, user_email):
    """Check if user can bid on job"""
    job = frappe.get_doc('JobPosting', job_posting)
    
    # Check if job is open
    if job.status != 'Open':
        frappe.throw(_("Cannot bid on closed job"))
    
    # Check if user is the job poster
    if job.posted_by == user_email:
        frappe.throw(_("Cannot bid on your own job"))
    
    # Check if user has already bid
    existing_bid = frappe.db.exists('Bid', {
        'job_posting': job_posting,
        'freelancer': user_email,
        'status': ['!=', 'Rejected']
    })
    
    if existing_bid:
        frappe.throw(_("You have already placed a bid on this job"))

def validate_project_completion(project_name, user_email):
    """Validate user can complete project"""
    project = frappe.get_doc('Project', project_name)
    
    if project.status == 'Completed':
        frappe.throw(_("Project is already completed"))
    
    if project.client != user_email and project.freelancer != user_email:
        frappe.throw(_("You are not authorized to complete this project"))

def validate_review(from_user, to_user, project_name):
    """Validate review can be created"""
    # Check if review already exists
    existing = frappe.db.exists('Review', {
        'from_user': from_user,
        'to_user': to_user,
        'project': project_name
    })
    
    if existing:
        frappe.throw(_("You have already reviewed this project"))
    
    # Check if project is completed
    project = frappe.get_doc('Project', project_name)
    if project.status != 'Completed':
        frappe.throw(_("Cannot review incomplete project"))
EOF

# ============================================
# PERMISSIONS MODULE
# ============================================

cat > permissions.py << 'EOF'
import frappe
from frappe import _

def has_permission(doc, ptype, user):
    """Custom permission check"""
    if ptype == "read":
        return True
    
    # Check if user is the owner
    if hasattr(doc, 'owner') and doc.owner == user:
        return True
    
    # DocType specific permissions
    if doc.doctype == 'JobPosting':
        return doc.posted_by == user
    
    elif doc.doctype == 'Bid':
        job = frappe.get_doc('JobPosting', doc.job_posting)
        return doc.freelancer == user or job.posted_by == user
    
    elif doc.doctype == 'Project':
        return doc.client == user or doc.freelancer == user
    
    elif doc.doctype == 'Message':
        return doc.sender == user or doc.receiver == user
    
    return False

def get_permission_query_conditions(user):
    """Return SQL conditions for permission filtering"""
    if not user:
        user = frappe.session.user
    
    if user == "Administrator":
        return ""
    
    return f"""(`tabJobPosting`.posted_by = '{user}' 
             OR `tabJobPosting`.name IN (
                 SELECT job_posting FROM `tabBid` WHERE freelancer = '{user}'
             ))"""
EOF

# ============================================
# SEARCH MODULE
# ============================================

cat > search.py << 'EOF'
import frappe
from frappe.utils import cstr

def search_jobs(query, filters=None):
    """Advanced job search"""
    conditions = ["status = 'Open'"]
    
    if query:
        conditions.append(f"(title LIKE '%{query}%' OR description LIKE '%{query}%')")
    
    if filters:
        if filters.get('category'):
            conditions.append(f"category = '{filters['category']}'")
        
        if filters.get('min_budget'):
            conditions.append(f"budget >= {filters['min_budget']}")
        
        if filters.get('max_budget'):
            conditions.append(f"budget <= {filters['max_budget']}")
    
    where_clause = " AND ".join(conditions)
    
    jobs = frappe.db.sql(f"""
        SELECT name, title, description, budget, category, posted_by, created_on
        FROM `tabJobPosting`
        WHERE {where_clause}
        ORDER BY created_on DESC
        LIMIT 50
    """, as_dict=True)
    
    return jobs

def search_freelancers(query, filters=None):
    """Search for freelancers"""
    conditions = ["user_type = 'Freelancer'", "enabled = 1"]
    
    if query:
        conditions.append(f"(first_name LIKE '%{query}%' OR last_name LIKE '%{query}%')")
    
    where_clause = " AND ".join(conditions)
    
    users = frappe.db.sql(f"""
        SELECT name, first_name, last_name, bio, skills, hourly_rate, rating
        FROM `tabUser`
        WHERE {where_clause}
        ORDER BY rating DESC
        LIMIT 20
    """, as_dict=True)
    
    return users
EOF

# ============================================
# ANALYTICS MODULE
# ============================================

cat > analytics.py << 'EOF'
import frappe
from frappe.utils import today, add_days, add_months

def get_user_stats(user_email):
    """Get statistics for user"""
    stats = {
        'total_jobs_posted': 0,
        'total_bids_placed': 0,
        'active_projects': 0,
        'completed_projects': 0,
        'total_earned': 0,
        'total_spent': 0,
        'average_rating': 0
    }
    
    user = frappe.get_doc('User', user_email)
    
    if user.user_type == 'Client':
        stats['total_jobs_posted'] = frappe.db.count('JobPosting', {'posted_by': user_email})
        stats['active_projects'] = frappe.db.count('Project', {'client': user_email, 'status': 'Active'})
        stats['completed_projects'] = frappe.db.count('Project', {'client': user_email, 'status': 'Completed'})
        
        # Total spent
        spent = frappe.db.sql("""
            SELECT SUM(amount) as total
            FROM `tabProject`
            WHERE client = %s AND payment_status = 'Released'
        """, user_email)[0][0]
        stats['total_spent'] = spent or 0
    
    else:  # Freelancer
        stats['total_bids_placed'] = frappe.db.count('Bid', {'freelancer': user_email})
        stats['active_projects'] = frappe.db.count('Project', {'freelancer': user_email, 'status': 'Active'})
        stats['completed_projects'] = frappe.db.count('Project', {'freelancer': user_email, 'status': 'Completed'})
        
        # Total earned
        earned = frappe.db.sql("""
            SELECT SUM(amount) as total
            FROM `tabProject`
            WHERE freelancer = %s AND payment_status = 'Released'
        """, user_email)[0][0]
        stats['total_earned'] = earned or 0
    
    # Average rating
    ratings = frappe.db.sql("""
        SELECT AVG(rating) as avg_rating
        FROM `tabReview`
        WHERE to_user = %s
    """, user_email)[0][0]
    stats['average_rating'] = round(ratings or 0, 2)
    
    return stats

def get_platform_stats():
    """Get overall platform statistics"""
    return {
        'total_users': frappe.db.count('User', {'enabled': 1}),
        'total_freelancers': frappe.db.count('User', {'user_type': 'Freelancer', 'enabled': 1}),
        'total_clients': frappe.db.count('User', {'user_type': 'Client', 'enabled': 1}),
        'total_jobs': frappe.db.count('JobPosting'),
        'active_jobs': frappe.db.count('JobPosting', {'status': 'Open'}),
        'total_projects': frappe.db.count('Project'),
        'active_projects': frappe.db.count('Project', {'status': 'Active'}),
        'completed_projects': frappe.db.count('Project', {'status': 'Completed'})
    }
EOF

# ============================================
# WEBHOOKS MODULE
# ============================================

cat > webhooks.py << 'EOF'
import frappe
import hmac
import hashlib
import json

def verify_webhook_signature(payload, signature, secret):
    """Verify webhook signature"""
    expected_signature = hmac.new(
        secret.encode(),
        payload.encode(),
        hashlib.sha256
    ).hexdigest()
    
    return hmac.compare_digest(signature, expected_signature)

def handle_payment_webhook(payload):
    """Handle payment gateway webhook"""
    # Parse webhook data
    data = json.loads(payload)
    
    # TODO: Implement based on your payment gateway
    # Example for Stripe:
    if data.get('type') == 'payment_intent.succeeded':
        payment_intent = data['data']['object']
        project_id = payment_intent['metadata']['project_id']
        
        # Update project payment status
        frappe.db.set_value('Project', project_id, 'payment_status', 'Paid')
        frappe.db.commit()
        
        # Notify users
        project = frappe.get_doc('Project', project_id)
        notify_payment_received(project)
    
    return {"status": "success"}

def notify_payment_received(project):
    """Notify when payment is received"""
    frappe.publish_realtime(
        event='payment_received',
        message={'project': project.name, 'amount': project.amount},
        user=project.freelancer
    )
EOF

# ============================================
# BACKGROUND JOBS MODULE
# ============================================

cat > background_jobs.py << 'EOF'
import frappe
from frappe.utils import now_datetime, add_days

def send_daily_digest():
    """Send daily digest to users"""
    users = frappe.get_all('User', 
        filters={'enabled': 1, 'user_type': ['in', ['Freelancer', 'Client']]},
        fields=['name', 'email', 'first_name']
    )
    
    for user in users:
        # Get user's pending notifications
        stats = get_daily_stats(user.name)
        
        if stats['has_updates']:
            send_digest_email(user, stats)

def get_daily_stats(user_email):
    """Get daily statistics for user"""
    today = now_datetime().date()
    
    return {
        'new_bids': frappe.db.count('Bid', {
            'job_posting': ['in', get_user_jobs(user_email)],
            'creation': ['>=', today]
        }),
        'new_messages': frappe.db.count('Message', {
            'receiver': user_email,
            'read': 0,
            'creation': ['>=', today]
        }),
        'has_updates': True  # Will be calculated based on actual data
    }

def get_user_jobs(user_email):
    """Get list of job IDs for user"""
    jobs = frappe.get_all('JobPosting', 
        filters={'posted_by': user_email},
        pluck='name'
    )
    return jobs or ['']

def send_digest_email(user, stats):
    """Send digest email to user"""
    # TODO: Implement email sending
    pass

def cleanup_old_data():
    """Clean up old data"""
    # Delete old notifications
    old_date = add_days(now_datetime(), -30)
    frappe.db.sql("""
        DELETE FROM `tabMessage`
        WHERE creation < %s AND `read` = 1
    """, old_date)
    
    frappe.db.commit()
EOF

# ============================================
# UPDATE HOOKS.PY WITH ALL MODULES
# ============================================

cat > hooks.py << 'EOF'
app_name = "freelancer_marketplace"
app_title = "Freelancer Marketplace"
app_publisher = "Your Name"
app_description = "Modern freelancer marketplace platform"
app_email = "you@example.com"
app_license = "MIT"
app_version = "1.0.0"

# Document Events
doc_events = {
    "Bid": {
        "after_insert": "freelancer_marketplace.notifications.notify_new_bid",
        "on_update": "freelancer_marketplace.notifications.notify_bid_accepted"
    },
    "Message": {
        "after_insert": "freelancer_marketplace.notifications.notify_new_message"
    },
    "JobPosting": {
        "on_update": "freelancer_marketplace.notifications.notify_job_updated"
    }
}

# Scheduled Tasks
scheduler_events = {
    "daily": [
        "freelancer_marketplace.background_jobs.send_daily_digest",
        "freelancer_marketplace.background_jobs.cleanup_old_data"
    ],
    "hourly": [
        # Add hourly tasks here
    ]
}

# Permissions
permission_query_conditions = {
    "JobPosting": "freelancer_marketplace.permissions.get_permission_query_conditions"
}

has_permission = {
    "JobPosting": "freelancer_marketplace.permissions.has_permission",
    "Bid": "freelancer_marketplace.permissions.has_permission",
    "Project": "freelancer_marketplace.permissions.has_permission",
    "Message": "freelancer_marketplace.permissions.has_permission"
}

# Fixtures
fixtures = [
    {
        "doctype": "Custom Field",
        "filters": [["dt", "=", "User"]]
    },
    {
        "doctype": "Role",
        "filters": [["name", "in", ["Freelancer", "Client"]]]
    }
]

# Website
website_route_rules = [
    {"from_route": "/marketplace/<path:app_path>", "to_route": "marketplace"},
]
EOF

# ============================================
# CREATE README FOR BACKEND
# ============================================

cat > README_BACKEND.md << 'EOF'
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
EOF

echo ""
echo "✅ Extra backend files created successfully!"
echo ""
echo "📋 Created:"
echo "   - fixtures/ (custom fields, roles)"
echo "   - templates/emails/ (3 email templates)"
echo "   - utils.py (helper functions)"
echo "   - validators.py (validation logic)"
echo "   - permissions.py (access control)"
echo "   - search.py (advanced search)"
echo "   - analytics.py (statistics)"
echo "   - webhooks.py (payment webhooks)"
echo "   - background_jobs.py (scheduled tasks)"
echo "   - Updated hooks.py (complete configuration)"
echo "   - README_BACKEND.md (documentation)"
echo ""
echo "🚀 Your backend now has:"
echo "   - Email notification system"
echo "   - Advanced search & filtering"
echo "   - User analytics dashboard"
echo "   - Permission management"
echo "   - Webhook handlers"
echo "   - Background job system"
echo "   - Complete documentation"
echo ""
echo "Next: bench --site your-site migrate"
