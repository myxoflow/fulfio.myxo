import frappe
from frappe import _

def notify_new_bid(bid):
    """Send notification when new bid is placed"""
    job = frappe.get_doc('JobPosting', bid.job_posting)
    
    frappe.publish_realtime(
        event='new_bid',
        message={
            'job_title': job.title,
            'freelancer': bid.freelancer,
            'amount': bid.proposed_price
        },
        user=job.posted_by
    )

def notify_bid_accepted(bid):
    """Send notification when bid is accepted"""
    frappe.publish_realtime(
        event='bid_accepted',
        message={
            'job_title': frappe.db.get_value('JobPosting', bid.job_posting, 'title')
        },
        user=bid.freelancer
    )

def notify_new_message(message):
    """Send notification for new message"""
    frappe.publish_realtime(
        event='new_message',
        message={
            'sender': message.sender,
            'content': message.content[:50]
        },
        user=message.receiver
    )
