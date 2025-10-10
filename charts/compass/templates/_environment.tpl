{{/*
Compass is configured through a Django settings module, which loads sensitive settings
from environment variables. Configuration for these values are in the values.yaml file.
*/}}
{{- define "compass.environment" -}}
env:
  - name: DJANGO_DEBUG
    value: {{ if .Values.compass.django.debug }}"True"{{ else }}"False"{{ end }}
  - name: DJANGO_SETTINGS_MODULE
    value: {{ .Values.compass.django.settingsModule | quote }}
  - name: ALLOWED_HOSTS
    value: {{ include "compass.allowedHosts" . | quote }}
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.secretKeyName" . }}
        key: {{ .Values.secrets.secretKey.secretKey }}
  - name: COMPASS_DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.databaseURLName" . }}
        key: {{ .Values.secrets.databaseURL.secretKey }}
  - name: MEDIA_ROOT
    value: {{ .Values.compass.django.mediaRoot | quote }}
  {{- if .Values.compass.sentry.dsn }}
  - name: SENTRY_DSN
    value: {{ .Values.compass.sentry.dsn | quote }}
  {{- end }}
  - name: COMPASS_INFERENCE_ENDPOINT_URL
    value: {{ .Values.compass.inference.endpoint | quote }}
  - name: COMPASS_INFERENCE_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.openRouterAPIKeyName" . }}
        key: {{ .Values.secrets.openRouterAPIKey.secretKey }}
  - name: COMPASS_TRANSCRIPTION_MODEL
    value: {{ .Values.compass.inference.transcriptionModel | quote }}
  - name: COMPASS_AUDIO_UPLOAD_DIRECTORY
    value: {{ .Values.compass.audio.uploadDirectory | quote }}
  - name: COMPASS_AUDIO_MAX_FILES
    value: {{ .Values.compass.audio.maxAudioFiles | quote }}
  - name: COMPASS_DEFAULT_DOMAIN
    value: {{ .Values.compass.domain.default | quote }}
  - name: COMPASS_USE_GENERATED_DOMAIN
    value: {{ if .Values.compass.domain.useGenerated }}"True"{{ else }}"False"{{ end }}
  - name: ENDEAVOR_HOST
    value: {{ .Values.compass.endeavor.endpoint | quote }}
  - name: ENDEAVOR_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.endeavorClientIDName" . }}
        key: {{ .Values.secrets.endeavorClientID.secretKey }}
  - name: ENDEAVOR_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "compass.secrets.endeavorClientSecretName" . }}
        key: {{ .Values.secrets.endeavorClientSecret.secretKey }}
  - name: ENDEAVOR_AUTHENTICATION_ENDPOINT
    value: {{ .Values.compass.endeavor.authenticationEndpoint | quote }}
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
{{- join "," .Values.compass.allowedHosts -}}
{{- else -}}
"localhost,127.0.0.1"
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

{{- define "compass.secrets.openRouterAPIKeyName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.openRouterAPIKey.secretName }}
{{- end -}}
{{- end -}}

{{- define "compass.secrets.endeavorClientIDName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.endeavorClientID.secretName }}
{{- end -}}
{{- end -}}

{{- define "compass.secrets.endeavorClientSecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "compass.fullname" . }}
{{- else -}}
{{ default (include "compass.fullname" .) .Values.secrets.endeavorClientSecret.secretName }}
{{- end -}}
{{- end -}}