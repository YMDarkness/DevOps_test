from flask import Flask, Response, jsonify, request
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST, Counter, Histogram
import time

# 모듈 임포트
from modules.market_collector import MarketCollector
from modules.gold_collector import GoldCollector
from modules.kospi_collector import KospiCollector
from modules.dji_collector import DJICollector
from modules.n225_collector import N225Collector
from modules.ixic_collector import IXICCollector
from modules.sp_collector import SpCollector
from modules.wti_collector import WTICollector
from modules.gasoline_collector import GasolineCollector

app = Flask(__name__)

# Prometheus 메트릭 정의
REQUEST_COUNT = Counter(
    'flask_app_request_total', 'Total number of requests', ['method', 'endpoint']
)
REQUEST_LATENCY = Histogram(
    'flask_app_request_latency_seconds', 'Request latency', ['endpoint']
)

@app.before_request
def before_request_func():
    app.start_time = time.time()

@app.after_request
def after_request_func(response):
    # /metrics 요청은 모니터링 제외
    if request.path != "/metrics":
        latency = time.time() - app.start_time
        REQUEST_COUNT.labels(method=request.method, endpoint=request.path).inc()
        REQUEST_LATENCY.labels(endpoint=request.path).observe(latency)
    return response

@app.route('/')
def index():
    return 'market index exporter is running. Check /metrics for Prometheus data.'

@app.route("/metrics")
def metrics():
    # Prometheus 기본 메트릭 포함
    output = generate_latest()

    # 사용자 정의 수집기 실행
    collectors = [
        MarketCollector(), GoldCollector(), KospiCollector(),
        DJICollector(), N225Collector(), IXICCollector(),
        SpCollector(), WTICollector(), GasolineCollector()
    ]

    try:
        for c in collectors:
            print(f'[DEBUG] running : {c.__class__.__name__}', flush=True)
            c.fetch()
            c.parse()
            output += c.to_prometheus_format().encode('utf-8')
    except Exception as e:
        import traceback
        print('/metrics error : ', traceback.format_exc(), flush=True)
        return Response('Internal Server Error', status=500)

    return Response(output, mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

    '''
@app.route("/news")
def news():
    news_collector = NewsCollector()
    output = ""
    try:
        print(f'[DEBUG] running : {news_collector.__class__.__name__}', flush=True)
        news_collector.fetch()
        news_collector.parse()
        output = news_collector.data
    except Exception as e:
        import traceback
        print('/metrics error : ', traceback.format_exc(), flush=True)
        return jsonify({'error' : 'Interval Server Error'}), 500
    return jsonify(output)
    '''    

    '''
    jsonify
    Flask에서 딕셔너리 데이터를 JSON 응답으로 변환해주는 함수
    브라우저나 API 클라이언트가 이해할 수 있는 JSON 포맷으로 결과를 반환
    '''
