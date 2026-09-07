{{/*
Rotational pods are configured primarily through the environment. Environment variables
from the values.yaml file are defined here and provided as configuration to the pod.

Sensitive values are directly injected into the environment, whereas all other
configuration values are placed into a configmap to make configuration changes easier.
*/}}
{{- define "<CHARTNAME>.environment" -}}
envFrom:
- configMapRef:
    name: {{ include "<CHARTNAME>.configMapName" . }}
env:
  - name: {{ include "envvar" "DATABASE_URL" }}
    {{ include "valueFromSecret" (list .Values.app.database.URL .) | nindent 4 }}
{{- end -}}

{{/*
Creates an environment variable name based on the prefix and the variable name.
For example if the if .Values.app.prefix is "SCENARIO" and the variable name is "DATABASE_URL",
the environment variable name will be "SCENARIO_DATABASE_URL". Otherwise it will be
"<CHARTNAME>_DATABASE_URL".
*/}}
{{- define "envvar" -}}
{{ "<CHARTNAME>" | upper }}_{{ . | upper }}
{{- end -}}

{{/*
Defines a secret key reference for the environment variable or the value if specified.
*/}}
{{- define "valueFromSecret" -}}
{{- $ := index . 1 -}}
{{- $ref := index . 0 -}}
{{- if $ref.value -}}
value: {{ $ref.value | quote }}
{{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ $ref.secretKeyRef.name | default (include "<CHARTNAME>.fullname" $ ) }}
    key: {{ $ref.secretKeyRef.key }}
{{- end -}}
{{- end -}}
