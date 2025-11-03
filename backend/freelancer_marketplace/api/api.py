import frappe
from frappe import _
from frappe.utils import now_datetime

# ============================================
# AUTHENTICATION
# ============================================

@frappe.whitelist(allow_guest=True)
def register(email, password, first_name, last_name, user_type):
    """Register new user"""
    if frappe.db.exists("User", email):
        frappe.throw(_("User already exists"))
    
    user = frappe.new_doc("User")
    user.update({
        "email": email,
        "first_name": first_name,
        "last_name": last_name,
        "user_type": user_type,
        "enabled": 1,
        "send_welcome_email": 0
    })
    user.insert(ignore_permissions=True)
    user.add_roles("User")
    
    # Create user profile
    profile = frappe.new_doc("UserProfile")
    profile.user = user.name
    profile.insert(ignore_permissions=True)
    
    from frappe.utils.password import update_password
    update_password(user.name, password)
    
    return {"status": "success", "user": user.name}

@frappe.whitelist(allow_guest=True)
def login(email, password):
    """Login user"""
    try:
        from frappe.auth import LoginManager
        login_manager = LoginManager()
        login_manager.authenticate(user=email, pwd=password)
        login_manager.post_login()
        
        user = frappe.get_doc("User", frappe.session.user)
        return {
            "status": "success",
            "user": {
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "user_type": user.user_type
            },
            "sid": frappe.session.sid
        }
    except Exception as e:
        frappe.local.response['http_status_code'] = 401
        return {"status": "error", "message": str(e)}

@frappe.whitelist()
def logout():
    """Logout user"""
    frappe.local.login_manager.logout()
    return {"status": "success"}

# ============================================
# JOBS
# ============================================

@frappe.whitelist()
def search_jobs(query):
    """Search for jobs"""
    filters = [["JobPosting", "status", "=", "Open"]]
    
    if query:
        filters.append(["JobPosting", "title", "like", f"%{query}%"])
    
    jobs = frappe.get_list(
        "JobPosting",
        filters=filters,
        fields=["name", "title", "description", "budget", "category", "posted_by", "status", "created_on"],
        limit=50,
        order_by="created_on desc"
    )
    return jobs

@frappe.whitelist()
def get_user_jobs():
    """Get jobs posted by current user"""
    user = frappe.session.user
    jobs = frappe.get_list('JobPosting', 
        filters={'posted_by': user},
        fields=['name', 'title', 'budget', 'status', 'created_on'],
        order_by='created_on desc'
    )
    return jobs

# ============================================
# BIDS
# ============================================

@frappe.whitelist()
def get_user_bids():
    """Get bids placed by current user"""
    user = frappe.session.user
    bids = frappe.get_list('Bid',
        filters={'freelancer': user},
        fields=['name', 'job_posting', 'proposed_price', 'status', 'created_on'],
        order_by='created_on desc'
    )
    return bids

@frappe.whitelist()
def accept_bid(bid_id):
    """Accept a bid and create project"""
    bid = frappe.get_doc('Bid', bid_id)
    job = frappe.get_doc('JobPosting', bid.job_posting)
    
    if job.posted_by != frappe.session.user:
        frappe.throw(_("Not authorized"))
    
    # Update bid status
    bid.status = 'Accepted'
    bid.save()
    
    # Reject all other bids
    other_bids = frappe.get_all('Bid', 
        filters={
            'job_posting': job.name,
            'status': 'Pending',
            'name': ['!=', bid_id]
        })
    for other_bid in other_bids:
        frappe.db.set_value('Bid', other_bid.name, 'status', 'Rejected')
    
    # Create project
    project = frappe.new_doc('Project')
    project.update({
        "title": job.title,
        "job_posting": job.name,
        "client": job.posted_by,
        "freelancer": bid.freelancer,
        "amount": bid.proposed_price,
        "status": "Active"
    })
    project.insert()
    
    # Update job status
    job.status = 'In Progress'
    job.save()
    
    return {"status": "success", "project": project.name}

# ============================================
# PROJECTS
# ============================================

@frappe.whitelist()
def get_user_projects():
    """Get projects for current user"""
    user = frappe.session.user
    projects = frappe.get_list('Project',
        filters=[
            ['client', '=', user],
            ['or'],
            ['freelancer', '=', user]
        ],
        fields=['name', 'title', 'client', 'freelancer', 'amount', 'status', 'payment_status'],
        order_by='creation desc'
    )
    return projects

