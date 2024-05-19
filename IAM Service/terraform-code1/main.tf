## Crear usuario
resource "aws_iam_user" "my_user" {
  name = var.user_name
}

## Configuracion profiel contraseña 
resource "aws_iam_user_login_profile" "my_user_login_profile" {
  user                    = aws_iam_user.my_user.name
  password_length         = 12  
  password_reset_required = true
}

## Politica creada por AWS
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

## Atachar politica la usuario
resource "aws_iam_user_policy_attachment" "my_user_attachment" {
  user       = aws_iam_user.my_user.name
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}
