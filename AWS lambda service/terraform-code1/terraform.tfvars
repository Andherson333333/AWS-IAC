lambda_role_name   = "test_lambda_role"
lambda_filename    = "lambda_function.zip"
lambda_function_name = "test_lambda"
lambda_handler     = "index.handler"
lambda_runtime     = "nodejs20.x"
lambda_environment_variables = {
  ENV = "dev"
}
lambda_code = <<EOF
exports.handler = async (event) => {
  console.log('Hello from Lambda!');
  return {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
};
EOF
