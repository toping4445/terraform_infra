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
]

mlops_lambda_role_policy_arn = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess",
"arn:aws:iam::aws:policy/AWSLambda_FullAccess",
"arn:aws:iam::aws:policy/AmazonS3FullAccess",
"arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
"arn:aws:iam::aws:policy/CloudWatchFullAccess",
]