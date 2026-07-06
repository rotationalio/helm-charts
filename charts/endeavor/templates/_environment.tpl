{{/*
Endeavor pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "endeavor.environment" -}}
env:
  - name: ENDEAVOR_MAINTENANCE
    value: {{ .Values.endeavor.maintenance | quote }}
  - name: ENDEAVOR_MODE
    value: {{ include "endeavor.mode" . }}
  - name: ENDEAVOR_LOG_LEVEL
    value: {{ include "endeavor.logLevel" . }}
  - name: ENDEAVOR_CONSOLE_LOG
    value: {{ include "endeavor.consoleLog" . }}
  - name: ENDEAVOR_DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.databaseURLSecretName" . }}
        key: {{ .Values.secrets.databaseURL.secretKey }}
  - name: ENDEAVOR_READ_HEADER_TIMEOUT
    value: {{ .Values.endeavor.readHeaderTimeout | quote }}
  - name: ENDEAVOR_WRITE_TIMEOUT
    value: {{ .Values.endeavor.writeTimeout | quote }}
  - name: ENDEAVOR_IDLE_TIMEOUT
    value: {{ .Values.endeavor.idleTimeout | quote }}
  - name: ENDEAVOR_SHUTDOWN_TIMEOUT
    value: {{ .Values.endeavor.shutdownTimeout | quote }}
  - name: ENDEAVOR_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: ENDEAVOR_ORIGIN
    value: {{ .Values.endeavor.origin | quote }}
  - name: ENDEAVOR_ALLOW_ORIGINS
    value: {{ include "endeavor.allowOrigins" . }}
  - name: ENDEAVOR_DOCS_NAME
    value: {{ .Values.endeavor.docsName | quote }}
  - name: ENDEAVOR_COMPASS_URL
    value: {{ .Values.endeavor.compassURL | quote }}
  {{- if .Values.endeavor.compass.base }}
  - name: ENDEAVOR_COMPASS_BASE
    value: {{ .Values.endeavor.compass.base | quote }}
  {{- end }}
  {{- if .Values.endeavor.compass.timeout }}
  - name: ENDEAVOR_COMPASS_TIMEOUT
    value: {{ .Values.endeavor.compass.timeout | quote }}
  {{- end }}
  - name: ENDEAVOR_ORGANIZATION_ID
    value: {{ .Values.endeavor.organizationID | quote }}
  - name: ENDEAVOR_AUTH_QUARTERDECK_URL
    value: {{ include "endeavor.quarterdeckURL" . }}
  - name: ENDEAVOR_AUTH_AUDIENCE
    value: {{ include "endeavor.audience" . }}
  - name: ENDEAVOR_CSRF_COOKIE_TTL
    value: {{ .Values.endeavor.csrf.cookieTTL | quote }}
  {{- if or .Values.secrets.csrfSecret.secretName (and .Values.secrets.create .Values.secrets.csrfSecret.value) }}
  - name: ENDEAVOR_CSRF_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.csrfSecretName" . }}
        key: {{ .Values.secrets.csrfSecret.secretKey }}
  {{- end }}
  - name: ENDEAVOR_SECURE_CONTENT_TYPE_NOSNIFF
    value: {{ .Values.endeavor.secure.contentTypeNosniff | quote }}
  {{- if .Values.endeavor.secure.crossOriginOpenerPolicy }}
  - name: ENDEAVOR_SECURE_CROSS_ORIGIN_OPENER_POLICY
    value: {{ .Values.endeavor.secure.crossOriginOpenerPolicy | quote }}
  {{- end }}
  {{- if .Values.endeavor.secure.referrerPolicy }}
  - name: ENDEAVOR_SECURE_REFERRER_POLICY
    value: {{ .Values.endeavor.secure.referrerPolicy | quote }}
  {{- end }}
  {{- if gt (int .Values.endeavor.secure.hsts.seconds) 0 }}
  - name: ENDEAVOR_SECURE_HSTS_SECONDS
    value: {{ (int .Values.endeavor.secure.hsts.seconds) | quote }}
  - name: ENDEAVOR_SECURE_HSTS_INCLUDE_SUBDOMAINS
    value: {{ .Values.endeavor.secure.hsts.includeSubdomains | quote }}
  - name: ENDEAVOR_SECURE_HSTS_PRELOAD
    value: {{ .Values.endeavor.secure.hsts.preload | quote }}
  {{- end }}
  {{- if .Values.endeavor.inference.endpointURL }}
  - name: ENDEAVOR_INFERENCE_ENDPOINT_URL
    value: {{ .Values.endeavor.inference.endpointURL | quote }}
  {{- end }}
  - name: ENDEAVOR_BACKUP_ENABLE_API
    value: {{ .Values.endeavor.backup.enableAPI | quote }}
  - name: ENDEAVOR_INFERENCE_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.inferenceAPIKeySecretName" . }}
        key: {{ .Values.secrets.inferenceAPIKey.secretKey }}
  - name: ENDEAVOR_HORIZON_RENDERER_CACHE_SIZE
    value: {{ .Values.endeavor.horizon.rendererCacheSize | quote }}
  - name: ENDEAVOR_RADISH_WORKERS
    value: {{ .Values.endeavor.radish.workers | quote }}
  - name: ENDEAVOR_RADISH_QUEUE_SIZE
    value: {{ .Values.endeavor.radish.queueSize | quote }}
  {{- if .Values.endeavor.mcp.refreshControllerInterval }}
  - name: ENDEAVOR_MCP_REFRESH_CONTROLLER_INTERVAL
    value: {{ .Values.endeavor.mcp.refreshControllerInterval | quote }}
  {{- end }}
  {{- if .Values.endeavor.mcp.integrationRefreshInterval }}
  - name: ENDEAVOR_MCP_INTEGRATION_REFRESH_INTERVAL
    value: {{ .Values.endeavor.mcp.integrationRefreshInterval | quote }}
  {{- end }}
  - name: ENDEAVOR_TELEMETRY_ENABLED
    value: {{ .Values.endeavor.telemetry.enabled | quote }}
  {{- if .Values.endeavor.telemetry.serviceAddr }}
  - name: GIMLET_OTEL_SERVICE_ADDR
    value: {{ .Values.endeavor.telemetry.serviceAddr | quote }}
  {{- end }}
  - name: ENDEAVOR_COFFER_ENABLED
    value: {{ .Values.endeavor.coffer.enabled | quote }}
  {{- if and .Values.endeavor.coffer.enabled (or .Values.secrets.cofferKeys.secretName (and .Values.secrets.create .Values.secrets.cofferKeys.value)) }}
  - name: ENDEAVOR_COFFER_KEYS
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.cofferKeysSecretName" . }}
        key: {{ .Values.secrets.cofferKeys.secretKey }}
  {{- end }}
  {{- include "opentelemetry.environment" . | nindent 2 -}}
  {{- if .Values.endeavor.blobs.uri }}
  - name: ENDEAVOR_BLOBS_URI
    value: {{ .Values.endeavor.blobs.uri | quote }}
  {{- end }}
  {{- if .Values.secrets.aws.secretName }}
  - name: AWS_ACCESS_KEY_ID
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secrets.aws.secretName }}
        key: {{ .Values.secrets.aws.accessKeyIDKey }}
  - name: AWS_SECRET_ACCESS_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secrets.aws.secretName }}
        key: {{ .Values.secrets.aws.secretAccessKeyKey }}
  {{- end }}
  {{- if .Values.endeavor.tasks.enableLoader }}
  - name: ENDEAVOR_TASKS_ENABLE_LOADER
    value: "true"
  - name: ENDEAVOR_TASKS_LOADER_PATH
    value: {{ .Values.endeavor.tasks.loaderPath | quote }}
  {{- end }}
  {{- if .Values.endeavor.tasks.beacon.beaconUrl }}
  - name: ENDEAVOR_TASKS_BEACON_BEACON_URL
    value: {{ .Values.endeavor.tasks.beacon.beaconUrl | quote }}
  {{- end }}
  {{- if .Values.endeavor.tasks.beacon.beaconTTL }}
  - name: ENDEAVOR_TASKS_BEACON_BEACON_TTL
    value: {{ .Values.endeavor.tasks.beacon.beaconTTL | quote }}
  {{- end }}
  {{- if and .Values.endeavor.tasks.beacon.beaconUrl (and .Values.endeavor.tasks.beacon.basicAuthUsername .Values.endeavor.tasks.beacon.basicAuthPassword) }}
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_TYPE
    value: "basic"
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_USERNAME
    value: {{ .Values.endeavor.tasks.beacon.basicAuthUsername | quote }}
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_PASSWORD
    value: {{ .Values.endeavor.tasks.beacon.basicAuthPassword | quote }}
  {{- end }}
{{- end -}}

{{- define "endeavor.logLevel" -}}
{{- if .Values.endeavor.logLevel -}}
{{ .Values.endeavor.logLevel | quote }}
{{- else -}}
{{ .Values.global.logging.level | quote }}
{{- end -}}
{{- end -}}

{{- define "endeavor.consoleLog" -}}
{{- if .Values.endeavor.consoleLog -}}
{{ .Values.endeavor.consoleLog | quote }}
{{- else -}}
{{ .Values.global.logging.console | quote }}
{{- end -}}
{{- end -}}

{{- define "endeavor.mode" -}}
{{- if .Values.endeavor.mode -}}
{{ .Values.endeavor.mode | quote }}
{{- else -}}
{{ .Values.global.mode | quote }}
{{- end -}}
{{- end -}}

{{- define "endeavor.allowOrigins" -}}
{{- if .Values.endeavor.allowOrigins }}
{{- join "," .Values.endeavor.allowOrigins | quote -}}
{{- else if .Values.global.origins -}}
{{- join "," .Values.global.origins | quote -}}
{{- else -}}
{{ .Values.endeavor.origin | quote }}
{{- end -}}
{{- end -}}

{{- define "endeavor.quarterdeckURL" -}}
{{- if .Values.endeavor.auth.quarterdeckURL -}}
{{ .Values.endeavor.auth.quarterdeckURL | quote }}
{{- else -}}
{{ .Values.global.issuer | quote }}
{{- end -}}
{{- end -}}

{{- define "endeavor.audience" -}}
{{- if .Values.endeavor.auth.audience -}}
{{ .Values.endeavor.auth.audience | quote }}
{{- else -}}
{{ .Values.endeavor.origin | quote }}
{{- end -}}
{{- end -}}
