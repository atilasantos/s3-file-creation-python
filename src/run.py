from asyncio.log import logger
import io
import logging
import os
import boto3
from datetime import datetime

# logging
logging.basicConfig(encoding='utf-8', level=logging.INFO)

# constants
ACCESS_KEY = os.environ['ACCESS_KEY']
SECRET_KEY = os.environ['SECRET_KEY']
bucket_name = os.environ['BUCKET_NAME']
data = io.BytesIO(b'platform-challange data example')

# actual date and time
now = datetime.now()

# generate a file name 
def get_file_name(name: str) -> str:
    return f'{name}-{now.strftime("%Y-%m-%d-%H:%M:%S")}.txt'

try:        
        # Create an S3 client
    s3_client = boto3.client(
        's3',
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY
        )
    file_name = get_file_name("platform-challange")

    s3_client.upload_fileobj(data, bucket_name, file_name)
    logger.info(f'file created with success: {file_name}')

except:
    logger.error("Failed to upload file", file_name)


