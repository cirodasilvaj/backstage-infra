using System.Net;
using System.Runtime.InteropServices;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var startTime = DateTime.UtcNow;
var appName = Environment.GetEnvironmentVariable("APP_NAME") ?? "dotnet-csharp-demo-app";
var fluentdHost = Environment.GetEnvironmentVariable("FLUENTD_HOST") ?? "fluentd.logging.svc.cluster.local";
var fluentdPort = Environment.GetEnvironmentVariable("FLUENTD_PORT") ?? "24224";

long requestsRoot = 0;
long requestsApiInfo = 0;
long requestsHealthz = 0;
long requestsMetrics = 0;

void EmitFluentdLog(string eventName, string path, string clientIp)
{
    var logRecord = new
    {
        time = DateTime.UtcNow.ToString("O"),
        app = appName,
        language = "C# (.NET)",
        @event = eventName,
        path,
        client_ip = clientIp,
        hostname = Dns.GetHostName(),
        fluentd_target = $"{fluentdHost}:{fluentdPort}"
    };
    Console.WriteLine(JsonSerializer.Serialize(logRecord));
}

static string GetClientIp(HttpContext context)
{
    if (context.Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor) &&
        !string.IsNullOrWhiteSpace(forwardedFor))
    {
        return forwardedFor.ToString().Split(',')[0].Trim();
    }
    return context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
}

app.MapGet("/healthz", () =>
{
    Interlocked.Increment(ref requestsHealthz);
    return Results.Ok(new { status = "ok" });
});

app.MapGet("/metrics", () =>
{
    Interlocked.Increment(ref requestsMetrics);
    var uptime = (DateTime.UtcNow - startTime).TotalSeconds;
    var body = string.Join("\n", new[]
    {
        "# HELP app_http_requests_total Total HTTP requests handled by the application",
        "# TYPE app_http_requests_total counter",
        $"app_http_requests_total{{app=\"{appName}\",language=\"CSharp\",endpoint=\"/\"}} {Interlocked.Read(ref requestsRoot)}",
        $"app_http_requests_total{{app=\"{appName}\",language=\"CSharp\",endpoint=\"/api/info\"}} {Interlocked.Read(ref requestsApiInfo)}",
        $"app_http_requests_total{{app=\"{appName}\",language=\"CSharp\",endpoint=\"/healthz\"}} {Interlocked.Read(ref requestsHealthz)}",
        $"app_http_requests_total{{app=\"{appName}\",language=\"CSharp\",endpoint=\"/metrics\"}} {Interlocked.Read(ref requestsMetrics)}",
        "# HELP app_uptime_seconds Application uptime in seconds",
        "# TYPE app_uptime_seconds gauge",
        $"app_uptime_seconds{{app=\"{appName}\",language=\"CSharp\"}} {uptime:F2}",
        ""
    });
    return Results.Text(body, "text/plain; version=0.0.4");
});

app.MapGet("/api/info", (HttpContext context) =>
{
    Interlocked.Increment(ref requestsApiInfo);
    var clientIp = GetClientIp(context);
    EmitFluentdLog("api_info_request", "/api/info", clientIp);
    return Results.Ok(new
    {
        language = "C# (.NET)",
        version = RuntimeInformation.FrameworkDescription,
        client_ip = clientIp,
        hostname = Dns.GetHostName(),
        fluentd_target = $"{fluentdHost}:{fluentdPort}",
        timestamp_utc = DateTime.UtcNow.ToString("O")
    });
});

app.MapGet("/", (HttpContext context) =>
{
    Interlocked.Increment(ref requestsRoot);
    var clientIp = GetClientIp(context);
    EmitFluentdLog("index_request", "/", clientIp);
    return Results.Ok(new
    {
        language = "C# (.NET)",
        version = RuntimeInformation.FrameworkDescription,
        client_ip = clientIp,
        hostname = Dns.GetHostName(),
        timestamp_utc = DateTime.UtcNow.ToString("O")
    });
});

app.Run();
