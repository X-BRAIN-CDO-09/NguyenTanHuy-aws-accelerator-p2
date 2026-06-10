from flask import Flask, Response, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time


app = Flask(__name__)

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "endpoint", "status"],
)
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["endpoint"],
)


@app.before_request
def start_timer():
    from flask import request

    request.start_time = time.time()


@app.after_request
def record_metrics(response):
    from flask import request

    endpoint = request.path
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=endpoint,
        status=response.status_code,
    ).inc()
    if hasattr(request, "start_time"):
        REQUEST_LATENCY.labels(endpoint=endpoint).observe(time.time() - request.start_time)
    return response


@app.get("/")
def index():
    return jsonify(message="BudgetBot W9 Demo v1")


@app.get("/health")
def health():
    return jsonify(status="healthy")


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
