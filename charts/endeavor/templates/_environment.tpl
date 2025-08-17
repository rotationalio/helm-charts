{{/*
Endeavor pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "endeavor.environment" -}}
env:
  - name: ENDEAVOR_MAINTENANCE
    value: {{ .Values.endeavor.maintenance | quote }}
  - name: ENDEAVOR_MODE
    value: {{ .Values.endeavor.mode | quote }}
  - name: ENDEAVOR_LOG_LEVEL
    value: {{ .Values.endeavor.logLevel | quote }}
  - name: ENDEAVOR_CONSOLE_LOG
    value: {{ .Values.endeavor.consoleLog | quote }}
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
    value: {{ .Values.endeavor.auth.quarterdeckURL | quote }}
  - name: ENDEAVOR_AUTH_AUDIENCE
    value: {{ .Values.endeavor.auth.audience | quote }}
  - name: ENDEAVOR_CSRF_COOKIE_TTL
    value: {{ .Values.endeavor.csrf.cookieTTL | quote }}
  {{- if or .Values.secrets.csrfSecret.secretName (and .Values.secrets.create .Values.secrets.csrfSecret.value) }}
  - name: ENDEAVOR_CSRF_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.csrfSecretName" . }}
        key: {{ .Values.secrets.csrfSecret.secretKey }}
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

{{- define "endeavor.inferenceAPIKeySecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "endeavor.fullname" . }}
{{- else -}}
{{ default (include "endeavor.fullname" .) .Values.secrets.inferenceAPIKey.secretName }}
{{- end -}}
{{- end -}}

{{- define "endeavor.csrfSecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "endeavor.fullname" . }}
{{- else -}}
{{ default (include "endeavor.fullname" .) .Values.secrets.csrfSecret.secretName }}
{{- end -}}
{{- end -}}

{{- define "endeavor.allowOrigins" -}}
{{- if .Values.endeavor.allowOrigins }}
{{- join "," .Values.endeavor.allowOrigins | quote -}}
{{- else -}}
{{ .Values.endeavor.origin | quote }}
{{- end -}}
{{- end -}}