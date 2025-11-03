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
