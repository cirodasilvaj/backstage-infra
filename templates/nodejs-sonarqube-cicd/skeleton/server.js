const http = require('node:http');
const os = require('node:os');

const PORT = Number(process.env.PORT || 8080);
const APP_NAME = process.env.APP_NAME || '${{ values.component_id }}';
const FLUENTD_HOST = process.env.FLUENTD_HOST || 'fluentd.logging.svc.cluster.local';
const FLUENTD_PORT = process.env.FLUENTD_PORT || '24224';
const START_TIME = Date.now();

const metricsCounters = {
  '/': 0,
  '/api/info': 0,
  '/healthz': 0,
  '/metrics': 0,
};

function getClientIp(req) {
  const forwarded = req.headers['x-forwarded-for'];
  if (typeof forwarded === 'string' && forwarded.trim().length > 0) {
    return forwarded.split(',')[0].trim();
  }
  const realIp = req.headers['x-real-ip'];
  if (typeof realIp === 'string' && realIp.trim().length > 0) {
    return realIp.trim();
  }
  return req.socket?.remoteAddress || 'unknown';
}

function emitFluentdLog(event, path, clientIp) {
  const record = {
    time: new Date().toISOString(),
    app: APP_NAME,
    language: 'Node.js (JavaScript)',
    event,
    path,
    client_ip: clientIp,
    hostname: os.hostname(),
    fluentd_target: `${FLUENTD_HOST}:${FLUENTD_PORT}`,
  };
  process.stdout.write(`${JSON.stringify(record)}\n`);
}

function createServer() {
  return http.createServer((req, res) => {
    const urlPath = (req.url || '/').split('?')[0];
    const clientIp = getClientIp(req);

    if (urlPath === '/healthz') {
      metricsCounters['/healthz'] += 1;
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'ok', language: 'Node.js', hostname: os.hostname() }));
      return;
    }

    if (urlPath === '/metrics') {
      metricsCounters['/metrics'] += 1;
      const uptime = ((Date.now() - START_TIME) / 1000).toFixed(2);
      const lines = [
        '# HELP app_http_requests_total Total HTTP requests handled by the application',
        '# TYPE app_http_requests_total counter',
        `app_http_requests_total{app="${APP_NAME}",language="NodeJS",endpoint="/"} ${metricsCounters['/']}`,
        `app_http_requests_total{app="${APP_NAME}",language="NodeJS",endpoint="/api/info"} ${metricsCounters['/api/info']}`,
        `app_http_requests_total{app="${APP_NAME}",language="NodeJS",endpoint="/healthz"} ${metricsCounters['/healthz']}`,
        `app_http_requests_total{app="${APP_NAME}",language="NodeJS",endpoint="/metrics"} ${metricsCounters['/metrics']}`,
        '# HELP app_uptime_seconds Application uptime in seconds',
        '# TYPE app_uptime_seconds gauge',
        `app_uptime_seconds{app="${APP_NAME}",language="NodeJS"} ${uptime}`,
        '',
      ];
      res.writeHead(200, { 'Content-Type': 'text/plain; version=0.0.4' });
      res.end(lines.join('\n'));
      return;
    }

    if (urlPath === '/api/info' || urlPath === '/') {
      metricsCounters[urlPath === '/api/info' ? '/api/info' : '/'] += 1;
      emitFluentdLog(urlPath === '/api/info' ? 'api_info_request' : 'index_request', urlPath, clientIp);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(
        JSON.stringify({
          service: APP_NAME,
          language: 'Node.js (JavaScript)',
          version: `Node.js ${process.version} (V8 ${process.versions.v8})`,
          client_ip: clientIp,
          hostname: os.hostname(),
          fluentd_target: `${FLUENTD_HOST}:${FLUENTD_PORT}`,
          timestamp_utc: new Date().toISOString(),
        })
      );
      return;
    }

    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not Found' }));
  });
}

if (require.main === module) {
  const server = createServer();
  server.listen(PORT, '0.0.0.0', () => {
    emitFluentdLog('server_started', '/', '127.0.0.1');
  });
}

module.exports = { createServer };
