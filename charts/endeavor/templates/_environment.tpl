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
  - name: ENDEAVOR_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: ENDEAVOR_ORIGIN
    value: {{ .Values.endeavor.origin | quote }}
  - name: ENDEAVOR_ALLOW_ORIGINS
    value: {{ include "endeavor.allowOrigins" . }}
  - name: ENDEAVOR_DOCS_NAME
    value: {{ .Values.endeavor.docsName | quote }}
  - name: ENDEAVOR_ORGANIZATION_ID
    value: {{ .Values.endeavor.organizationID | quote }}
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
  {{- if .Values.endeavor.blobs.uri }}
  - name: ENDEAVOR_BLOBS_URI
    value: {{ .Values.endeavor.blobs.uri | quote }}
  {{- end }}
  - name: ENDEAVOR_STATIC_SERVE
    value: {{ .Values.endeavor.static.serve | quote }}
  - name: ENDEAVOR_STATIC_ROOT
    value: {{ .Values.endeavor.static.root | quote }}
  - name: ENDEAVOR_STATIC_URL
    value: {{ .Values.endeavor.static.url | quote }}
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
  - name: ENDEAVOR_HORIZON_RENDERER_CACHE_SIZE
    value: {{ .Values.endeavor.horizon.rendererCacheSize | quote }}
  - name: ENDEAVOR_COMPASS_BASE
    value: {{ .Values.endeavor.compass.base | quote }}
  - name: ENDEAVOR_COMPASS_TIMEOUT
    value: {{ .Values.endeavor.compass.timeout | quote }}
  {{- if .Values.endeavor.mcp.refreshControllerInterval }}
  - name: ENDEAVOR_MCP_REFRESH_CONTROLLER_INTERVAL
    value: {{ .Values.endeavor.mcp.refreshControllerInterval | quote }}
  {{- end }}
  {{- if .Values.endeavor.mcp.integrationRefreshInterval }}
  - name: ENDEAVOR_MCP_INTEGRATION_REFRESH_INTERVAL
    value: {{ .Values.endeavor.mcp.integrationRefreshInterval | quote }}
  {{- end }}
  - name: ENDEAVOR_CATALOG_SYNC_CONTROLLER_INTERVAL
    value: {{ .Values.endeavor.catalog.syncControllerInterval | quote }}
  - name: ENDEAVOR_CATALOG_PROVIDER_SYNC_INTERVAL
    value: {{ .Values.endeavor.catalog.providerSyncInterval | quote }}
  {{- if .Values.endeavor.tasks.enableLoader }}
  - name: ENDEAVOR_TASKS_ENABLE_LOADER
    value: "true"
  - name: ENDEAVOR_TASKS_LOADER_PATH
    value: {{ .Values.endeavor.tasks.loaderPath | quote }}
  {{- end }}
  {{- if .Values.endeavor.tasks.beacon.url }}
  - name: ENDEAVOR_TASKS_BEACON_URL
    value: {{ .Values.endeavor.tasks.beacon.url | quote }}
  {{- end }}
  {{- if .Values.endeavor.tasks.beacon.ttl }}
  - name: ENDEAVOR_TASKS_BEACON_TTL
    value: {{ .Values.endeavor.tasks.beacon.ttl | quote }}
  {{- end }}
  {{- if .Values.endeavor.tasks.beacon.compassVersion }}
  - name: ENDEAVOR_TASKS_BEACON_COMPASS_VERSION
    value: {{ .Values.endeavor.tasks.beacon.compassVersion | quote }}
  {{- end }}
  {{- if and .Values.endeavor.tasks.beacon.url .Values.endeavor.tasks.beacon.authSecret.secretName }}
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_TYPE
    value: "basic"
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_USERNAME
    valueFrom:
      secretKeyRef:
        name: {{ .Values.endeavor.tasks.beacon.authSecret.secretName }}
        key: {{ .Values.endeavor.tasks.beacon.authSecret.usernameKey }}
  - name: ENDEAVOR_TASKS_BEACON_CREDENTIALS_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ .Values.endeavor.tasks.beacon.authSecret.secretName }}
        key: {{ .Values.endeavor.tasks.beacon.authSecret.passwordKey }}
  {{- end }}
  - name: RADISH_MANAGED_DB
    value: {{ .Values.endeavor.radish.managedDB | quote }}
  - name: RADISH_NUM_WORKERS
    value: {{ .Values.endeavor.radish.numWorkers | quote }}
  - name: RADISH_TASK_RETRIES
    value: {{ .Values.endeavor.radish.taskRetries | quote }}
  - name: RADISH_TASK_TIMEOUT
    value: {{ .Values.endeavor.radish.taskTimeout | quote }}
  - name: RADISH_CLEANUP_TIMEOUT
    value: {{ .Values.endeavor.radish.cleanupTimeout | quote }}
  - name: RADISH_POLL_INTERVAL
    value: {{ .Values.endeavor.radish.pollInterval | quote }}
  - name: RADISH_POLL_JITTER
    value: {{ .Values.endeavor.radish.pollJitter | quote }}
  - name: RADISH_RETENTION
    value: {{ .Values.endeavor.radish.retention | quote }}
  - name: RADISH_VACUUM_INTERVAL
    value: {{ .Values.endeavor.radish.vacuumInterval | quote }}
  - name: RADISH_BACKOFF_POLICY
    value: {{ .Values.endeavor.radish.backoff.policy | quote }}
  - name: RADISH_BACKOFF_DELAY
    value: {{ .Values.endeavor.radish.backoff.delay | quote }}
  - name: RADISH_BACKOFF_FACTOR
    value: {{ .Values.endeavor.radish.backoff.factor | quote }}
  - name: RADISH_BACKOFF_JITTER
    value: {{ .Values.endeavor.radish.backoff.jitter | quote }}
  - name: RADISH_BACKOFF_SIGMA
    value: {{ .Values.endeavor.radish.backoff.sigma | quote }}
  - name: ENDEAVOR_TELEMETRY_ENABLED
    value: {{ .Values.endeavor.telemetry.enabled | quote }}
  {{- if .Values.endeavor.telemetry.serviceAddr }}
  - name: GIMLET_OTEL_SERVICE_ADDR
    value: {{ .Values.endeavor.telemetry.serviceAddr | quote }}
  {{- end }}
  - name: ENDEAVOR_BACKUP_ENABLE_API
    value: {{ .Values.endeavor.backup.enableAPI | quote }}
  - name: ENDEAVOR_COFFER_ENABLED
    value: {{ .Values.endeavor.coffer.enabled | quote }}
  {{- if and .Values.endeavor.coffer.enabled (or .Values.secrets.cofferKeys.secretName (and .Values.secrets.create .Values.secrets.cofferKeys.value)) }}
  - name: ENDEAVOR_COFFER_KEYS
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.cofferKeysSecretName" . }}
        key: {{ .Values.secrets.cofferKeys.secretKey }}
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
  {{- include "opentelemetry.environment" . | nindent 2 -}}
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


