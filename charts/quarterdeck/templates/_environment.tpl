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
    value: {{ include "quarterdeck.mode" . }}
  - name: QD_LOG_LEVEL
    value: {{ include "quarterdeck.logLevel" . }}
  - name: QD_CONSOLE_LOG
    value: {{ include "quarterdeck.consoleLog" . }}
  - name: QD_ALLOW_ORIGINS
    value: {{ include "quarterdeck.allowOrigins" . }}
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
  {{- if .Values.quarterdeck.auth.keys }}
  - name: QD_AUTH_KEYS
    value: {{ include "authKeys" . }}
  {{- end }}
  - name: QD_AUTH_AUDIENCE
    value: {{ include "quarterdeck.audience" . }}
  - name: QD_AUTH_ISSUER
    value: {{ include "quarterdeck.issuer" . }}
  {{- if .Values.quarterdeck.auth.loginURL }}
  - name: QD_AUTH_LOGIN_URL
    value: {{ .Values.quarterdeck.auth.loginURL | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.auth.logoutRedirect }}
  - name: QD_AUTH_LOGOUT_REDIRECT
    value: {{ .Values.quarterdeck.auth.logoutRedirect | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.auth.authenticateRedirect }}
  - name: QD_AUTH_AUTHENTICATED_REDIRECT
    value: {{ .Values.quarterdeck.auth.authenticateRedirect | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.auth.reauthenticateRedirect }}
  - name: QD_AUTH_REAUTHENTICATED_REDIRECT
    value: {{ .Values.quarterdeck.auth.reauthenticateRedirect | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.auth.loginRedirect }}
  - name: QD_AUTH_LOGIN_REDIRECT
    value: {{ .Values.quarterdeck.auth.loginRedirect | quote }}
  {{- end }}
  - name: QD_AUTH_ACCESS_TOKEN_TTL
    value: {{ .Values.quarterdeck.auth.accessTokenTTL | quote }}
  - name: QD_AUTH_REFRESH_TOKEN_TTL
    value: {{ .Values.quarterdeck.auth.refreshTokenTTL | quote }}
  - name: QD_AUTH_TOKEN_OVERLAP
    value: {{ .Values.quarterdeck.auth.tokenOverlap | quote }}
  - name: QD_CSRF_COOKIE_TTL
    value: {{ .Values.quarterdeck.csrf.cookieTTL | quote }}
  {{- if or .Values.secrets.csrfSecret.secretName (and .Values.secrets.create .Values.secrets.csrfSecret.value) }}
  - name: QD_CSRF_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "endeavor.csrfSecretName" . }}
        key: {{ .Values.secrets.csrfSecret.secretKey }}
  {{- end }}
  {{- if .Values.quarterdeck.securitytxt.text }}
  - name: QD_SECURITY_TXT_PATH
    value: {{ .Values.quarterdeck.securitytxt.path | quote }}
  {{- end }}
{{- end -}}

{{- define "quarterdeck.logLevel" -}}
{{- if .Values.quarterdeck.logLevel -}}
{{ .Values.quarterdeck.logLevel | quote }}
{{- else -}}
{{ .Values.global.logging.level | quote }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.consoleLog" -}}
{{- if .Values.quarterdeck.consoleLog -}}
{{ .Values.quarterdeck.consoleLog | quote }}
{{- else -}}
{{ .Values.global.logging.console | quote }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.mode" -}}
{{- if .Values.quarterdeck.mode -}}
{{ .Values.quarterdeck.mode | quote }}
{{- else -}}
{{ .Values.global.mode | quote }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.allowOrigins" -}}
{{- if .Values.quarterdeck.allowOrigins }}
{{- join "," .Values.quarterdeck.allowOrigins | quote -}}
{{- else if .Values.global.origins -}}
{{- join "," .Values.global.origins | quote -}}
{{- else -}}
{{ .Values.global.issuer | quote }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.audience" -}}
{{- if .Values.quarterdeck.audience }}
{{- join "," .Values.quarterdeck.audience | quote -}}
{{- else if .Values.global.origins -}}
{{- join "," .Values.global.origins | quote -}}
{{- else -}}
{{ .Values.global.issuer | quote }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.issuer" -}}
{{- if .Values.quarterdeck.issuer }}
{{ .Values.quarterdeck.issuer | quote }}
{{- else -}}
{{ .Values.global.issuer | quote }}
{{- end -}}
{{- end -}}

{{- define "authKeys" -}}
{{- $parts := list -}}
{{- range $key, $val := .Values.quarterdeck.auth.keys -}}
  {{- $parts = append $parts (printf "%s:%s" $key $val) -}}
{{- end -}}
{{ join ";" $parts -}}
{{- end -}}
