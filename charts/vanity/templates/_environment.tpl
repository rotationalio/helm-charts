{{/*
Vanity pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.
*/}}
{{- define "vanity.environment" -}}
env:
  - name: VANITY_MAINTENANCE
    value: {{ .Values.vanity.maintenance | quote }}
  - name: VANITY_DOMAIN
    value: {{ .Values.vanity.domain | quote }}
  - name: VANITY_DEFAULT_BRANCH
    value: {{ .Values.vanity.defaultBranch | quote }}
  - name: VANITY_CONFIG_MAP
    value: {{ .Values.vanity.configMap.mountPath }}/{{ .Values.vanity.configMap.key }}
  - name: VANITY_LOG_LEVEL
    value: {{ .Values.vanity.logLevel | quote }}
  - name: VANITY_BIND_ADDR
    value: ":{{ .Values.service.port }}"
{{- end -}}