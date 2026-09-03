{{/*
Genoa pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "genoa.environment" -}}
env:
  - name: GENOA_LOCAL_ACCESS
    value: "false"
  - name: GENOA_LOG_LEVEL
    value: {{ .Values.genoa.logLevel | default .Values.global.logging.level | quote }}
  - name: GENOA_CONSOLE_LOG
    value: {{ .Values.genoa.consoleLog | default .Values.global.logging.console | quote }}
  - name: GENOA_RESOURCE_PATH
    value: {{ include "genoa.resourcePath" . | quote }}
  - name: GENOA_RELEASE
    value: {{ .Values.genoa.release | default (include "genoa.fullname" . ) | quote }}
  - name: GENOA_NAMESPACE
    value: {{ .Release.Namespace | quote }}
  {{- if .Values.genoa.adminDatabaseURL.secretName }}
  - name: GENOA_DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ .Values.genoa.adminDatabaseURL.secretName }}
        key: {{ .Values.genoa.adminDatabaseURL.secretKey }}
  {{- end }}
{{- end -}}

{{- define "genoa.resourcePath" -}}
{{- trimSuffix "/" .Values.config.mountPath -}}/{{ .Values.config.filename | default "genoa.yaml" }}
{{- end -}}
