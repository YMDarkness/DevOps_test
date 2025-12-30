# 1. 20GB 용량의 메인 서버 정의
resource "aws_instance" "market_server" {
  ami           = data.aws_ami.ubuntu.id # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = var.key_name # 기존에 사용하던 키 페어 이름

  vpc_security_group_ids = [aws_security_group.market_index_5g.id]

  root_block_device {
    volume_size = 20    # 20GB로 설정
    volume_type = "gp3"
  }

  tags = {
    Name = "DevOps-Market-Index-Server"
  }
}

# 2. 탄력적 IP(EIP)를 이 서버에 연결
resource "aws_eip_association" "market_eip_assoc" {
  instance_id   = aws_instance.market_server.id
  allocation_id = aws_eip.market_eip.id
}
