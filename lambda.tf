data "archive_file" "create_pivot_feature_table_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/create_pivot_feature_table.py"
  output_path = "${path.module}/lambda_zip_files/create_pivot_feature_table.zip"
}

resource "aws_lambda_function" "create_pivot_feature_table" {
  filename      = data.archive_file.create_pivot_feature_table_zip.output_path
  function_name = "tf-create-pivot-feature-table-query"
  role          = aws_iam_role.lambda.arn
  
  handler       = "tf-create-pivot-feature-table-query.lambda_handler"
  timeout       = "600"

  source_code_hash = data.archive_file.create_pivot_feature_table_zip.output_base64sha256 

  runtime = "python3.8" 

#  layers = [aws_lambda_layer_version.lambda_layer_requests.arn]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = "${aws_subnet.private.*.id}"    
    security_group_ids = "${aws_security_group.mlops_default.*.id}" 
  }
  
}


data "archive_file" "delete_temp_feature_table_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/delete_temp_feature_table.py"
  output_path = "${path.module}/lambda_zip_files/delete_temp_feature_table.zip"
}


resource "aws_lambda_function" "delete_temp_feature_table" {
  filename      = data.archive_file.delete_temp_feature_table_zip.output_path
  function_name = "tf-delete-temp-feature-table"
  role          = aws_iam_role.lambda.arn
  
  handler       = "tf-delete-temp-feature-table.lambda_handler"
  timeout       = "600"

  source_code_hash = data.archive_file.delete_temp_feature_table_zip.output_base64sha256 

  runtime = "python3.8" 

#  layers = [aws_lambda_layer_version.lambda_layer_requests.arn]

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = "${aws_subnet.private.*.id}"    
    security_group_ids = "${aws_security_group.mlops_default.*.id}" 
  }
  
}