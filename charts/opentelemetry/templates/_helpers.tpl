{{/* Configures OpenTelemetry environment variables */}}
{{- define "opentelemetry.environment" -}}
{{- if .Values.opentelemetry -}}
{{- if .Values.opentelemetry.disabled }}
- name: OTEL_SDK_DISABLED
  value: {{ .Values.opentelemetry.disabled | quote }}
{{- end }}
{{- if .Values.opentelemetry.entities }}
- name: OTEL_ENTITIES
  value: {{ join "," .Values.opentelemetry.entities | quote }}
{{- end }}
{{- if .Values.opentelemetry.resourceAttributes }}
- name: OTEL_RESOURCE_ATTRIBUTES
  value: {{ include "otel.kvcsv" .Values.opentelemetry.resourceAttributes | quote }}
{{- end }}
{{- if .Values.opentelemetry.serviceName }}
- name: OTEL_SERVICE_NAME
  value: {{ .Values.opentelemetry.serviceName | quote }}
{{- end }}
{{- if .Values.opentelemetry.logLevel }}
- name: OTEL_LOG_LEVEL
  value: {{ .Values.opentelemetry.logLevel | quote }}
{{- end }}
{{- if .Values.opentelemetry.propagators }}
- name: OTEL_PROPAGATORS
  value: {{ join "," .Values.opentelemetry.propagators | quote }}
{{- end }}
{{- if .Values.opentelemetry.tracesSampler }}
- name: OTEL_TRACES_SAMPLER
  value: {{ .Values.opentelemetry.tracesSampler | quote }}
{{- end }}
{{- if .Values.opentelemetry.tracesSamplerArg }}
- name: OTEL_TRACES_SAMPLER_ARG
  value: {{ .Values.opentelemetry.tracesSamplerArg | quote }}
{{- end }}
{{- if .Values.opentelemetry.bsp -}}
{{- if and .Values.opentelemetry.bsp.scheduleDelay (gt (.Values.opentelemetry.bsp.scheduleDelay | int) 0) }}
- name: OTEL_BSP_SCHEDULE_DELAY
  value: {{ .Values.opentelemetry.bsp.scheduleDelay | quote }}
{{- end }}
{{- if and .Values.opentelemetry.bsp.exportTimeout (gt (.Values.opentelemetry.bsp.exportTimeout | int) 0) }}
- name: OTEL_BSP_EXPORT_TIMEOUT
  value: {{ .Values.opentelemetry.bsp.exportTimeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.bsp.maxQueueSize (gt (.Values.opentelemetry.bsp.maxQueueSize | int) 0) }}
- name: OTEL_BSP_MAX_QUEUE_SIZE
  value: {{ .Values.opentelemetry.bsp.maxQueueSize | quote }}
{{- end }}
{{- if and .Values.opentelemetry.bsp.maxExportBatchSize (gt (.Values.opentelemetry.bsp.maxExportBatchSize | int) 0) }}
- name: OTEL_BSP_MAX_EXPORT_BATCH_SIZE
  value: {{ .Values.opentelemetry.bsp.maxExportBatchSize | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.blrp -}}
{{- if and .Values.opentelemetry.blrp.scheduleDelay (gt (.Values.opentelemetry.blrp.scheduleDelay | int) 0) }}
- name: OTEL_BLRP_SCHEDULE_DELAY
  value: {{ .Values.opentelemetry.blrp.scheduleDelay | quote }}
{{- end }}
{{- if and .Values.opentelemetry.blrp.exportTimeout (gt (.Values.opentelemetry.blrp.exportTimeout | int) 0) }}
- name: OTEL_BLRP_EXPORT_TIMEOUT
  value: {{ .Values.opentelemetry.blrp.exportTimeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.blrp.maxQueueSize (gt (.Values.opentelemetry.blrp.maxQueueSize | int) 0) }}
- name: OTEL_BLRP_MAX_QUEUE_SIZE
  value: {{ .Values.opentelemetry.blrp.maxQueueSize | quote }}
{{- end }}
{{- if and .Values.opentelemetry.blrp.maxExportBatchSize (gt (.Values.opentelemetry.blrp.maxExportBatchSize | int) 0) }}
- name: OTEL_BLRP_MAX_EXPORT_BATCH_SIZE
  value: {{ .Values.opentelemetry.blrp.maxExportBatchSize | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.attribute -}}
{{- if and .Values.opentelemetry.attribute.valueLengthLimit (gt (.Values.opentelemetry.attribute.valueLengthLimit | int) 0) }}
- name: OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT
  value: {{ .Values.opentelemetry.attribute.valueLengthLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.attribute.countLimit (gt (.Values.opentelemetry.attribute.countLimit | int) 0) }}
