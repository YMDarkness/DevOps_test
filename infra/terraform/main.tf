
# 본체 / 인프라의 전체 구조 결정

# VPC
# 기본 VPC 사용
data "aws_vpc" "default" {
  default = true
}

# Security Groups

resource "aws_security_group" "market_index_5g" {
  name = "${var.project_name}_sg"
  description = "Security group for market index Monitoring"
  vpc_id = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Grafana

  # Nginx (805, 447)
  ingress {
    from_port = 805
    to_port = 805
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 447
    to_port = 447
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus (9090)

  # Exporter (8000~9000)

  # egress (아웃바운드 전체 허용)
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 최신 우분투 AMI 자동 검색

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["self"] # 내 계정에서 생성한 이미지 중에서 찾음

    filter {
        name = "name"
        values = ["docker-server-image-*"] # Packer에서 설정한 이름 패턴
    }
}

# EC2 인스턴스 생성

# Elastic IP 할당 및 연결

resource "aws_eip" "market_eip" {
  instance = aws_instance.market_server.id
  #vpc = true
}

output "server_ip" {
  value = aws_eip.market_eip.public_ip
}
