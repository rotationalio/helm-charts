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

{{- define "endeavor.inferenceAPIKeySecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "endeavor.fullname" . }}
{{- else -}}
{{ default (include "endeavor.fullname" .) .Values.secrets.inferenceAPIKey.secretName }}
{{- end -}}
{{- end -}}

{{- define "endeavor.csrfSecretName" -}}
{{- if .Values.secrets.create -}}
{{ include "endeavor.fullname" . }}
{{- else -}}
{{ default (include "endeavor.fullname" .) .Values.secrets.csrfSecret.secretName }}
{{- end -}}
{{- end -}}

{{- define "endeavor.hostname" -}}
{{- if hasPrefix "https://" .Values.endeavor.origin  -}}
{{ trimPrefix "https://" .Values.endeavor.origin }}
{{- else if hasPrefix "http://" .Values.endeavor.origin -}}
{{ trimPrefix "http://" .Values.endeavor.origin }}
{{- else if hasPrefix "//" .Values.endeavor.origin -}}
{{ trimPrefix "//" .Values.endeavor.origin }}
{{- else -}}
{{ .Values.endeavor.origin }}
{{- end -}}
{{- end -}}