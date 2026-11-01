import json
import os
import platform
import socket
import sys
import time
from datetime import datetime, timezone
from flask import Flask, Response, jsonify, request

app = Flask(__name__)
START_TIME = time.time()
APP_NAME = os.environ.get("APP_NAME", "${{ values.component_id }}")
FLUENTD_HOST = os.environ.get("FLUENTD_HOST", "fluentd.logging.svc.cluster.local")
FLUENTD_PORT = int(os.environ.get("FLUENTD_PORT", "24224"))

METRICS_COUNTERS = {
    "/": 0,
    "/api/info": 0,
    "/healthz": 0,
    "/metrics": 0,
}


def emit_fluentd_log(event_type: str, payload: dict) -> None:
    """Emit structured JSON log for Fluentd DaemonSet -> Grafana Loki."""
    record = {
        "time": datetime.now(timezone.utc).isoformat(),
        "app": APP_NAME,
        "language": "Python",
        "event": event_type,
        "hostname": socket.gethostname(),
        "fluentd_target": f"{FLUENTD_HOST}:{FLUENTD_PORT}",
        **payload,
    }
    print(json.dumps(record), file=sys.stdout, flush=True)


def get_client_ip() -> str:
    forwarded_for = request.headers.get("X-Forwarded-For", "")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    real_ip = request.headers.get("X-Real-IP", "")
    if real_ip:
        return real_ip.strip()
    return request.remote_addr or "unknown"


@app.route("/healthz")
def healthz():
    METRICS_COUNTERS["/healthz"] += 1
    return jsonify({"status": "ok", "service": APP_NAME}), 200


@app.route("/metrics")
def metrics():
    METRICS_COUNTERS["/metrics"] += 1
    uptime = max(0.0, time.time() - START_TIME)
    lines = [
        "# HELP app_http_requests_total Total HTTP requests handled by the application",
        "# TYPE app_http_requests_total counter",
    ]
    for endpoint, count in METRICS_COUNTERS.items():
        lines.append(
            f'app_http_requests_total{{app="{APP_NAME}",language="Python",endpoint="{endpoint}"}} {count}'
        )
    lines.extend(
        [
            "# HELP app_uptime_seconds Application uptime in seconds",
            "# TYPE app_uptime_seconds gauge",
            f'app_uptime_seconds{{app="{APP_NAME}",language="Python"}} {uptime:.2f}',
        ]
    )
    return Response("\n".join(lines) + "\n", mimetype="text/plain; version=0.0.4")


@app.route("/api/info")
def api_info():
    METRICS_COUNTERS["/api/info"] += 1
    client_ip = get_client_ip()
    emit_fluentd_log("api_info_request", {"path": "/api/info", "client_ip": client_ip})
    return jsonify(
        {
            "service": APP_NAME,
            "language": "Python",
            "version": platform.python_version(),
            "client_ip": client_ip,
            "hostname": socket.gethostname(),
            "fluentd_target": f"{FLUENTD_HOST}:{FLUENTD_PORT}",
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        }
    )


@app.route("/")
def index():
    METRICS_COUNTERS["/"] += 1
    client_ip = get_client_ip()
    emit_fluentd_log("index_request", {"path": "/", "client_ip": client_ip})
    return jsonify(
        {
            "service": APP_NAME,
            "language": "Python",
            "version": platform.python_version(),
            "client_ip": client_ip,
            "hostname": socket.gethostname(),
        }
    ), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
