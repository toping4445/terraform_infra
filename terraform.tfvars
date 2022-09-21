mlops_group_policy_arn = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess", 
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/AWSLambda_FullAccess",
"arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
"arn:aws:iam::aws:policy/AWSBatchFullAccess",
"arn:aws:iam::aws:policy/CloudWatchFullAccess",
"arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
"arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
"arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
"arn:aws:iam::aws:policy/AmazonECS_FullAccess",
"arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
]

mlops_stepfunction_role_policy_arn = [
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/AmazonAthenaFullAccess", 
"arn:aws:iam::aws:policy/AWSBatchFullAccess",
"arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
"arn:aws:iam::aws:policy/AWSLambda_FullAccess",
"arn:aws:iam::aws:policy/CloudWatchFullAccess",
"arn:aws:iam::aws:policy/AmazonECS_FullAccess",
"arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
"arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
]

mlops_lambda_role_policy_arn = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess",
"arn:aws:iam::aws:policy/AWSLambda_FullAccess",
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
"arn:aws:iam::aws:policy/CloudWatchFullAccess",
"arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
"arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
]

mlops_batch_jd_role_policy_arn = [
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/SecretsManagerReadWrite",
"arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
]

mlops_batch_ce_role_policy_arn = [
"arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole",
"arn:aws:iam::aws:policy/SecretsManagerReadWrite",
]

mlops_sagemaker_role_policy_arn = [
"arn:aws:iam::aws:policy/IAMFullAccess",
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
"arn:aws:iam::aws:policy/AmazonSSMFullAccess",
"arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
"arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
"arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
"arn:aws:iam::aws:policy/AWSLakeFormationDataAdmin",
]