- name: OTEL_ATTRIBUTE_COUNT_LIMIT
  value: {{ .Values.opentelemetry.attribute.countLimit | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.span -}}
{{- if and .Values.opentelemetry.span.attributeValueLengthLimit (gt (.Values.opentelemetry.span.attributeValueLengthLimit | int) 0) }}
- name: OTEL_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT
  value: {{ .Values.opentelemetry.span.attributeValueLengthLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.span.attributeCountLimit (gt (.Values.opentelemetry.span.attributeCountLimit | int) 0) }}
- name: OTEL_SPAN_ATTRIBUTE_COUNT_LIMIT
  value: {{ .Values.opentelemetry.span.attributeCountLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.span.eventCountLimit (gt (.Values.opentelemetry.span.eventCountLimit | int) 0) }}
- name: OTEL_SPAN_EVENT_COUNT_LIMIT
  value: {{ .Values.opentelemetry.span.eventCountLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.span.linkCountLimit (gt (.Values.opentelemetry.span.linkCountLimit | int) 0) }}
- name: OTEL_SPAN_LINK_COUNT_LIMIT
  value: {{ .Values.opentelemetry.span.linkCountLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.span.eventAttributeCountLimit (gt (.Values.opentelemetry.span.eventAttributeCountLimit | int) 0) }}
- name: OTEL_SPAN_EVENT_ATTRIBUTE_COUNT_LIMIT
  value: {{ .Values.opentelemetry.span.eventAttributeCountLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.span.linkAttributeCountLimit (gt (.Values.opentelemetry.span.linkAttributeCountLimit | int) 0) }}
- name: OTEL_SPAN_LINK_ATTRIBUTE_COUNT_LIMIT
  value: {{ .Values.opentelemetry.span.linkAttributeCountLimit | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.log -}}
{{- if and .Values.opentelemetry.log.attributeValueLengthLimit (gt (.Values.opentelemetry.log.attributeValueLengthLimit | int) 0) }}
- name: OTEL_LOGRECORD_ATTRIBUTE_VALUE_LENGTH_LIMIT
  value: {{ .Values.opentelemetry.log.attributeValueLengthLimit | quote }}
{{- end }}
{{- if and .Values.opentelemetry.log.attributeCountLimit (gt (.Values.opentelemetry.log.attributeCountLimit | int) 0) }}
- name: OTEL_LOGRECORD_ATTRIBUTE_COUNT_LIMIT
  value: {{ .Values.opentelemetry.log.attributeCountLimit | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.exporter -}}
{{- if .Values.opentelemetry.exporter.traces }}
- name: OTEL_TRACES_EXPORTER
  value: {{ .Values.opentelemetry.exporter.traces | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.metrics }}
- name: OTEL_METRICS_EXPORTER
  value: {{ .Values.opentelemetry.exporter.metrics | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.logs }}
- name: OTEL_LOGS_EXPORTER
  value: {{ .Values.opentelemetry.exporter.logs | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp -}}
{{- if .Values.opentelemetry.exporter.otlp.endpoint }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.otlp.endpoint | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.tracesEndpoint }}
- name: OTEL_EXPORTER_OTLP_TRACES_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.otlp.tracesEndpoint | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.metricsEndpoint }}
- name: OTEL_EXPORTER_OTLP_METRICS_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.otlp.metricsEndpoint | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.logsEndpoint }}
- name: OTEL_EXPORTER_OTLP_LOGS_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.otlp.logsEndpoint | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.profilesEndpoint }}
- name: OTEL_EXPORTER_OTLP_PROFILES_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.otlp.profilesEndpoint | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.headers }}
- name: OTEL_EXPORTER_OTLP_HEADERS
  value: {{ include "otel.kvcsv" .Values.opentelemetry.exporter.otlp.headers | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.tracesHeaders }}
- name: OTEL_EXPORTER_OTLP_TRACES_HEADERS
  value: {{ include "otel.kvcsv" .Values.opentelemetry.exporter.otlp.tracesHeaders | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.metricsHeaders }}
