#!/bin/bash
# 1. 로그 리다이렉션 (에러 확인용)
exec > /var/log/user-data.log 2>&1
set -x

# 2. 비대화형 모드 설정
export DEBIAN_FRONTEND=noninteractive

# 3. 부팅 직후 Apt 잠금 대기 (매우 중요: 이게 없으면 종종 실패함)
echo "Checking for apt locks..."
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Waiting for apt lock to be released..."
    sleep 5
done

# 4. 필수 유틸리티 설치
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release git

# 5. Docker 공식 GPG 키 등록
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 6. Docker 공식 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 7. 패키지 목록 갱신 후 설치 (이제 docker-compose-plugin을 찾을 수 있음)
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 8. Docker 실행 및 권한 설정
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

echo "User Data Script Finished Successfully!"

