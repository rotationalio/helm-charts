{{/*
Endeavor pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "honu.environment" -}}
env:
  - name: HONU_PID
    value: {{ .Values.honu.pid | quote }}
  - name: HONU_MAINTENANCE
    value: {{ .Values.honu.maintenance | quote }}
  - name: HONU_LOG_LEVEL
    value: {{ .Values.honu.logLevel | quote }}
  - name: HONU_CONSOLE_LOG
    value: {{ .Values.honu.consoleLog | quote }}
  - name: HONU_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: HONU_READ_TIMEOUT
    value: {{ .Values.honu.readTimeOut | quote }}
  - name: HONU_WRITE_TIMEOUT
    value: {{ .Values.honu.writeTimeOut | quote }}
  - name: HONU_IDLE_TIMEOUT
    value: {{ .Values.honu.idleTimeOut | quote }}
  - name: HONU_STORE_READONLY
    value: {{ .Values.honu.store.readOnly | quote }}
  - name: HONU_STORE_DATA_PATH
    value: {{ .Values.honu.store.dataPath | quote }}
  - name: HONU_STORE_CONCURRENCY
    value: {{ .Values.honu.store.concurrency | quote }}
{{- end -}}
