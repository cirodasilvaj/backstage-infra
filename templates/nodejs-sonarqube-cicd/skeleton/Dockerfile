FROM node:20-alpine

LABEL org.opencontainers.image.source="https://github.com/${{ values.destinationOwner }}/${{ values.component_id }}"

WORKDIR /app
COPY package.json server.js ./

ENV PORT=8080 \
    APP_NAME="${{ values.component_id }}" \
    FLUENTD_HOST="fluentd.logging.svc.cluster.local" \
    FLUENTD_PORT="24224"

EXPOSE 8080
CMD ["node", "server.js"]
