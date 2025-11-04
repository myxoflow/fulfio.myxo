import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime

class Portfolio(Document):
    def before_insert(self):
        self.created_on = now_datetime()
        if not self.freelancer:
            self.freelancer = frappe.session.user
