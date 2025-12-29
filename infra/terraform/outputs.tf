
# 생성된 EC2 인스턴스의 퍼블릭 IP 출력 (Elastic IP 포함)

output "server_public_ip" {
  description = "Public IP address of the Server"
  value = aws_eip.market_eip.public_ip
}

# EC2 인스턴스 ID
output "server_instance_id" {
  description = "EC2 Instance ID"
  value = aws_instance.market_server.id
}

# EC2 퍼블릭 DNS
output "server_public_dns" {
  description = "Public DNS of the Server"
  value = aws_instance.market_server.public_dns
}

# 그라파나 URL (3000 포트)
output "grafana_url" {
  description = "Grafana Web UI"
  value = "http://${aws_eip.market_eip.public_ip}:3000"
}

# 프로메테우스 URL (9090 포트)
output "prometheus_url" {
  description = "Prometheus Web UI"
  value = "http://${aws_eip.market_eip.public_ip}:9090"
}
