{{/*
Expand the name of the chart.
*/}}
{{- define "compass.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "compass.fullname" -}}
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
{{- define "compass.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "compass.labels" -}}
helm.sh/chart: {{ include "compass.chart" . }}
{{ include "compass.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "compass.selectorLabels" -}}
app.kubernetes.io/name: {{ include "compass.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the ingress to use
*/}}
{{- define "compass.ingressName" -}}
{{- default (include "compass.fullname" .) .Values.ingress.name }}
{{- end }}


{{/*
Volume mounts for uploads and audio files
*/}}
{{- define "compass.volumeMounts" -}}
volumeMounts:
  - name: tempdir
    mountPath: {{ .Values.compass.audio.uploadDirectory }}
  {{- include "compass.volumeMounts.nodeData" . | nindent 2 }}
{{- end }}

{{/*
Volume mounts for tuploads and audio files
*/}}
{{- define "compass.volumeMounts.nodeData" -}}
- name: {{ include "compass.name" . }}
  mountPath: {{ .Values.compass.django.mediaRoot }}
{{- end }}