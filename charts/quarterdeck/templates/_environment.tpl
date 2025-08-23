{{/*
Quarterdeck pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "quarterdeck.environment" -}}
env:
  - name: QD_MAINTENANCE
    value: {{ .Values.quarterdeck.maintenance | quote }}
  - name: QD_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: QD_MODE
    value: {{ .Values.quarterdeck.mode | quote }}
  - name: QD_LOG_LEVEL
    value: {{ .Values.quarterdeck.logLevel | quote }}
  - name: QD_CONSOLE_LOG
    value: {{ .Values.quarterdeck.consoleLog | quote }}
  - name: QD_ALLOW_ORIGINS
    value: {{ join "," .Values.quarterdeck.allowOrigins | quote }}
  - name: QD_RATE_LIMIT_TYPE
    value: {{ .Values.quarterdeck.rateLimit.type | quote }}
  - name: QD_RATE_LIMIT_PER_SECOND
    value: {{ .Values.quarterdeck.rateLimit.perSecond | quote }}
  - name: QD_RATE_LIMIT_BURST
    value: {{ .Values.quarterdeck.rateLimit.burst | quote }}
  - name: QD_RATE_LIMIT_CACHE_TTL
    value: {{ .Values.quarterdeck.rateLimit.cacheTTL | quote }}
  - name: QD_DATABASE_URL
    value: {{ .Values.quarterdeck.database.URL | quote }}
  - name: QD_DATABASE_READ_ONLY
    value: {{ .Values.quarterdeck.database.readOnly | quote }}
  {{- if .Values.authentication.keys }}
  - name: QD_AUTH_KEYS
    value: {{ include "authKeys" . | quote }}
  {{- end }}
  - name: QD_AUTH_AUDIENCE
    value: {{ join "," .Values.authentication.audience | quote }}
  - name: QD_AUTH_ISSUER
    value: {{ .Values.authentication.issuer | quote }}
  - name: QD_AUTH_LOGIN_URL
    value: {{ include "loginURL" . | quote }}
  - name: QD_AUTH_LOGOUT_REDIRECT
    value: {{ include "logoutRedirect" . | quote }}
  - name: QD_AUTH_AUTHENTICATED_REDIRECT
    value: {{ include "authenticateRedirect" . | quote }}
  - name: QD_AUTH_REAUTHENTICATED_REDIRECT
    value: {{ include "reauthenticateRedirect" . | quote }}
  - name: QD_AUTH_LOGIN_REDIRECT
    value: {{ include "loginRedirect" . | quote }}
  - name: QD_AUTH_ACCESS_TOKEN_TTL
    value: {{ .Values.authentication.accessTokenTTL | quote }}
  - name: QD_AUTH_REFRESH_TOKEN_TTL
    value: {{ .Values.authentication.refreshTokenTTL | quote }}
  - name: QD_AUTH_TOKEN_OVERLAP
    value: {{ .Values.authentication.tokenOverlap | quote }}
  - name: QD_CSRF_COOKIE_TTL
    value: {{ .Values.csrf.cookieTTL | quote }}
  {{- if .Values.csrf.secret -}}
  - name: QD_CSRF_SECRET
    value: {{ .Values.csrf.secret | quote }}
  {{- end }}
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

{{- define "loginURL" -}}
{{- if .Values.authentication.loginURL -}}
{{ .Values.authentication.loginURL }}
{{- else -}}
{{ printf "%s/login" .Values.host }}
{{- end -}}
{{- end -}}

{{- define "logoutRedirect" -}}
{{- if .Values.authentication.logoutRedirect -}}
{{ .Values.authentication.logoutRedirect }}
{{- else -}}
{{ printf "%s/login" .Values.host }}
{{- end -}}
{{- end -}}

{{- define "loginRedirect" -}}
{{- if .Values.authentication.loginRedirect -}}
{{ .Values.authentication.loginRedirect }}
{{- else -}}
{{ printf "%s/dashboard" .Values.host }}
{{- end -}}
{{- end -}}

{{- define "authenticateRedirect" -}}
{{- if .Values.authentication.authenticateRedirect -}}
{{ .Values.authentication.authenticateRedirect }}
{{- else -}}
{{ printf "%s/dashboard" .Values.host }}
{{- end -}}
{{- end -}}

{{- define "reauthenticateRedirect" -}}
{{- if .Values.authentication.reauthenticateRedirect -}}
{{ .Values.authentication.reauthenticateRedirect }}
{{- else -}}
{{ printf "%s/dashboard" .Values.host }}
{{- end -}}
{{- end -}}
