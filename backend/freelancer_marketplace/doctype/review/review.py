import frappe
from frappe.model.document import Document
from frappe.utils import now_datetime

class Review(Document):
    def validate(self):
        # Validate rating is between 1 and 5
        if self.rating < 1 or self.rating > 5:
            frappe.throw("Rating must be between 1 and 5")
        
        # Check if user has already reviewed this project
        existing = frappe.db.exists("Review", {
            "from_user": self.from_user,
            "to_user": self.to_user,
            "project": self.project
        })
        if existing and existing != self.name:
            frappe.throw("You have already reviewed this project")
    
    def before_insert(self):
        self.created_on = now_datetime()
        if not self.from_user:
            self.from_user = frappe.session.user
    
    def after_insert(self):
        # Update user's average rating
        self.update_user_rating()
    
    def update_user_rating(self):
        avg_rating = frappe.db.sql("""
            SELECT AVG(rating) as avg_rating
            FROM `tabReview`
            WHERE to_user = %s
        """, self.to_user)[0][0]
        
        frappe.db.set_value("User", self.to_user, "rating", avg_rating)
