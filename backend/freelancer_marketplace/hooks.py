app_name = "freelancer_marketplace"
app_title = "Freelancer Marketplace"
app_publisher = "Your Name"
app_description = "Modern freelancer marketplace platform"
app_email = "you@example.com"
app_license = "MIT"
app_version = "1.0.0"

# Document Events
doc_events = {
    "Bid": {
        "after_insert": "freelancer_marketplace.notifications.notify_new_bid",
        "on_update": "freelancer_marketplace.notifications.notify_bid_accepted"
    },
    "Message": {
        "after_insert": "freelancer_marketplace.notifications.notify_new_message"
    },
    "JobPosting": {
        "on_update": "freelancer_marketplace.notifications.notify_job_updated"
    }
}

# Scheduled Tasks
scheduler_events = {
    "daily": [
        "freelancer_marketplace.background_jobs.send_daily_digest",
        "freelancer_marketplace.background_jobs.cleanup_old_data"
    ],
    "hourly": [
        # Add hourly tasks here
    ]
}

# Permissions
permission_query_conditions = {
    "JobPosting": "freelancer_marketplace.permissions.get_permission_query_conditions"
}

has_permission = {
    "JobPosting": "freelancer_marketplace.permissions.has_permission",
    "Bid": "freelancer_marketplace.permissions.has_permission",
    "Project": "freelancer_marketplace.permissions.has_permission",
    "Message": "freelancer_marketplace.permissions.has_permission"
}

# Fixtures
fixtures = [
    {
        "doctype": "Custom Field",
        "filters": [["dt", "=", "User"]]
    },
    {
        "doctype": "Role",
        "filters": [["name", "in", ["Freelancer", "Client"]]]
    }
]

# Website
website_route_rules = [
    {"from_route": "/marketplace/<path:app_path>", "to_route": "marketplace"},
]
