FROM python:3.10-slim
WORKDIR /app/app

# 의존성 설치를 위한 시스템 라이브러리 업데이트
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# requirements.txt 복사
COPY requirements.txt /app/

# 패키지 설치
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# 모든 파일 복사
COPY . /app

# [중요] PYTHONPATH 설정
# /app/app과 site-packages를 모두 포함하여 모든 모듈 탐색 가능
ENV PYTHONPATH=/app/app:/usr/local/lib/python3.10/site-packages

# gunicorn 실행
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout", "180", "--workers", "1", "exporter:app"]
