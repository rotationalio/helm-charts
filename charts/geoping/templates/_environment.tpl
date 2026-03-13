{{/*
Geoping pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "geoping.environment" -}}
env:
  - name: GEOPING_MAINTENANCE
    value: {{ .Values.geoping.maintenance | quote }}
  - name: GEOPING_LOG_LEVEL
    value: {{ .Values.geoping.logLevel | quote }}
  - name: GEOPING_CONSOLE_LOG
    value: {{ .Values.geoping.consoleLog | quote }}
  - name: GEOPING_GRPC_BIND_ADDR
    value: ":{{ .Values.services.grpc.port }}"
  - name: GEOPING_WEB_BIND_ADDR
    value: ":{{ .Values.services.web.port }}"
  {{- if .Values.regioninfo.enabled }}
  {{- $configMap := default "region-info" .Values.regioninfo.configMap }}
  - name: REGION_INFO_ID
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_ID
  - name: REGION_INFO_NAME
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_NAME
  - name: REGION_INFO_COUNTRY
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_COUNTRY
  - name: REGION_INFO_CLOUD
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_CLOUD
  - name: REGION_INFO_ZONE
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_ZONE
  - name: REGION_INFO_CLUSTER
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_CLUSTER
  {{- end }}
{{- end -}}