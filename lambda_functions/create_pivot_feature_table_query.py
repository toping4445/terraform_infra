import os
import json
from datetime import datetime
import boto3
import string
import random



def get_random_string():
    LENGTH = 5
    string_pool = string.ascii_lowercase + string.digits
    result = ""
    for i in range(LENGTH) :
        result += random.choice(string_pool) 
    return result

def lambda_handler(event, context):
    print(event)
 
    TABLE_NAME = event["Input"]["TABLE_NAME"] 
    BUCKET = os.environ["BUCKET"]
    TEMP_TABLE_NAME = TABLE_NAME +"_"+get_random_string()
    KEY = "data/"+TEMP_TABLE_NAME
    STD_DATE = event["Input"]["STD_DATE"] 
    DATABASE = os.environ["ATHENA_DATABASE"]
    

    
    query = f"""CREATE TABLE {TEMP_TABLE_NAME} \
                  WITH (external_location ='s3://{BUCKET}/{KEY}') \
                AS \
                SELECT * \
                  FROM {DATABASE}.{TABLE_NAME}_view \
                 WHERE yyyymmdd = '{STD_DATE}'"""
            
    
    return {
        'statusCode': 200,
        'query': query,
        'table_name' : TABLE_NAME,
        's3_location' : f's3://{BUCKET}/{KEY}'
    }