import socket
from app import app


def test_healthz_endpoint():
    client = app.test_client()
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_prometheus_metrics_endpoint():
    client = app.test_client()
    response = client.get("/metrics")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "app_http_requests_total" in body
    assert "app_uptime_seconds" in body


def test_api_info_returns_language_version_ip_and_hostname():
    client = app.test_client()
    response = client.get("/api/info", headers={"X-Forwarded-For": "203.0.113.42"})
    assert response.status_code == 200
    data = response.get_json()
    assert data["language"] == "Python"
    assert data["client_ip"] == "203.0.113.42"
    assert data["hostname"] == socket.gethostname()
    assert "version" in data
