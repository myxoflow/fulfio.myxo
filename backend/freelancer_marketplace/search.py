import frappe
from frappe.utils import cstr

def search_jobs(query, filters=None):
    """Advanced job search"""
    conditions = ["status = 'Open'"]
    
    if query:
        conditions.append(f"(title LIKE '%{query}%' OR description LIKE '%{query}%')")
    
    if filters:
        if filters.get('category'):
            conditions.append(f"category = '{filters['category']}'")
        
        if filters.get('min_budget'):
            conditions.append(f"budget >= {filters['min_budget']}")
        
        if filters.get('max_budget'):
            conditions.append(f"budget <= {filters['max_budget']}")
    
    where_clause = " AND ".join(conditions)
    
    jobs = frappe.db.sql(f"""
        SELECT name, title, description, budget, category, posted_by, created_on
        FROM `tabJobPosting`
        WHERE {where_clause}
        ORDER BY created_on DESC
        LIMIT 50
    """, as_dict=True)
    
    return jobs

def search_freelancers(query, filters=None):
    """Search for freelancers"""
    conditions = ["user_type = 'Freelancer'", "enabled = 1"]
    
    if query:
        conditions.append(f"(first_name LIKE '%{query}%' OR last_name LIKE '%{query}%')")
    
    where_clause = " AND ".join(conditions)
    
    users = frappe.db.sql(f"""
        SELECT name, first_name, last_name, bio, skills, hourly_rate, rating
        FROM `tabUser`
        WHERE {where_clause}
        ORDER BY rating DESC
        LIMIT 20
    """, as_dict=True)
    
    return users
