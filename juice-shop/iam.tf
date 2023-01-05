resource "aws_iam_role" "ec2_role_juice_shop" {
  name = format("%s-ec2-role-app-server-%s", local.project_prefix, local.build_suffix)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile_juice_shop" {
  name = format("%s-ec2-profile-app-server-%s", local.project_prefix, local.build_suffix)
  role = aws_iam_role.ec2_role_juice_shop.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = format("%s-ec2-policy-app-server-%s", local.project_prefix, local.build_suffix)
  role = aws_iam_role.ec2_role_juice_shop.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}