- name: OTEL_EXPORTER_OTLP_METRICS_HEADERS
  value: {{ include "otel.kvcsv" .Values.opentelemetry.exporter.otlp.metricsHeaders | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.logsHeaders }}
- name: OTEL_EXPORTER_OTLP_LOGS_HEADERS
  value: {{ include "otel.kvcsv" .Values.opentelemetry.exporter.otlp.logsHeaders | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.profilesHeaders }}
- name: OTEL_EXPORTER_OTLP_PROFILES_HEADERS
  value: {{ include "otel.kvcsv" .Values.opentelemetry.exporter.otlp.profilesHeaders | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.otlp.timeout (gt (.Values.opentelemetry.exporter.otlp.timeout | int) 0) }}
- name: OTEL_EXPORTER_OTLP_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.otlp.timeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.otlp.tracesTimeout (gt (.Values.opentelemetry.exporter.otlp.tracesTimeout | int) 0) }}
- name: OTEL_EXPORTER_OTLP_TRACES_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.otlp.tracesTimeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.otlp.metricsTimeout (gt (.Values.opentelemetry.exporter.otlp.metricsTimeout | int) 0) }}
- name: OTEL_EXPORTER_OTLP_METRICS_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.otlp.metricsTimeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.otlp.logsTimeout (gt (.Values.opentelemetry.exporter.otlp.logsTimeout | int) 0) }}
- name: OTEL_EXPORTER_OTLP_LOGS_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.otlp.logsTimeout | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.otlp.profilesTimeout (gt (.Values.opentelemetry.exporter.otlp.profilesTimeout | int) 0) }}
- name: OTEL_EXPORTER_OTLP_PROFILES_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.otlp.profilesTimeout | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.protocol }}
- name: OTEL_EXPORTER_OTLP_PROTOCOL
  value: {{ .Values.opentelemetry.exporter.otlp.protocol | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.tracesProtocol }}
- name: OTEL_EXPORTER_OTLP_TRACES_PROTOCOL
  value: {{ .Values.opentelemetry.exporter.otlp.tracesProtocol | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.metricsProtocol }}
- name: OTEL_EXPORTER_OTLP_METRICS_PROTOCOL
  value: {{ .Values.opentelemetry.exporter.otlp.metricsProtocol | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.logsProtocol }}
- name: OTEL_EXPORTER_OTLP_LOGS_PROTOCOL
  value: {{ .Values.opentelemetry.exporter.otlp.logsProtocol | quote }}
{{- end }}
{{- if .Values.opentelemetry.exporter.otlp.profilesProtocol }}
- name: OTEL_EXPORTER_OTLP_PROFILES_PROTOCOL
  value: {{ .Values.opentelemetry.exporter.otlp.profilesProtocol | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.exporter.zipkin -}}
{{- if .Values.opentelemetry.exporter.zipkin.endpoint }}
- name: OTEL_EXPORTER_ZIPKIN_ENDPOINT
  value: {{ .Values.opentelemetry.exporter.zipkin.endpoint | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.zipkin.timeout (gt (.Values.opentelemetry.exporter.zipkin.timeout | int) 0) }}
- name: OTEL_EXPORTER_ZIPKIN_TIMEOUT
  value: {{ .Values.opentelemetry.exporter.zipkin.timeout | quote }}
{{- end }}
{{- end -}}
{{- if .Values.opentelemetry.exporter.prometheus -}}
{{- if .Values.opentelemetry.exporter.prometheus.host }}
- name: OTEL_EXPORTER_PROMETHEUS_HOST
  value: {{ .Values.opentelemetry.exporter.prometheus.host | quote }}
{{- end }}
{{- if and .Values.opentelemetry.exporter.prometheus.port (gt (.Values.opentelemetry.exporter.prometheus.port | int) 0) }}
- name: OTEL_EXPORTER_PROMETHEUS_PORT
  value: {{ .Values.opentelemetry.exporter.prometheus.port | quote }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Converts a map to a comma-separated list of key=value pairs */}}
{{- define "otel.kvcsv" -}}
{{- $list := list -}}
{{- range $k, $v := . -}}
  {{- $list = append $list (printf "%s=%s" $k $v) -}}
{{- end -}}
{{ join "," $list -}}
{{- end -}}