@frappe.whitelist()
def complete_project(project_id):
    """Mark project as completed"""
    project = frappe.get_doc('Project', project_id)
    
    if project.client != frappe.session.user and project.freelancer != frappe.session.user:
        frappe.throw(_("Not authorized"))
    
    project.status = 'Completed'
    project.end_date = frappe.utils.today()
    project.save()
    
    return {"status": "success"}

# ============================================
# MESSAGES
# ============================================

@frappe.whitelist()
def get_messages(user_id):
    """Get messages between current user and another user"""
    current_user = frappe.session.user
    
    messages = frappe.get_list('Message',
        filters=[
            ['sender', 'in', [current_user, user_id]],
            ['receiver', 'in', [current_user, user_id]]
        ],
        fields=['name', 'sender', 'receiver', 'content', 'read', 'created_on'],
        order_by='created_on asc',
        limit=100
    )
    return messages

@frappe.whitelist()
def get_conversations():
    """Get all conversations for current user"""
    current_user = frappe.session.user
    
    # Get unique users with messages
    conversations = frappe.db.sql("""
        SELECT DISTINCT 
            CASE 
                WHEN sender = %(user)s THEN receiver
                ELSE sender
            END as other_user,
            MAX(created_on) as last_message_time
        FROM `tabMessage`
        WHERE sender = %(user)s OR receiver = %(user)s
        GROUP BY other_user
        ORDER BY last_message_time DESC
    """, {'user': current_user}, as_dict=True)
    
    return conversations

# ============================================
# FILES / PORTFOLIO
# ============================================

@frappe.whitelist()
def upload_file():
    """Handle file upload to Storj"""
    from freelancer_marketplace.storj_utils import upload_to_storj
    
    if "file" not in frappe.request.files:
        frappe.throw(_("No file uploaded"))
    
    file = frappe.request.files["file"]
    filename = frappe.utils.random_string(10) + "_" + file.filename
    
    file_url = upload_to_storj(file.stream, filename)
    
    return {"status": "success", "url": file_url, "filename": filename}

# ============================================
# USERS / PROFILES
# ============================================

@frappe.whitelist()
def search_freelancers(query):
    """Search for freelancers"""
    users = frappe.get_list('User',
        filters={
            'user_type': 'Freelancer',
            'enabled': 1,
            'full_name': ['like', f'%{query}%']
        },
        fields=['name', 'first_name', 'last_name', 'user_type'],
        limit=20
    )
    
    # Add profile data
    for user in users:
        profile = frappe.db.get_value('UserProfile', 
            {'user': user.name},
            ['bio', 'skills', 'hourly_rate', 'rating'],
            as_dict=True)
        if profile:
            user.update(profile)
    
    return users

# ============================================
# PAYMENTS
# ============================================

@frappe.whitelist()
def create_payment_session(project_id):
    """Create payment session for project"""
    project = frappe.get_doc('Project', project_id)
    
    if project.client != frappe.session.user:
        frappe.throw(_("Not authorized"))
    
    # TODO: Integrate with Stripe/Razorpay/PayPal
    # For now, return mock session
    session = {
        "url": f"https://payment.example.com/session/{project.name}",
        "session_id": frappe.utils.random_string(32)
    }
    
    return session

@frappe.whitelist()
def verify_payment(project_id, payment_id):
    """Verify payment for project"""
    project = frappe.get_doc('Project', project_id)
    
    # TODO: Verify with payment gateway
    
    project.payment_status = 'Paid'
    project.save()
    
    return {"status": "success"}

@frappe.whitelist()
def release_payment(project_id):
    """Release payment to freelancer"""
    project = frappe.get_doc('Project', project_id)
    
    if project.client != frappe.session.user:
        frappe.throw(_("Not authorized"))
    
    if project.payment_status != 'Paid':
        frappe.throw(_("Payment not received yet"))
    
    project.payment_status = 'Released'
    project.save()
    
    return {"status": "success"}

# ============================================
# NOTIFICATIONS
# ============================================

@frappe.whitelist()
def get_notifications():
    """Get notifications for current user"""
    # TODO: Implement notification system
    return []
