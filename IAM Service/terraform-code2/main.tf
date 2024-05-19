## Crear usuario
resource "aws_iam_user" "my_user" {
  name = var.user_name
}

## Configuracion profile contraseña
resource "aws_iam_user_login_profile" "my_user_login_profile" {
  user                    = aws_iam_user.my_user.name
  password_length         = 12  
  password_reset_required = true
}

## Politica del usuario
resource "aws_iam_policy" "my_policy" {
  name   = "my-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

## Atachar la policita al usuario
resource "aws_iam_user_policy_attachment" "my_policy_attachment" {
  user       = aws_iam_user.my_user.name
  policy_arn = aws_iam_policy.my_policy.arn
}
