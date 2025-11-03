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
