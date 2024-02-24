# Url is url of the id token provider. iss field of the token
resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  url             = "https://token.actions.githubusercontent.com"
}

# The values field under condition is used to allow access for workflow triggered from specific repo and environment or branch or tag or "pull_request"
# For more info @ https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims
data "aws_iam_policy_document" "github_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.github.url, "https://", "")}:sub"
      values   = ["repo:trial-For-All/*"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role_policy" "github_oidc_eks_policy" {
    name = "github-oidc-eks-policy"
    role = aws_iam_role.github_oidc_auth_role.id

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": "eks:DescribeCluster",
                "Resource": "arn:aws:eks:*:*:cluster/*"
            },
            {
                "Sid": "VisualEditor1",
                "Effect": "Allow",
                "Action": "eks:ListClusters",
                "Resource": "*"
            }
        ]
    })
}

# Creating a role. It will used as value to role_to_assume for Configure AWS Crendentials action.
resource "aws_iam_role" "github_oidc_auth_role" {
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
  name               = "github-oidc-auth-role"
}