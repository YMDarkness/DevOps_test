
# AWS Provider 설정

terraform {
    required_version = ">= 1.3.0"

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
    shared_credentials_files = ["~/.aws/credentials"]
    profile = var.aws_profile

    # ~/.aws/credentials 구조:
    # [default]
    # aws_access_key_id = YOUR_ACCESS_KEY
    # aws_secret_access_key = YOUR_SECRET_KEY
}

# 테라폼이 aws와 통신하기 위해 필요한 블록
# shared_credentials_files는 로컬 PC에 존재하는 AWS 계정 정보를 사용
# IAM 키를 하드코딩하지 않도록 안전한 방식
