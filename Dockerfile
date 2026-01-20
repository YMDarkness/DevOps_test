FROM python:3.10-slim
WORKDIR /app

# 모든 파일 복사
COPY . .

# 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install prometheus_client

# [중요] 모든 가능성 있는 경로를 PYTHONPATH에 추가
# /app 폴더와 /app/app 폴더를 모두 탐색 범위에 넣습니다.
ENV PYTHONPATH="/app"

# [수정] 'app.'을 제거하고 파일명:변수명으로 호출
# 파이썬이 PYTHONPATH에서 market_index_monitoring.py를 자동으로 찾아냅니다.
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "market_index_monitoring:app"]
