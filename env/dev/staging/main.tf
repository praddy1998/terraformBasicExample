module "vpc" {
  source = "../../modules/vpc"
  cidr   = "10.30.0.0/16"
  env    = "staging"
  ingress_from_port= 80
  ingress_to_port = 80

}

module "subnets" {
  source          = "../../modules/subnets"
  azs             = "ap-south-1a,ap-south-1b"
  env             = "staging"
  vpc_id          = module.vpc.vpc_id
  private_subnets = ["10.30.6.0/24", "10.30.7.0/24"]
  public_subnets  = ["10.30.1.0/24", "10.30.2.0/24"]
  cluster_name = "test-staging"
}

module "eks" {
  source                   = "../../modules/eks-master"
  env                      = "staging"
  name                     = "test-staging"
  vpc_id                   = module.vpc.vpc_id
  eks-master-role          = "eks-staging-master-role"
  subnet_ids               = module.subnets.public_subnets[0]
  eks_cidr                 = "192.168.0.0/16"
  cidr_ingress_1           = [module.vpc.cidr_block]
  security_groups_postgres = module.postgres.postgres_sg.id
  eks_add_sg_name          = "eks_add_sg_staging"
}

module "test-staging-eks-node-group" {
  source              = "../../modules/eks-nodes"
  cluster_name        = module.eks.k8s-cluster-name
  eks-node-group-role = "eks-node-group-role"
  instance_type       = "t3.medium"

  min_size     = "4"
  max_size     = "4"
  desired_size = "4" //load test config
 capacity_type = "SPOT"
  env        = "staging"
  name       = "test-staging"
  subnet_ids = module.subnets.public_subnets[0]
  ssh_key    = "test-staging"
  ami_type   = "AL2_x86_64"
  remote_access_sg_id = module.sg.add_sg.id
}

module "s3" {
  source      = "../../modules/s3"
  env         = "staging"
  bucket_name = "test-prowler"
}
/*
module "s3-with-policy" {
  source      = "../../modules/s3-with-policy"
  env         = "staging"
  bucket_name = ["test-staging-admin", "test-staging-app", "test-app-test1"]

}
helm uninstall aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system
*/

module "ecr" {
  source         = "../../modules/ecr"
  name           = toset(["identity-service", "event-management-service", "venue-management-service", "orchestration-service", "assessment-service", "notification-service", "gateway-service", "website-cms","search-service"])

  project_family = "test"
  scan_on_push   = true
}


module "postgres" {
  source              = "../../modules/postgres"
  vpc_id              = module.vpc.vpc_id
  db_name             = "test-postgres"
  username            = "master"
  password            = "test_password_321"
  instance_class      = "db.t4g.micro"
  allocated_storage   = 50
  engine_version      = "13.13"
  cidr_ingress_1      = ["0.0.0.0/0"]
  cidr_ingress_2      = ["10.30.0.0/16"]
  aws_rds_sg_name     = "test-rds-sg"
  publicly_accessible = false
  skip_final_snapshot = true
  security_groups_eks = module.eks.eks_add_sg.id
  rds_subnet_group    = module.subnets.rds_subnet_group
}
/*
module "postgres_pub" {
  source                = "../../modules/postgres"
  vpc_id                = module.vpc.vpc_id
  db_name               = "test-pub-postgres"
  username              = "master"
  password              = "test_password_321"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 50
  engine_version        = "13.10"
  cidr_ingress_1        = ["10.30.0.0/16"]
  cidr_ingress_2        = ["10.30.0.0/16"]
  aws_rds_sg_name       = "test-rds--pub-sg"
  publicly_accessible   = true
  security_groups_eks =  module.eks.eks_add_sg.id
  rds_subnet_group      = module.subnets.rds_public_subnet_group

// directly store cred into paramter store and same for atlas.
/*
module "eks-resource" {
  source= "../../modules/eks-resource" 
}
*/

module "rabbitmq" {
  source = "../../modules/rabbitmq"

  broker_name        = "test-rabbitmq"
  engine_version     = "3.11.20"
  host_instance_type = "mq.t3.micro"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [module.subnets.private_subnets[0][0]]
  username           = "admin"
  password           = "test_password@321"
  cidr_ingress_1     = module.vpc.cidr_block
  cidr_ingress_2     = module.vpc.cidr_block

}

module "cloudfront_app" {
  source = "../../modules/cloudfront"
  providers = {
    aws = aws.cdn
  }
  sub-domain  = "stage.testtrial.com"
  bucket_name = "stage.testtrial.com"
  domain      = "testtrial.com"
}


module "cloudfront_admin" {

  source = "../../modules/cloudfront"
  providers = {
    aws = aws.cdn
  }
  sub-domain  = "stageadmin.testtrial.com"
  bucket_name = "stageadmin.testtrial.com"
  domain      = "testtrial.com"

}

module "cloudfront_cms" {

  source = "../../modules/cloudfront"
  providers = {
    aws = aws.cdn
  }
  sub-domain  = "stage-cms.testtrial.com"
  bucket_name = "stage-cms.testtrial.com"
  domain      = "testtrial.com"

}

module "cloudfront_cms_ui" {

  source = "../../modules/cloudfront"
  providers = {
    aws = aws.cdn
  }
  sub-domain  = "stage-cms-ui.testtrial.com"
  bucket_name = "stage-cms-ui.testtrial.com"
  domain      = "testtrial.com"

}

module "aws_acm" {
  source     = "../../modules/aws_acm"
  domain     = "testtrial.com"
  sub-domain = "stage-api.testtrial.com"
}

module "ec2_bastion" {
  source          = "../../modules/ec2"
  ami             = "ami-0a0f1259dd1c90938"
  key_name        = "test-staging-bastion"
  subnet_ids      = module.subnets.public_subnets[0][0]
  instance_type   = "t3.micro"
  vpc_id          = module.vpc.vpc_id
  cidr_ingress_1  = ["0.0.0.0/0"]
  cidr_ingress_2  = ["0.0.0.0/0"]
  aws_ec2_sg_name = "bastion-sg"

}


module "sg" {
  source = "../../modules/security_groups"
  add_sg = "add_sg"
  vpc_id = module.vpc.vpc_id
  cidr_ingress_1     = [module.vpc.cidr_block]
  efs_eks_node_sg = "efs_eks_node_sg"
}

module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "staging_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "test-staging"]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "test-staging"]
      command     = "aws"
    }
  }
}

module "alb" {
  source = "../../modules/aws_lb"
  cluster_name = "test-staging"
  lb_role_iam_role_arn = module.lb_role.iam_role_arn
  vpc_id = module.vpc.vpc_id
}

module "secretsmanager" {
  source = "../../modules/secret_manager"
  secretName = "staging"
}
