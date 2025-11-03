#!/bin/bash

# Optional: Remove Frappe Desk JS files if you don't need them
# Run this in: freelancer-marketplace/backend/

echo "🧹 Cleaning up optional Frappe Desk JS files..."

cd freelancer_marketplace

# Remove all .js files from doctypes (optional)
find doctype -name "*.js" -type f -delete

echo "✅ Removed Frappe Desk UI files"
echo ""
echo "Note: This only removes admin UI customizations."
echo "Your backend API and Python logic are unaffected."
echo ""
echo "You can still:"
echo "  - Use REST API from Vue frontend"
echo "  - All backend logic works"
echo "  - Create/read/update/delete via API"
echo ""
echo "You CANNOT:"
echo "  - Use custom buttons in Frappe Desk"
echo "  - Have enhanced admin UI"
