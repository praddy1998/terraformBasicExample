
data "aws_iam_policy_document" "secret" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [data.aws_secretsmanager_secret.secret.arn]
    /*principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::730335420893:root"]
    }*/

  }
  
}

resource "aws_iam_policy" "secret" {
  name        = "secret_policy"
  description = "An secret policy to allow reading the secret value"
  policy      = data.aws_iam_policy_document.secret.json
  
}

data "aws_secretsmanager_secret" "secret" {
  name = var.secretName # As stored in the AWS Secrets Manager

}

# Give a meaningful name to the version for easy identification
# If multiple secrets are present
data "aws_secretsmanager_secret_version" "secret_latest_ver" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
