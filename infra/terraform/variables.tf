
# 변수 정의

variable "project_name" {
  description = "프로젝트_이름"
  type = string
  default = "devops_test_market_index"
}

variable "aws_region" {
  description = "AWS_region"
  type = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  description = "AWS_CLI_Profile_(로컬 환경)"
  default = "default"
}

variable "instance_type" {
  description = "EC2_타입"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "EC2_Key_Pair_Name"
  type = string
}

variable "allowed_ssh_cidr" {
  description = "SSH_접속_허용_IP"
  type = string
  default = "0.0.0.0/0"
}

variable "docker_user" {
  description = "EC2_접속_유저"
  default = "ubuntu"
}

# 모든 설정값은 이곳에서 관리 -> 시스템 확장에 유리
# key_name만 입력하면 나머지는 기본값으로 충분함
