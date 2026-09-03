{{/*
Expand the name of the chart.
*/}}
{{- define "genoa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "genoa.fullname" -}}
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
{{- define "genoa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "genoa.labels" -}}
helm.sh/chart: {{ include "genoa.chart" . }}
{{ include "genoa.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "genoa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "genoa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Annotations for the Genoa job.
Must specify the lifecycle and order variables, e.g.

{{- include "genoa.annotations" (dict "lifecycle" .Release.Service "order" -2) }}
*/}}
{{- define "genoa.annotations" -}}
{{- if eq .lifecycle "Helm" -}}
helm.sh/hook: pre-upgrade,pre-install
helm.sh/hook-weight: {{ .order | quote }}
helm.sh/hook-delete-policy: before-hook-creation
{{- end }}
{{- if eq .lifecycle "ArgoCD" -}}
argocd.argoproj.io/hook: PreSync
argocd.argoproj.io/sync-wave: {{ .order | quote }}
argocd.argoproj.io/hook-delete-policy: HookSucceeded
{{- end }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "genoa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "genoa.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
