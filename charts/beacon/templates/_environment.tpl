{{- define "beacon.environment" -}}
env:
  - name: BEACON_MAINTENANCE
    value: {{ .Values.beacon.maintenance | quote }}
  - name: BEACON_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: BEACON_MODE
    value: {{ include "beacon.mode" . }}
  - name: BEACON_LOG_LEVEL
    value: {{ include "beacon.logLevel" . }}
  - name: BEACON_CONSOLE_LOG
    value: {{ include "beacon.consoleLog" . }}
  - name: BEACON_ALLOWED_ORIGINS
    value: {{ include "beacon.allowOrigins" . }}
  - name: BEACON_COMPASS_ENABLED
    value: {{ .Values.beacon.compass.enabled | quote }}
  - name: BEACON_COMPASS_FIXTURES
    value: {{ .Values.storage.fixtures.mountPath | quote }}
  - name: BEACON_TELEMETRY_ENABLED
    value: {{ .Values.beacon.telemetry.enabled | quote }}
  {{- if .Values.beacon.telemetry.serviceAddr }}
  - name: GIMLET_OTEL_SERVICE_ADDR
    value: {{ .Values.beacon.telemetry.serviceAddr | quote }}
  {{- end }}
  {{- if .Values.beacon.auth.authorizedUsers.secretKeyRef }}
  - name: BEACON_AUTH_AUTHORIZED_USERS
    valueFrom:
      secretKeyRef:
        name: {{ .Values.beacon.auth.authorizedUsers.secretKeyRef.name }}
        key: {{ .Values.beacon.auth.authorizedUsers.secretKeyRef.key }}
  {{- else if .Values.beacon.auth.authorizedUsers.value }}
  - name: BEACON_AUTH_AUTHORIZED_USERS
    value: {{ .Values.beacon.auth.authorizedUsers.value | quote }}
  {{- end }}
  {{- include "opentelemetry.environment" . | nindent 2 -}}
{{- end -}}

{{- define "beacon.logLevel" -}}
{{- if .Values.beacon.logLevel -}}
{{ .Values.beacon.logLevel | quote }}
{{- else -}}
{{ .Values.global.logging.level | quote }}
{{- end -}}
{{- end -}}

{{- define "beacon.consoleLog" -}}
{{- if .Values.beacon.consoleLog -}}
{{ .Values.beacon.consoleLog | quote }}
{{- else -}}
{{ .Values.global.logging.console | quote }}
{{- end -}}
{{- end -}}

{{- define "beacon.mode" -}}
{{- if .Values.beacon.mode -}}
{{ .Values.beacon.mode | quote }}
{{- else -}}
{{ .Values.global.mode | quote }}
{{- end -}}
{{- end -}}

{{- define "beacon.allowOrigins" -}}
{{- if .Values.beacon.allowOrigins }}
{{- join "," .Values.beacon.allowOrigins | quote -}}
{{- else if .Values.global.origins -}}
{{- join "," .Values.global.origins | quote -}}
{{- else -}}
"http://localhost:8800"
{{- end -}}
{{- end -}}
