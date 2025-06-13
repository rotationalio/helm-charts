{{/*
Parlance is configured through a Django settings module, which loads sensitive settings
from environment variables. Configuration for these values are in the values.yaml file.
*/}}
{{- define "parlance.environment" -}}
env:
  - name: ALLOWED_HOSTS
    value: {{ include "parlance.allowedHosts" . | quote }}
  - name: DJANGO_SETTINGS_MODULE
    value: {{ .Values.parlance.django.settingsModule | quote }}
  - name: DJANGO_DEBUG
    value: {{ .Values.parlance.django.debug | quote }}
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "parlance.secretKeySecretName" . }}
        key: {{ .Values.secrets.secretKey.secretKey }}
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ include "parlance.databaseURLSecretName" . }}
        key: {{ .Values.secrets.databaseURL.secretKey }}
  {{- if .Values.parlance.sentry.dsn }}
  - name: SENTRY_DSN
    value: {{ .Values.parlance.sentry.dsn | quote }}
  {{- end }}
{{- end -}}

{{- define "parlance.allowedHosts" -}}
{{- if .Values.parlance.allowedHosts -}}
{{ .Values.parlance.allowedHosts }}
{{- else -}}
{{ default "localhost,127.0.0.1" (include "parlance.ingressHostnames" .) }}
{{- end -}}
{{- end -}}

{{- define "parlance.ingressHostnames" -}}
{{- if .Values.ingress.enabled -}}
{{- $list := list -}}
{{- range .Values.ingress.hosts -}}
{{- $list = append $list .host -}}
{{- end -}}
{{- join "," $list -}}
{{- end -}}
{{- end -}}

{{- define "parlance.secretKeySecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "parlance.fullname" . }}
{{- else -}}
{{ default (include "parlance.fullname" .) .Values.secrets.secretKey.secretName }}
{{- end -}}
{{- end -}}

{{- define "parlance.databaseURLSecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "parlance.fullname" . }}
{{- else -}}
{{ default (include "parlance.fullname" .) .Values.secrets.databaseURL.secretName }}
{{- end -}}
{{- end -}}