{{- define "genoa.environment" -}}
env:
  - name: GENOA_LOG_LEVEL
    value: {{ include "genoa.logLevel" . }}
  - name: GENOA_CONSOLE_LOG
    value: {{ include "genoa.consoleLog" . }}
  - name: GENOA_LOCAL_ACCESS
    value: "false"
  - name: GENOA_NAMESPACE
    value: {{ .Release.Namespace }}
  - name: GENOA_DATABASE_URL
    {{- include "genoa.databaseURL" . | nindent 4 }}
  - name: ENDEAVOR_ENSURE_DATABASE_ENABLED
    value: "true"
  - name: ENDEAVOR_ENSURE_DATABASE_NAME
    value: {{ default (include "endeavor.fullname" .) .Values.genoa.database | quote }}
  - name: ENDEAVOR_ENSURE_DATABASE_SECRET_NAME
    value: {{ include "endeavor.databaseURLSecretName" . }}
{{- end -}}

{{- define "genoa.logLevel" -}}
{{- if .Values.genoa.logLevel -}}
{{ .Values.genoa.logLevel | quote }}
{{- else -}}
{{ .Values.global.logging.level | quote }}
{{- end -}}
{{- end -}}

{{- define "genoa.consoleLog" -}}
{{- if .Values.genoa.consoleLog -}}
{{ .Values.genoa.consoleLog | quote }}
{{- else -}}
{{ .Values.global.logging.console | quote }}
{{- end -}}
{{- end -}}

{{- define "genoa.databaseURL" -}}
{{- if .Values.genoa.adminDatabaseURL.value -}}
value: {{ .Values.genoa.adminDatabaseURL.value | quote }}
{{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ include "genoa.databaseURLSecretName" . }}
    key: {{ .Values.genoa.adminDatabaseURL.secretKey }}
{{- end -}}
{{- end -}}

{{- define "genoa.databaseURLSecretName" -}}
{{- if .Values.genoa.adminDatabaseURL.secretName -}}
{{ .Values.genoa.adminDatabaseURL.secretName }}
{{- else -}}
{{ include "endeavor.fullname" . }}
{{- end -}}
{{- end -}}