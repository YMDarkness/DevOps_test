FROM python:3.10-slim

# 작업 디렉토리 설정
WORKDIR /app/app

# 현재 폴더의 모든 파일을 컨테이너의 /app으로 복사
COPY . .

# 의존성 파일 설치 (이 단계가 누락되었거나 에러가 났을 수 있습니다)
RUN pip install --no-cache-dir -r requirements.txt

# PYTHONPATH 설정: /app 폴더를 추가하여 app/ 폴더 내의 모듈을 찾을 수 있게 함
ENV PYTHONPATH="/app"

# 실행 명령 (파일 구조가 /app/app/market_index_monitoring.py 인 경우)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.market_index_monitoring:app"]
