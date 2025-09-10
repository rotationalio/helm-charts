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
    value: {{ .Values.endeavor.databaseURL | quote }}
  - name: ENDEAVOR_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: ENDEAVOR_ORIGIN
    value: {{ .Values.endeavor.origin | quote }}
  - name: ENDEAVOR_ALLOW_ORIGINS
    value: {{ include "endeavor.allowOrigins" . }}
  - name: ENDEAVOR_DOCS_NAME
    value: {{ .Values.endeavor.docsName | quote }}
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
  {{- if gt .Values.endeavor.secure.hsts.seconds 0 }}
  - name: ENDEAVOR_SECURE_HSTS_SECONDS
    value: {{ .Values.endeavor.secure.hsts.seconds | quote }}
  - name: ENDEAVOR_SECURE_HSTS_INCLUDE_SUBDOMAINS
    value: {{ .Values.endeavor.secure.hsts.includeSubdomains | quote }}
  - name: ENDEAVOR_SECURE_HSTS_PRELOAD
    value: {{ .Values.endeavor.secure.hsts.preload | quote }}
  {{- end }}
  {{- if .Values.endeavor.inference.endpointURL }}
  - name: ENDEAVOR_INFERENCE_ENDPOINT_URL
    value: {{ .Values.endeavor.inference.endpointURL | quote }}
  {{- end }}
  - name: ENDEAVOR_INFERENCE_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.inferenceAPIKeySecretName" . }}
        key: {{ .Values.secrets.inferenceAPIKey.secretKey }}
  - name: ENDEAVOR_RADISH_WORKERS
    value: {{ .Values.endeavor.radish.workers | quote }}
  - name: ENDEAVOR_RADISH_QUEUE_SIZE
    value: {{ .Values.endeavor.radish.queueSize | quote }}
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