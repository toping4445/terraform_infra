import os
import json
from datetime import datetime
import boto3
import string
import random
import awswrangler as wr


def get_random_string():
    LENGTH = 5
    string_pool = string.ascii_lowercase + string.digits
    result = ""
    for i in range(LENGTH) :
        result += random.choice(string_pool) 
    return result

def lambda_handler(event, context):
    print(event)
 
    #input from step function parameter 
    MODEL_NAME = event["MODEL_NAME"] 
    MODEL_VERSION = event["MODEL_VERSION"] 
    STD_DATE = event["STD_DATE"] 
 
    #env
    BUCKET = os.environ["BUCKET"]
    DATABASE = os.environ["ATHENA_DATABASE"]
    
    #to be extracted from meta store
    TABLE_NAME = event["TABLE_NAME"] 
    TABLE_KEY = "pay_account_id"
    TEMP_TABLE_NAME = f"{TABLE_NAME}_{STD_DATE.replace('-', '')}_{get_random_string()}"
    KEY = "data/"+TEMP_TABLE_NAME
    athena_database = "sampledb"
    athena_workgroup = "primary"
    
    meta_query = f"""SELECT count(distinct {TABLE_KEY}) row_count 
                       FROM {TABLE_NAME}_view \
                      WHERE yyyymmdd = '{STD_DATE}'"""
        
    meta_result = wr.athena.read_sql_query(
        meta_query,
        database=athena_database,
        workgroup=athena_workgroup
    )

    row_count = meta_result['row_count'].iloc[0]
    print(f"row_count = {row_count}")
    assert row_count > 0 , f"table key({TABLE_KEY})의 count가 1이 이상이 아닙니다."
    
    ddl_query = f"""CREATE TABLE {DATABASE}.{TEMP_TABLE_NAME} \
                  WITH (external_location ='s3://{BUCKET}/{KEY}', \
                        bucketed_by = ARRAY['{TABLE_KEY}'], \
                        format = 'PARQUET', \
                        bucket_count = {int((row_count/100000) + 1)})\
                AS \
                SELECT * \
                  FROM {DATABASE}.{TABLE_NAME}_view \
                 WHERE yyyymmdd = '{STD_DATE}'"""
            
    
    return {
        'statusCode': 200,
        'query': ddl_query,
        'table_name' : TABLE_NAME,
        's3_location' : f's3://{BUCKET}/{KEY}',
        's3_key' : KEY,
        'temp_table_name' : TEMP_TABLE_NAME
    }