const test = require('node:test');
const assert = require('node:assert/strict');
const { createServer } = require('./server');

test('Node.js microservice exposes /healthz, /api/info and Prometheus /metrics', async () => {
  const server = createServer();
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const { port } = server.address();

  try {
    const healthRes = await fetch(`http://127.0.0.1:${port}/healthz`);
    assert.equal(healthRes.status, 200);
    const healthJson = await healthRes.json();
    assert.equal(healthJson.status, 'ok');

    const infoRes = await fetch(`http://127.0.0.1:${port}/api/info`, {
      headers: { 'X-Forwarded-For': '203.0.113.55' },
    });
    assert.equal(infoRes.status, 200);
    const infoJson = await infoRes.json();
    assert.equal(infoJson.language, 'Node.js (JavaScript)');
    assert.equal(infoJson.client_ip, '203.0.113.55');

    const metricsRes = await fetch(`http://127.0.0.1:${port}/metrics`);
    assert.equal(metricsRes.status, 200);
    const metricsText = await metricsRes.text();
    assert.match(metricsText, /app_http_requests_total/);
  } finally {
    server.close();
  }
});
