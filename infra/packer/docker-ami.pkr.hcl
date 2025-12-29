packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# 1. 어디에(AWS), 어떤 사양으로 만들지 정의
source "amazon-ebs" "docker_ami" {
  ami_name      = "docker-server-image-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "ap-northeast-2"
  
  # 원본이 될 베이스 이미지 (Ubuntu 22.04)
  # 베이스: 작성하신 main.tf의 22.04 필터와 동일
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

# 2. 어떤 작업을 할지 정의 (Provisioning)
build {
  sources = ["source.amazon-ebs.docker_ami"]

  # 작성하신 user-data.sh의 핵심 로직을 그대로 실행
  provisioner "shell" {
    script = "./scripts/install_docker.sh"
  }
}
