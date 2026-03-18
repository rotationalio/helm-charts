{{/*
Imgtag pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "imgtag.environment" -}}
env:
  - name: IMGTAG_DATA_DIR
    value: {{ .Values.imgtag.dataDir | quote }}
  - name: IMGTAG_PROJECT
    value: {{ .Values.imgtag.project | quote }}
  - name: IMGTAG_LABELS
    value: {{ .Values.imgtag.labels | join "," | quote }}
  - name: IMGTAG_TASKS
    value: {{ .Values.imgtag.tasks | join "," | quote }}
  - name: IMGTAG_WIDTH
    value: {{ .Values.imgtag.width | quote }}
  - name: PRODIGY_HOST
    value: {{ .Values.prodigy.host | quote }}
  - name: PRODIGY_PORT
    value: {{ .Values.prodigy.port | quote }}
  - name: PRODIGY_LOGGING
    value: {{ .Values.prodigy.logging | quote }}
  - name: PRODIGY_OIDC_AUTH_ENABLED
    value: {{ if .Values.prodigy.oidc.enabled }}"1"{{ else }}"0"{{ end }}
  - name: PRODIGY_OIDC_DISCOVERY_URL
    value: {{ .Values.prodigy.oidc.discoveryURL | quote }}
  - name: PRODIGY_OIDC_CLIENT_ID
    value: {{ .Values.prodigy.oidc.clientID | quote }}
  - name: PRODIGY_DEPLOYED_URL
    value: {{ .Values.prodigy.deployedURL | quote }}
  - name: GCS_BUCKET
    value: {{ .Values.gcs.bucket | quote }}
  - name: GOOGLE_APPLICATION_CREDENTIALS
    value: "{{ .Values.secrets.googleApplicationCredentials.mountPath }}/{{ .Values.secrets.googleApplicationCredentials.secretKey }}"
  - name: PRODIGY_OIDC_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ default (include "imgtag.fullname" .) .Values.secrets.oidcClientSecret.secretName }}
        key: {{ .Values.secrets.oidcClientSecret.secretKey }}
{{- end -}}