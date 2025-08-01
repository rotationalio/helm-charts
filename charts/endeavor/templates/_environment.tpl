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
  - name: ENDEAVOR_DOCUMENTS_URL
    value: {{ .Values.endeavor.documentsURL | quote }}
  - name: ENDEAVOR_WEB_MAINTENANCE
    value: {{ .Values.endeavor.web.maintenance | quote }}
  - name: ENDEAVOR_WEB_ENABLED
    value: {{ .Values.endeavor.web.enabled | quote }}
  - name: ENDEAVOR_WEB_API_ENABLED
    value: {{ .Values.endeavor.web.APIenabled | quote }}
  - name: ENDEAVOR_WEB_UI_ENABLED
    value: {{ .Values.endeavor.web.UIenabled | quote }}
  - name: ENDEAVOR_WEB_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  {{- if .Values.endeavor.web.origin }}
  - name: ENDEAVOR_WEB_ORIGIN
    value: {{ .Values.endeavor.web.origin | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.keys }}
  - name: ENDEAVOR_WEB_AUTH_KEYS
    value: {{ .Values.endeavor.web.auth.keys | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.audience }}
  - name: ENDEAVOR_WEB_AUTH_AUDIENCE
    value: {{ .Values.endeavor.web.auth.audience | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.issuer }}
  - name: ENDEAVOR_WEB_AUTH_ISSUER
    value: {{ .Values.endeavor.web.auth.issuer | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.cookieDomain }}
  - name: ENDEAVOR_WEB_AUTH_COOKIE_DOMAIN
    value: {{ .Values.endeavor.web.auth.cookieDomain | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.accessTokenTTL }}
  - name: ENDEAVOR_WEB_AUTH_ACCESS_TOKEN_TTL
    value: {{ .Values.endeavor.web.auth.accessTokenTTL | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.refreshTokenTTL }}
  - name: ENDEAVOR_WEB_AUTH_REFRESH_TOKEN_TTL
    value: {{ .Values.endeavor.web.auth.refreshTokenTTL | quote }}
  {{- end }}
  {{- if .Values.endeavor.web.auth.tokenOverlap }}
  - name: ENDEAVOR_WEB_TOKEN_OVERLAP
    value: {{ .Values.endeavor.web.auth.tokenOverlap | quote }}
  {{- end }}
  - name: ENDEAVOR_WEB_DOCS_NAME
    value: {{ .Values.endeavor.web.docsName | quote }}
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