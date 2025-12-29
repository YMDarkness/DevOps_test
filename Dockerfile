# 예시: 기존 Dockerfile 수정 가이드
FROM python:3.10-slim

WORKDIR /app

# 현재 폴더의 모든 파일을 컨테이너의 /app으로 복사
COPY . .

# PYTHONPATH 설정: /app/app 폴더를 모듈 경로에 추가
ENV PYTHONPATH="${PYTHONPATH}:/app/app"

RUN pip install --no-cache-dir -r requirements.txt

# 실행 시 경로를 app/ 폴더 내부 파일로 지정
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.market_index_monitoring:app"]
