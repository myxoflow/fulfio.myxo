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
