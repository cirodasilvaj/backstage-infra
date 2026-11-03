resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "fluentd" {
  name            = "fluentd"
  repository      = "https://fluent.github.io/helm-charts"
  chart           = "fluentd"
  version         = var.chart_version
  namespace       = kubernetes_namespace.logging.metadata[0].name
  wait            = false
  cleanup_on_fail = true
  force_update    = true

  # Ship container logs (Apps, SonarQube, ArgoCD, Backstage) and direct
  # Fluentd Forward TCP/UDP (port 24224) logs into Grafana Loki.
  values = [
    yamlencode({
      plugins = [
        "fluent-plugin-grafana-loki",
      ]
      service = {
        enabled = true
        type    = "ClusterIP"
        ports = [
          {
            name          = "forward"
            protocol      = "TCP"
            containerPort = 24224
          },
        ]
      }
      fileConfigs = {
        "01_sources.conf" = <<-EOT
          <source>
            @type tail
            @id in_tail_container_logs
            path /var/log/containers/*.log
            pos_file /var/log/fluentd-containers.log.pos
            tag kubernetes.*
            read_from_head true
            <parse>
              @type multi_format
              <pattern>
                format json
                time_key time
                time_type string
                time_format %Y-%m-%dT%H:%M:%S.%NZ
                keep_time_key false
              </pattern>
              <pattern>
                format /^(?<time>.+) (?<stream>stdout|stderr) [^ ]* (?<log>.*)$/
                time_format %Y-%m-%dT%H:%M:%S.%N%:z
              </pattern>
            </parse>
          </source>

          <source>
            @type forward
            @id in_forward_apps
            port 24224
            bind 0.0.0.0
          </source>
        EOT
        "04_outputs.conf" = <<-EOT
          <label @OUTPUT>
            <match **>
              @type copy
              <store>
                @type loki
                url "http://loki.grafana.svc.cluster.local:3100"
                extra_labels {"job":"fluentd","collector":"fluentd-daemonset"}
                flush_interval 5s
                flush_at_shutdown true
                buffer_chunk_limit 1m
                <label>
                  stream
                  namespace $.kubernetes.namespace_name
                  pod $.kubernetes.pod_name
                  container $.kubernetes.container_name
                  app $.app
                </label>
              </store>
              <store>
                @type stdout
              </store>
            </match>
          </label>
          <match **>
            @type relabel
            @label @OUTPUT
          </match>
        EOT
      }
    })
  ]
}
