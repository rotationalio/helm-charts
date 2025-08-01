{{/*
Expand the name of the chart.
*/}}
{{- define "endeavor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "endeavor.fullname" -}}
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
{{- define "endeavor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "endeavor.labels" -}}
helm.sh/chart: {{ include "endeavor.chart" . }}
{{ include "endeavor.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "endeavor.selectorLabels" -}}
app.kubernetes.io/name: {{ include "endeavor.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Volume mounts for the database
*/}}
{{- define "endeavor.volumeMounts" -}}
volumeMounts:
  {{- include "endeavor.volumeMounts.nodeData" . | nindent 2 }}
{{- end }}

{{/*
Volume mounts for the database
*/}}
{{- define "endeavor.volumeMounts.nodeData" -}}
- name: {{ include "endeavor.name" . }}
  mountPath: {{ .Values.storage.nodeData.mountPath }}
{{- end }}
