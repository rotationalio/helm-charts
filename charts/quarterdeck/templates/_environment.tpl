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
  {{- if .Values.quarterdeck.docsName }}
  - name: QD_DOCS_NAME
    value: {{ .Values.quarterdeck.docsName | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.app.name }}
  - name: QD_APP_NAME
    value: {{ .Values.quarterdeck.app.name | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.app.logoURI }}
  - name: QD_APP_LOGO_URI
    value: {{ .Values.quarterdeck.app.logoURI | quote }}
  {{- end }}
  - name: QD_APP_BASE_URI
    value: {{ include "quarterdeck.app.baseURI" . }}
  {{- if or .Values.quarterdeck.app.welcomeEmail.create .Values.quarterdeck.app.welcomeEmail.configMap }}
  - name: QD_APP_WELCOME_EMAIL_HTML_PATH
    value: "{{ .Values.quarterdeck.app.welcomeEmail.mountPath }}/{{ .Values.quarterdeck.app.welcomeEmail.htmlTemplate.key }}"
  - name: QD_APP_WELCOME_EMAIL_TEXT_PATH
    value: "{{ .Values.quarterdeck.app.welcomeEmail.mountPath }}/{{ .Values.quarterdeck.app.welcomeEmail.textTemplate.key }}"
  {{- end }}
  {{- if .Values.quarterdeck.org.name }}
  - name: QD_ORG_NAME
    value: {{ .Values.quarterdeck.org.name | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.org.streetAddress }}
  - name: QD_ORG_STREET_ADDRESS
    value: {{ .Values.quarterdeck.org.streetAddress | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.org.homepage }}
  - name: QD_ORG_HOMEPAGE_URI
    value: {{ .Values.quarterdeck.org.homepage | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.org.supportEmail }}
  - name: QD_ORG_SUPPORT_EMAIL
    value: {{ .Values.quarterdeck.org.supportEmail | quote }}
  {{- end }}
  - name: QD_DATABASE_URL
    {{- if .Values.quarterdeck.database.URL.secretKeyRef }}
    valueFrom:
      secretKeyRef:
        name: {{ .Values.quarterdeck.database.URL.secretKeyRef.name }}
        key: {{ .Values.quarterdeck.database.URL.secretKeyRef.key }}
    {{- else }}
    value: {{ .Values.quarterdeck.database.URL.value | quote }}
    {{- end }}
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
  - name: QD_SECURE_CONTENT_TYPE_NOSNIFF
    value: {{ .Values.quarterdeck.secure.contentTypeNosniff | quote }}
  {{- if .Values.quarterdeck.secure.crossOriginOpenerPolicy }}
  - name: QD_SECURE_CROSS_ORIGIN_OPENER_POLICY
    value: {{ .Values.quarterdeck.secure.crossOriginOpenerPolicy | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.secure.referrerPolicy }}
  - name: QD_SECURE_REFERRER_POLICY
    value: {{ .Values.quarterdeck.secure.referrerPolicy | quote }}
  {{- end }}
  {{- if gt (int .Values.quarterdeck.secure.hsts.seconds) 0 }}
  - name: QD_SECURE_HSTS_SECONDS
    value: {{ (int .Values.quarterdeck.secure.hsts.seconds) | quote }}
  - name: QD_SECURE_HSTS_INCLUDE_SUBDOMAINS
    value: {{ .Values.quarterdeck.secure.hsts.includeSubdomains | quote }}
  - name: QD_SECURE_HSTS_PRELOAD
    value: {{ .Values.quarterdeck.secure.hsts.preload | quote }}
  {{- end }}
  {{- if .Values.quarterdeck.securitytxt.text }}
  - name: QD_SECURITY_TXT_PATH
    value: {{ .Values.quarterdeck.securitytxt.path | quote }}
  {{- end }}
  - name: QD_EMAIL_SENDER
    value: {{ .Values.quarterdeck.email.sender.email | quote }}
  - name: QD_EMAIL_SENDER_NAME
    value: {{ .Values.quarterdeck.email.sender.name | quote }}
  {{- if eq .Values.quarterdeck.email.method "smtp" }}
  - name : QD_EMAIL_SMTP_HOST
    value: {{ .Values.quarterdeck.email.smtp.host | quote }}
  - name : QD_EMAIL_SMTP_PORT
    value: {{ .Values.quarterdeck.email.smtp.port | quote }}
  - name : QD_EMAIL_SMTP_USERNAME
    value: {{ .Values.quarterdeck.email.smtp.username | quote }}
  - name: QD_EMAIL_SMTP_PASSWORD
    {{- if .Values.quarterdeck.email.smtp.password.secretKeyRef }}
    valueFrom:
      secretKeyRef:
        name: {{ .Values.quarterdeck.email.smtp.password.secretKeyRef.name }}
        key: {{ .Values.quarterdeck.email.smtp.password.secretKeyRef.key }}
    {{- else }}
    value: {{ .Values.quarterdeck.email.smtp.password.value | quote }}
    {{- end }}
  {{- if .Values.quarterdeck.email.smtp.useCRAMMD5 }}
  - name : QD_EMAIL_SMTP_USE_CRAM_MD5
    value: "true"
  {{- end }}
  - name : QD_EMAIL_SMTP_POOL_SIZE
    value: {{ .Values.quarterdeck.email.smtp.poolSize | quote }}
  {{- end }}
  {{- if eq .Values.quarterdeck.email.method "sendgrid" }}
  - name: QD_EMAIL_SENDGRID_API_KEY
    {{- if .Values.quarterdeck.email.sendgrid.apiKey.secretKeyRef }}
    valueFrom:
      secretKeyRef:
        name: {{ .Values.quarterdeck.email.sendgrid.apiKey.secretKeyRef.name }}
        key: {{ .Values.quarterdeck.email.sendgrid.apiKey.secretKeyRef.key }}
    {{- else }}
    value: {{ .Values.quarterdeck.email.sendgrid.apiKey.value | quote }}
    {{- end }}
  {{- end }}
  - name: QD_EMAIL_BACKOFF_TIMEOUT
    value: {{ .Values.quarterdeck.email.backoff.timeout | quote }}
  - name: QD_EMAIL_BACKOFF_INITIAL_INTERVAL
    value: {{ .Values.quarterdeck.email.backoff.initialInterval | quote }}
  - name: QD_EMAIL_BACKOFF_MAX_INTERVAL
    value: {{ .Values.quarterdeck.email.backoff.maxInterval | quote }}
  - name: QD_EMAIL_BACKOFF_MAX_ELAPSED_TIME
    value: {{ .Values.quarterdeck.email.backoff.maxElapsedTime | quote }}
  - name: QD_RATE_LIMIT_TYPE
    value: {{ .Values.quarterdeck.rateLimit.type | quote }}
  - name: QD_RATE_LIMIT_PER_SECOND
    value: {{ .Values.quarterdeck.rateLimit.perSecond | quote }}
  - name: QD_RATE_LIMIT_BURST
    value: {{ .Values.quarterdeck.rateLimit.burst | quote }}
  - name: QD_RATE_LIMIT_CACHE_TTL
    value: {{ .Values.quarterdeck.rateLimit.cacheTTL | quote }}
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
{{- if .Values.quarterdeck.auth.audience }}
{{- join "," .Values.quarterdeck.auth.audience | quote -}}
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

{{- define "quarterdeck.app.baseURI" }}
{{- if .Values.quarterdeck.app.baseURI -}}
{{- .Values.quarterdeck.app.baseURI | quote -}}
{{- else if .Values.quarterdeck.auth.audience -}}
{{- index .Values.quarterdeck.auth.audience 0 | quote -}}
{{- else -}}
{{- .Values.global.issuer | quote -}}
{{- end -}}
{{- end -}}


{{- define "authKeys" -}}
{{- $parts := list -}}
{{- range $key, $val := .Values.quarterdeck.auth.keys -}}
  {{- $parts = append $parts (printf "%s:%s" $key $val) -}}
{{- end -}}
{{ join ";" $parts -}}
{{- end -}}
