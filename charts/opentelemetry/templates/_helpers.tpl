{{/* Configures OpenTelemetry environment variables */}}
{{- define "opentelemetry.environment" -}}
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
{{- end -}}

{{/* Converts a map to a comma-separated list of key=value pairs */}}
{{- define "otel.kvcsv" -}}
{{- $list := list -}}
{{- range $k, $v := . -}}
  {{- $list = append $list (printf "%s=%s" $k $v) -}}
{{- end -}}
{{ join "," $list -}}
{{- end -}}