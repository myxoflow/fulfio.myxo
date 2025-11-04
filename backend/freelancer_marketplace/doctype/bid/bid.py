import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime

class Bid(Document):
    def validate(self):
        # Validate bid is for open job
        job = frappe.get_doc('JobPosting', self.job_posting)
        if job.status != 'Open':
            frappe.throw('Cannot bid on closed job')
        
        # Prevent bidding on own job
        if job.posted_by == frappe.session.user:
            frappe.throw('Cannot bid on your own job')
        
        # Validate price
        if self.proposed_price <= 0:
            frappe.throw('Price must be greater than 0')
        
        # Check if user has already bid
        existing = frappe.db.exists('Bid', {
            'job_posting': self.job_posting,
            'freelancer': frappe.session.user,
            'status': ['!=', 'Rejected']
        })
        if existing and existing != self.name:
            frappe.throw('You have already placed a bid on this job')
    
    def before_insert(self):
        self.created_on = now_datetime()
        if not self.freelancer:
            self.freelancer = frappe.session.user
    
    def after_insert(self):
        # Notify job poster
        job = frappe.get_doc('JobPosting', self.job_posting)
        frappe.publish_realtime(
            event='new_bid',
            message={
                'job_title': job.title,
                'freelancer': self.freelancer,
                'amount': self.proposed_price
            },
            user=job.posted_by
        )
