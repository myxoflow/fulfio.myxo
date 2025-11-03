import boto3
import frappe
from botocore.exceptions import ClientError

def get_storj_client():
    """Get Storj S3-compatible client"""
    return boto3.client(
        "s3",
        endpoint_url="https://gateway.storjshare.io",
        aws_access_key_id=frappe.conf.get("storj_access_key_id"),
        aws_secret_access_key=frappe.conf.get("storj_secret_access_key"),
    )

def upload_to_storj(fileobj, filename):
    """Upload file to Storj bucket"""
    client = get_storj_client()
    bucket = frappe.conf.get("storj_bucket")
    
    try:
        client.upload_fileobj(fileobj, bucket, filename)
        return f"https://gateway.storjshare.io/{bucket}/{filename}"
    except ClientError as e:
        frappe.log_error(f"Storj upload error: {str(e)}")
        frappe.throw("File upload failed")
