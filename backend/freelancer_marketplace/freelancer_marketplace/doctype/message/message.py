import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime

class Message(Document):
    def before_insert(self):
        self.created_on = now_datetime()
        if not self.sender:
            self.sender = frappe.session.user
    
    def after_insert(self):
        # Send notification to receiver
        frappe.publish_realtime(
            event='new_message',
            message={
                'sender': self.sender,
                'content': self.content,
                'created_on': self.created_on
            },
            user=self.receiver
        )
