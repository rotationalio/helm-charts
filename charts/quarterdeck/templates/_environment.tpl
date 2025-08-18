{{/*
Quarterdeck pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "quarterdeck.environment" -}}
env:
  - name: QD_MAINTENANCE
    value: {{ .Values.quarterdeck.maintenance | quote }}
  - name: QD_MODE
    value: {{ .Values.quarterdeck.mode | quote }}
  - name: QD_LOG_LEVEL
    value: {{ .Values.quarterdeck.logLevel | quote }}
  - name: QD_CONSOLE_LOG
    value: {{ .Values.quarterdeck.consoleLog | quote }}
  - name: QD_ALLOW_ORIGINS
    value: {{ join "," .Values.quarterdeck.allowOrigins | quote }}
  - name: QD_RATE_LIMIT_ENABLED
    value: {{ .Values.quarterdeck.rateLimit.enabled | quote }}
  - name: QD_RATE_LIMIT_PER_SECOND
    value: {{ .Values.quarterdeck.rateLimit.perSecond | quote }}
  - name: QD_RATE_LIMIT_BURST
    value: {{ .Values.quarterdeck.rateLimit.burst | quote }}
  - name: QD_DATABASE_URL
    value: {{ .Values.quarterdeck.databaseURL | quote }}
  {{- if .Values.authentication.keys }}
  - name: QD_AUTH_KEYS
    value: {{ include "authKeys" . | quote }}
  {{- end }}
  - name: QD_AUTH_AUDIENCE
    value: {{ join "," .Values.authentication.audience | quote }}
  - name: QD_AUTH_ISSUER
    value: {{ include "quarterdeck.authIssuer" . | quote }}
  - name: QD_AUTH_ACCESS_TOKEN_TTL
    value: {{ .Values.authentication.accessTokenTTL | quote }}
  - name: QD_AUTH_REFRESH_TOKEN_TTL
    value: {{ .Values.authentication.refreshTokenTTL | quote }}
  - name: QD_AUTH_TOKEN_OVERLAP
    value: {{ .Values.authentication.tokenOverlap | quote }}
  {{- if .Values.securitytxt.text }}
  - name: QD_SECURITY_TXT_PATH
    value: {{ .Values.securitytxt.path | quote }}
  {{- end }}
{{- end -}}

{{- define "authKeys" -}}
{{- $parts := list -}}
{{- range $key, $val := .Values.authentication.keys -}}
  {{- $parts = append $parts (printf "%s:%s" $key $val) -}}
{{- end -}}
{{ join ";" $parts -}}
{{- end -}}

{{/*
If the authentication issuer isn't specified, use the host in the values file
*/}}
{{- define "quarterdeck.authIssuer" -}}
{{- if .Values.authentication.issuer -}}
{{ .Values.authentication.issuer }}
{{- else -}}
{{ printf "https://%s" .Values.host }}
{{- end -}}
{{- end -}}
