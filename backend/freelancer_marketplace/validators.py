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
