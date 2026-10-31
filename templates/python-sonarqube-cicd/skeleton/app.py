import os
import platform
import socket
from datetime import datetime, timezone
from flask import Flask, jsonify, request

app = Flask(__name__)


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
    return jsonify({"status": "ok"}), 200


@app.route("/api/info")
def api_info():
    return jsonify(
        {
            "language": "Python",
            "version": platform.python_version(),
            "client_ip": get_client_ip(),
            "hostname": socket.gethostname(),
            "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        }
    )


@app.route("/")
def index():
    info = {
        "language": "Python",
        "version": platform.python_version(),
        "client_ip": get_client_ip(),
        "hostname": socket.gethostname(),
    }
    return jsonify(info), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
