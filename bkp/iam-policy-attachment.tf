resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.iam-role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}
