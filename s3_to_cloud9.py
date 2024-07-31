# Import s3 data to Cloud9

import boto3
import os

# Specify the AWS region and S3 bucket name
region_name = 'us-east-1'
bucket_name = 'waterdataproject'
file_key = 'finaltable.csv000'  # Specify the key (path) of the file you want to download

# Create an S3 client
s3_client = boto3.client('s3', region_name=region_name)

# List objects in the specified S3 bucket
response = s3_client.list_objects_v2(Bucket=bucket_name)

if 'Contents' in response:
    print("Objects in the S3 bucket:")
    for obj in response['Contents']:
        print(f" - {obj['Key']}")

# Download a specific file from S3 to the Cloud9 environment
download_path = '/home/ec2-user/environment/'  # Specify the local download path
os.makedirs(download_path, exist_ok=True)  # Create the download directory if it doesn't exist

local_file_path = os.path.join(download_path, os.path.basename(file_key))
print(f"Downloading file: {file_key} to {local_file_path}")

s3_client.download_file(bucket_name, file_key, local_file_path)

print(f"File downloaded successfully!")
