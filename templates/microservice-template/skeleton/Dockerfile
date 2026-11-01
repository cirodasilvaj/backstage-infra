FROM python:3.12-slim

LABEL org.opencontainers.image.source="https://github.com/${{ values.destinationOwner }}/${{ values.component_id }}"

WORKDIR /app
RUN pip install --no-cache-dir Flask==3.0.3 gunicorn==23.0.0

COPY app.py ./

ENV PORT=8080 \
    APP_NAME="${{ values.component_id }}" \
    FLUENTD_HOST="fluentd.logging.svc.cluster.local" \
    FLUENTD_PORT="24224"

EXPOSE 8080
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app:app"]
