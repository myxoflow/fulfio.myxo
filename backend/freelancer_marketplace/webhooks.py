import frappe
import hmac
import hashlib
import json

def verify_webhook_signature(payload, signature, secret):
    """Verify webhook signature"""
    expected_signature = hmac.new(
        secret.encode(),
        payload.encode(),
        hashlib.sha256
    ).hexdigest()
    
    return hmac.compare_digest(signature, expected_signature)

def handle_payment_webhook(payload):
    """Handle payment gateway webhook"""
    # Parse webhook data
    data = json.loads(payload)
    
    # TODO: Implement based on your payment gateway
    # Example for Stripe:
    if data.get('type') == 'payment_intent.succeeded':
        payment_intent = data['data']['object']
        project_id = payment_intent['metadata']['project_id']
        
        # Update project payment status
        frappe.db.set_value('Project', project_id, 'payment_status', 'Paid')
        frappe.db.commit()
        
        # Notify users
        project = frappe.get_doc('Project', project_id)
        notify_payment_received(project)
    
    return {"status": "success"}

def notify_payment_received(project):
    """Notify when payment is received"""
    frappe.publish_realtime(
        event='payment_received',
        message={'project': project.name, 'amount': project.amount},
        user=project.freelancer
    )
