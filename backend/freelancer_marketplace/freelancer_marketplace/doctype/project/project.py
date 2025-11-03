import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime, today

class Project(Document):
    def before_insert(self):
        if not self.start_date:
            self.start_date = today()
    
    def on_update(self):
        if self.status == 'Completed' and self.has_value_changed('status'):
            # Update user's total projects
            self.update_user_project_count()
    
    def update_user_project_count(self):
        freelancer_count = frappe.db.count('Project', {
            'freelancer': self.freelancer,
            'status': 'Completed'
        })
        frappe.db.set_value('UserProfile', 
            {'user': self.freelancer}, 
            'total_projects', 
            freelancer_count)
