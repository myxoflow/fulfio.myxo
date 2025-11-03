import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime

class JobPosting(Document):
    def validate(self):
        # Validate budget
        if self.budget <= 0:
            frappe.throw('Budget must be greater than 0')
    
    def before_insert(self):
        self.created_on = now_datetime()
        if not self.posted_by:
            self.posted_by = frappe.session.user
    
    def on_update(self):
        # Notify all bidders if job is closed
        if self.status == 'Closed' and self.has_value_changed('status'):
            self.notify_bidders_job_closed()
    
    def notify_bidders_job_closed(self):
        bids = frappe.get_all('Bid', 
            filters={'job_posting': self.name, 'status': 'Pending'},
            fields=['freelancer'])
        
        for bid in bids:
            frappe.publish_realtime(
                event='job_closed',
                message={'job_title': self.title},
                user=bid.freelancer
            )
