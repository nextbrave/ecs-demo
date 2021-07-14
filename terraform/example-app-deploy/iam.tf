
data "aws_iam_policy_document" "default" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_role" {
  name               = "${module.prefix.id}-ecs-tasks-role"
  assume_role_policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_policy" "default" {
  name        = "${module.prefix.id}-ecs-tasks-policy"
  path        = "/"
  description = "Policy used for ECS exec-command"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.ecs_tasks_role.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.ecs_tasks_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
