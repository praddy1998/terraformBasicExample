
output "postgres_username" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_latest_ver.secret_string)["postgres_username"]
}

output "postgres_password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_latest_ver.secret_string)["postgres_password"]
}


output "mq_username" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_latest_ver.secret_string)["mq_username"]
}

output "mq_password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_latest_ver.secret_string)["mq_password"]
}
