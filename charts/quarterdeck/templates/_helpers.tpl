{{/*
Expand the name of the chart.
*/}}
{{- define "quarterdeck.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quarterdeck.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "quarterdeck.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quarterdeck.labels" -}}
helm.sh/chart: {{ include "quarterdeck.chart" . }}
{{ include "quarterdeck.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: endeavor
app.kubernetes.io/component: identity-provider
{{- end }}

{{/*
Selector labels
*/}}
{{- define "quarterdeck.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quarterdeck.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod annotations includes both global annotations and the pod-specific ones.
*/}}
{{- define "quarterdeck.podAnnotations" -}}
{{- if or .Values.annotations .Values.pod.annotations -}}
annotations:
  {{- with .Values.annotations -}}
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.pod.annotations -}}
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
All volume mounts for the Quarterdeck pods.
- database volume mount if databaseURL is sqlite3
- keys secret volume mount if keys are provided.
- security.txt config map mount if securitytxt.text is provided.
- additional volume mounts from .Values.volumeMounts
*/}}
{{- define "quarterdeck.volumeMounts" -}}
volumeMounts:
  {{- include "quarterdeck.volumeMounts.database" . | nindent 2 }}
  {{- include "quarterdeck.volumeMounts.keys" . | nindent 2 }}
  {{- include "quarterdeck.volumeMounts.securitytxt" . | nindent 0 }}
{{- end -}}

{{/*
Volume mounts for database storage if using sqlite3.
*/}}
{{- define "quarterdeck.volumeMounts.database" -}}
- name: {{ include "quarterdeck.name" . }}-database
  mountPath: {{ .Values.storage.database.mountPath }}
{{- end }}

{{- define "quarterdeck.volumeMounts.keys" -}}
{{- if and .Values.authentication.keys .Values.authentication.keysSecret.name -}}
- name: {{ include "quarterdeck.name" . }}-keys
  mountPath: {{ default "/data/keys" .Values.authentication.keysSecret.mountPath }}
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumeMounts.securitytxt" -}}
{{- if .Values.securitytxt.text -}}
- name: {{ include "quarterdeck.name" . }}-securitytxt
  mountPath: {{ default "/data/info" (dir .Values.securitytxt.path) }}
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
All volumes for the Quarterdeck pods.
- Keys secret mount if keys are provided.
- security.txt config map mount if securitytxt.text is provided.
- additional volumes from .Values.volumes
*/}}
{{- define "quarterdeck.volumes" -}}
{{- with $volumes := (include "quarterdeck.volumes.all" .) -}}
volumes:
  {{- $volumes | nindent 0 -}}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumes.all" -}}
  {{- include "quarterdeck.volumes.keys" . | nindent 0 -}}
  {{- include "quarterdeck.volumes.securitytxt" . | nindent 0 -}}
{{- end -}}

{{- define "quarterdeck.volumes.keys" -}}
{{- if and .Values.authentication.keys .Values.authentication.keysSecret.name -}}
- name: {{ include "quarterdeck.name" . }}-keys
  secret:
    secretName: {{ .Values.authentication.keysSecret.name }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumes.securitytxt" -}}
{{- if .Values.securitytxt.text -}}
- name: {{ include "quarterdeck.name" . }}-securitytxt
  configMap:
    name: {{ include "quarterdeck.name" . }}-securitytxt
{{- end -}}
{{- end -}}

