package com.demo;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@SpringBootApplication
@RestController
public class Application {

    private static final long START_TIME_MS = System.currentTimeMillis();
    private static final String APP_NAME = System.getenv().getOrDefault("APP_NAME", "${{ values.component_id }}");
    private static final String FLUENTD_HOST = System.getenv().getOrDefault("FLUENTD_HOST", "fluentd.logging.svc.cluster.local");
    private static final String FLUENTD_PORT = System.getenv().getOrDefault("FLUENTD_PORT", "24224");

    private final AtomicLong reqRoot = new AtomicLong(0);
    private final AtomicLong reqApiInfo = new AtomicLong(0);
    private final AtomicLong reqHealthz = new AtomicLong(0);
    private final AtomicLong reqMetrics = new AtomicLong(0);

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    private String getClientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }
        return request.getRemoteAddr();
    }

    private String getHostname() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (Exception e) {
            return "unknown-host";
        }
    }

    private void emitFluentdLog(String event, String path, String clientIp) {
        String json = String.format(
            "{\"time\":\"%s\",\"app\":\"%s\",\"language\":\"Java (JVM Spring Boot)\",\"event\":\"%s\",\"path\":\"%s\",\"client_ip\":\"%s\",\"hostname\":\"%s\",\"fluentd_target\":\"%s:%s\"}",
            Instant.now().toString(), APP_NAME, event, path, clientIp, getHostname(), FLUENTD_HOST, FLUENTD_PORT
        );
        System.out.println(json);
    }

    @GetMapping("/healthz")
    public Map<String, Object> healthz() {
        reqHealthz.incrementAndGet();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("status", "ok");
        res.put("language", "Java (JVM Spring Boot)");
        res.put("hostname", getHostname());
        return res;
    }

    @GetMapping("/api/info")
    public Map<String, Object> apiInfo(HttpServletRequest request) {
        reqApiInfo.incrementAndGet();
        String clientIp = getClientIp(request);
        emitFluentdLog("api_info_request", "/api/info", clientIp);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("service", APP_NAME);
        res.put("language", "Java (JVM Spring Boot)");
        res.put("version", "Java " + System.getProperty("java.version") + " (" + System.getProperty("java.vm.name") + ")");
        res.put("client_ip", clientIp);
        res.put("hostname", getHostname());
        res.put("fluentd_target", FLUENTD_HOST + ":" + FLUENTD_PORT);
        res.put("timestamp_utc", Instant.now().toString());
        return res;
    }

    @GetMapping("/")
    public Map<String, Object> index(HttpServletRequest request) {
        reqRoot.incrementAndGet();
        String clientIp = getClientIp(request);
        emitFluentdLog("index_request", "/", clientIp);
        return apiInfo(request);
    }

    @GetMapping(value = "/metrics", produces = MediaType.TEXT_PLAIN_VALUE)
    public String metrics() {
        reqMetrics.incrementAndGet();
        double uptime = (System.currentTimeMillis() - START_TIME_MS) / 1000.0;
        return String.join("\n",
            "# HELP app_http_requests_total Total HTTP requests handled by the application",
            "# TYPE app_http_requests_total counter",
            String.format("app_http_requests_total{app=\"%s\",language=\"Java\",endpoint=\"/\"} %d", APP_NAME, reqRoot.get()),
            String.format("app_http_requests_total{app=\"%s\",language=\"Java\",endpoint=\"/api/info\"} %d", APP_NAME, reqApiInfo.get()),
            String.format("app_http_requests_total{app=\"%s\",language=\"Java\",endpoint=\"/healthz\"} %d", APP_NAME, reqHealthz.get()),
            String.format("app_http_requests_total{app=\"%s\",language=\"Java\",endpoint=\"/metrics\"} %d", APP_NAME, reqMetrics.get()),
            "# HELP app_uptime_seconds Application uptime in seconds",
            "# TYPE app_uptime_seconds gauge",
            String.format("app_uptime_seconds{app=\"%s\",language=\"Java\"} %.2f", APP_NAME, uptime),
            ""
        );
    }
}
