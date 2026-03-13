{{/*
Rotational API pods are configured primarily through the environment. Environment
variables from the values.yaml file are defined here and provided as configuration
to the pod.
*/}}
{{- define "r8lapi.environment" -}}
env:
  - name: ROTATIONAL_MAINTENANCE
    value: {{ .Values.rotational.maintenance | quote }}
  - name: ROTATIONAL_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: ROTATIONAL_MODE
    value: {{ .Values.rotational.mode | quote }}
  - name: ROTATIONAL_LOG_LEVEL
    value: {{ .Values.rotational.logLevel | quote }}
  - name: ROTATIONAL_CONSOLE_LOG
    value: {{ .Values.rotational.consoleLog | quote }}
  {{- if .Values.rotational.allowOrigins }}
  - name: ROTATIONAL_ALLOW_ORIGINS
    value: {{ join "," .Values.rotational.allowOrigins | quote -}}
  {{- end }}
  {{- if and .Values.rotational.sendgrid .Values.rotational.sendgrid.infoEmail }}
  - name: ROTATIONAL_SENDGRID_INFO_EMAIL
    value: {{ .Values.rotational.sendgrid.infoEmail | quote }}
  {{- end }}
  {{- if and .Values.rotational.sendgrid .Values.rotational.sendgrid.fromEmail }}
  - name: ROTATIONAL_SENDGRID_FROM_EMAIL
    value: {{ .Values.rotational.sendgrid.fromEmail | quote }}
  {{- end }}
  - name: ROTATIONAL_ADMIN_USERNAME
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.adminUsername.secretName }}
        key: {{ .Values.secrets.adminUsername.secretKey }}
  - name: ROTATIONAL_ADMIN_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.adminPassword.secretName }}
        key: {{ .Values.secrets.adminPassword.secretKey }}
  - name: ROTATIONAL_SENDGRID_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.sendgridAPIKey.secretName }}
        key: {{ .Values.secrets.sendgridAPIKey.secretKey }}
  - name: ROTATIONAL_HUBSPOT_ACCESS_TOKEN
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.hubspotAccessToken.secretName }}
        key: {{ .Values.secrets.hubspotAccessToken.secretKey }}
  - name: ROTATIONAL_HUBSPOT_PORTAL_ID
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.hubspotPortalID.secretName }}
        key: {{ .Values.secrets.hubspotPortalID.secretKey }}
  - name: ROTATIONAL_HUBSPOT_CONTACT_FORM_ID
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.hubspotContactFormID.secretName }}
        key: {{ .Values.secrets.hubspotContactFormID.secretKey }}
  - name: ROTATIONAL_HUBSPOT_ENDEAVOR_FORM_ID
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.hubspotEndeavorFormID.secretName }}
        key: {{ .Values.secrets.hubspotEndeavorFormID.secretKey }}
  - name: ROTATIONAL_HUBSPOT_NEWSLETTER_FORM_ID
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.hubspotNewsletterFormID.secretName }}
        key: {{ .Values.secrets.hubspotNewsletterFormID.secretKey }}
  - name: ROTATIONAL_RECAPTCHA_PROJECT_ID
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.recaptchaProjectID.secretName }}
        key: {{ .Values.secrets.recaptchaProjectID.secretKey }}
  - name: ROTATIONAL_RECAPTCHA_KEY
    valueFrom:
      secretKeyRef:
        name: {{ default (include "r8lapi.fullname" .) .Values.secrets.recaptchaSecretKey.secretName }}
        key: {{ .Values.secrets.recaptchaSecretKey.secretKey }}
  {{- if .Values.secrets.googleApplicationCredentials.secretName }}
  - name: GOOGLE_APPLICATION_CREDENTIALS
    value: "{{ .Values.secrets.googleApplicationCredentials.mountPath }}/{{ .Values.secrets.googleApplicationCredentials.secretKey }}"
  {{- end }}
{{- end -}}
