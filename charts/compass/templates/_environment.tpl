{{/*
Compass is configured through a Django settings module, which loads sensitive settings
from environment variables. Configuration for these values are in the values.yaml file.
*/}}
{{- define "compass.environment" -}}
env:
  - name: DJANGO_DEBUG
    value: {{ if .Values.compass.django.debug }}"true"{{ else }}"false"{{ end }}
  - name: DJANGO_SETTINGS_MODULE
    value: {{ .Values.compass.django.settingsModule | quote }}
  - name: ALLOWED_HOSTS
    value: {{ include "compass.allowedHosts" . | quote }}
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.secretKeyName" . }}
        key: {{ .Values.secrets.secretKey.secretKey }}
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.databaseURLName" . }}
        key: {{ .Values.secrets.databaseURL.secretKey }}
  {{- if .Values.compass.sentry.dsn }}
  - name: SENTRY_DSN
    value: {{ .Values.compass.sentry.dsn | quote }}
  {{- end }}
  {{- if .Values.jobs.ensureAdmin.create }}
  - name: DJANGO_ADMIN_USERNAME
    value: {{ .Values.jobs.ensureAdmin.username | quote }}
  - name: DJANGO_ADMIN_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.adminPasswordName" . }}
        key: {{ .Values.secrets.adminPassword.secretKey }}
  - name: DJANGO_ADMIN_EMAIL
    value: {{ .Values.jobs.ensureAdmin.email | quote }}
  {{- end }}
{{- end -}}

{{- define "compass.allowedHosts" -}}
{{- if .Values.compass.allowedHosts -}}
{{ .Values.compass.allowedHosts }}
{{- else -}}
{{ default "localhost,127.0.0.1" (include "compass.ingressHostnames" .) }}
{{- end -}}
{{- end -}}

{{- define "compass.ingressHostnames" -}}
{{- if .Values.ingress.enabled -}}
{{- $list := list -}}
{{- range .Values.ingress.hosts -}}
{{- $list = append $list .host -}}
{{- end -}}
{{- join "," $list -}}
{{- end -}}
{{- end -}}

{{- define "compass.secrets.secretKeyName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.secretKey.secretName }}
{{- end -}}
{{- end -}}

{{- define "compass.secrets.databaseURLName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.databaseURL.secretName }}
{{- end -}}
{{- end -}}

{{- define "compass.secrets.adminPasswordName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.adminPassword.secretName }}
{{- end -}}
{{- end -}}