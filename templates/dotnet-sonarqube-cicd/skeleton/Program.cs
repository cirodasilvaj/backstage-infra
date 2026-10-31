using System.Net;
using System.Runtime.InteropServices;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

static string GetClientIp(HttpContext context)
{
    if (context.Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor) &&
        !string.IsNullOrWhiteSpace(forwardedFor))
    {
        return forwardedFor.ToString().Split(',')[0].Trim();
    }
    return context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
}

app.MapGet("/healthz", () => Results.Ok(new { status = "ok" }));

app.MapGet("/api/info", (HttpContext context) => Results.Ok(new
{
    language = "C# (.NET)",
    version = RuntimeInformation.FrameworkDescription,
    client_ip = GetClientIp(context),
    hostname = Dns.GetHostName(),
    timestamp_utc = DateTime.UtcNow.ToString("O")
}));

app.Run();
