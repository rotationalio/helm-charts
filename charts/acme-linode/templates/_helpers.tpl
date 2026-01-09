{{/*
Expand the name of the chart.
*/}}
{{- define "acme-linode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "acme-linode.fullname" -}}
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
{{- define "acme-linode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "acme-linode.labels" -}}
helm.sh/chart: {{ include "acme-linode.chart" . }}
{{ include "acme-linode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "acme-linode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "acme-linode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace must be the same as the one cert-manager is deployed in.
*/}}
{{- define "acme-linode.namespace" -}}
{{ default .Values.certManager.namespace .Release.Namespace }}
{{- end }}

{{/*
Names for various certificates and issuers as described by the acme webhook example.
*/}}
{{- define "acme-linode.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "acme-linode.fullname" .) }}
{{- end -}}

{{- define "acme-linode.rootCAIssuer" -}}
{{ printf "%s-ca" (include "acme-linode.fullname" .) }}
{{- end -}}

{{- define "acme-linode.rootCACertificate" -}}
{{ printf "%s-ca" (include "acme-linode.fullname" .) }}
{{- end -}}

{{- define "acme-linode.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "acme-linode.fullname" .) }}
{{- end -}}