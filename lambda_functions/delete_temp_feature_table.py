import boto3
import os

#env
BUCKET = os.environ["BUCKET"]
DATABASE = os.environ["ATHENA_DATABASE"]
REGION = os.environ["REGION"]

def get_s3_client():
    return boto3.client('s3', region_name=REGION) 

def delete_files(s3_key): 
    s3_client = get_s3_client()
    objects = s3_client.list_objects_v2(
        Bucket=BUCKET,
        Prefix = s3_key).get('Contents',[])
    
    if not objects:
        return
    for obj in objects:    
        s3_client.delete_object(Bucket=BUCKET, Key=obj['Key'])
    s3_client.delete_object(Bucket=BUCKET, Key=s3_key)

def create_drop_temp_table_ddl(temp_table_name):
    query = f"DROP TABLE {DATABASE}.{temp_table_name}"
    return query

def lambda_handler(event, context):
    # put your existing logic here
    try :
        #input from step function parameter 
        temp_table_name = event["step1_output"]["temp_table_name"] 
        s3_key = event["step1_output"]["s3_key"] 
        
        delete_files(s3_key)  
        query = create_drop_temp_table_ddl(temp_table_name)
        
        return {
            'statusCode': 200,
            'query' : query
        }
    except Exception as e :
        print(e)