import frappe
from frappe.utils import now_datetime, add_days, get_url
from frappe.utils.password import get_decrypted_password

def send_email_template(template, recipients, context):
    """Send email using template"""
    try:
        frappe.sendmail(
            recipients=recipients,
            subject=context.get('subject', 'Notification'),
            template=template,
            args=context,
            delayed=False
        )
    except Exception as e:
        frappe.log_error(f"Email send error: {str(e)}")

def get_user_full_name(email):
    """Get user's full name from email"""
    user = frappe.get_doc('User', email)
    return f"{user.first_name} {user.last_name}"

def calculate_user_rating(user_email):
    """Calculate average rating for user"""
    ratings = frappe.get_all('Review',
        filters={'to_user': user_email},
        fields=['rating']
    )
    
    if not ratings:
        return 0
    
    total = sum([r.rating for r in ratings])
    return round(total / len(ratings), 2)

def get_unread_message_count(user_email):
    """Get count of unread messages for user"""
    count = frappe.db.count('Message', {
        'receiver': user_email,
        'read': 0
    })
    return count

def mark_messages_as_read(user_email, sender_email):
    """Mark all messages from sender as read"""
    frappe.db.sql("""
        UPDATE `tabMessage`
        SET `read` = 1
        WHERE receiver = %s AND sender = %s AND `read` = 0
    """, (user_email, sender_email))
    frappe.db.commit()
