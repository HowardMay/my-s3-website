terraform {
  backend "s3" {
    # Role to be assumed when accessing the S3 backend - coincidentally the same
    role_arn = "arn:aws:iam::553520878336:role/FullAdminAccess"

    # Replace this with your bucket name!
    bucket         = "terraform-state-storage-hjm"
    key            = "my-s3-website/prod/terraform.tfstate"
    region         = "eu-west-2"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-storage-hjm-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::553520878336:role/FullAdminAccess"
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::553520878336:role/FullAdminAccess"
  }
}

module "s3-static-website" {
#  source = "../../modules/s3-static-website"
  source  = "cn-terraform/s3-static-website/aws"
  version = "1.0.5"

  providers = {
    aws.main         = aws
    aws.acm_provider = aws.us-east-1
  }

  name_prefix = "prod-my-s3-website"

  website_domain_name = "my-s3-website.howard-may.click"

  create_acm_certificate = true
  # acm_certificate_arn_to_use = data.terraform_remote_state.global.outputs.my-s3-website-acm-cert-id

  create_route53_hosted_zone = true
  # route53_hosted_zone_id = data.terraform_remote_state.global.outputs.my-s3-website-hosted-zone-id

  aws_accounts_with_read_view_log_bucket = ["553520878336"]

  website_server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  log_bucket_force_destroy = true
}