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
{{- if or .Values.annotations .Values.pod.annotations }}
annotations:
  {{- with .Values.annotations }}
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with .Values.pod.annotations }}
    {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
All volume mounts for the Quarterdeck pods.
- database volume mount if databaseURL is sqlite3
- jwks secret volume mount if jwks keys are provided.
- security.txt config map mount if securitytxt.text is provided.
- additional volume mounts from .Values.volumeMounts
*/}}
{{- define "quarterdeck.volumeMounts" -}}
volumeMounts:
  {{- include "quarterdeck.volumeMounts.database" . | nindent 2 -}}
  {{- include "quarterdeck.volumeMounts.jwks" . | nindent 2  -}}
  {{- include "quarterdeck.volumeMounts.securitytxt" . | nindent 2 -}}
  {{- include "quarterdeck.volumeMounts.welcomeEmail" . | nindent 2 -}}
{{- end }}

{{/*
Volume mounts for database storage if using sqlite3.
*/}}
{{- define "quarterdeck.volumeMounts.database" -}}
- name: {{ include "quarterdeck.name" . }}-database
  mountPath: {{ .Values.storage.database.mountPath }}
{{- end -}}

{{- define "quarterdeck.volumeMounts.jwks" -}}
{{- if and .Values.quarterdeck.auth.keys .Values.secrets.jwks.secretName -}}
- name: {{ include "quarterdeck.name" . }}-jwks
  mountPath: {{ default "/data/jwks" .Values.secrets.jwks.mountPath }}
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumeMounts.securitytxt" -}}
{{- if .Values.quarterdeck.securitytxt.text -}}
- name: {{ include "quarterdeck.name" . }}-securitytxt
  mountPath: {{ default "/data/info" (dir .Values.quarterdeck.securitytxt.path) }}
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumeMounts.welcomeEmail" -}}
- name: {{ include "quarterdeck.app.welcomeEmail.configMap.name" . }}
  mountPath: {{ .Values.quarterdeck.app.welcomeEmail.mountPath }}
  readOnly: true
{{- end -}}

{{/*
All volumes for the Quarterdeck pods.
- jwks secret mount if jwks keys are provided.
- security.txt config map mount if securitytxt.text is provided.
- additional volumes from .Values.volumes
*/}}
{{- define "quarterdeck.volumes" -}}
{{- with $volumes := (include "quarterdeck.volumes.all" .) -}}
volumes:
  {{- $volumes }}
{{- end }}
{{- end }}

{{- define "quarterdeck.volumes.all" -}}
  {{- include "quarterdeck.volumes.jwks" . | nindent 2 -}}
  {{- include "quarterdeck.volumes.securitytxt" . | nindent 2 -}}
  {{- include "quarterdeck.volumes.welcomeEmail" . | nindent 2 -}}
{{- end -}}

{{- define "quarterdeck.volumes.jwks" -}}
{{- if and .Values.quarterdeck.auth.keys .Values.secrets.jwks.secretName -}}
- name: {{ include "quarterdeck.name" . }}-jwks
  secret:
    secretName: {{ .Values.secrets.jwks.secretName }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumes.securitytxt" -}}
{{- if .Values.quarterdeck.securitytxt.text -}}
- name: {{ include "quarterdeck.name" . }}-securitytxt
  configMap:
    name: {{ include "quarterdeck.name" . }}-securitytxt
{{- end -}}
{{- end -}}

{{- define "quarterdeck.volumes.welcomeEmail" -}}
{{- if or .Values.quarterdeck.app.welcomeEmail.create .Values.quarterdeck.app.welcomeEmail.configMap -}}
- name: {{ include "quarterdeck.app.welcomeEmail.configMap.name" . }}
  configMap:
    name: {{ include "quarterdeck.app.welcomeEmail.configMap.name" . }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.hostname" -}}
{{- if hasPrefix "https://" .Values.global.issuer  -}}
{{ trimPrefix "https://" .Values.global.issuer }}
{{- else if hasPrefix "http://" .Values.global.issuer -}}
{{ trimPrefix "http://" .Values.global.issuer }}
{{- else if hasPrefix "//" .Values.global.issuer -}}
{{ trimPrefix "//" .Values.global.issuer }}
{{- else -}}
{{ .Values.global.issuer }}
{{- end -}}
{{- end -}}

{{- define "quarterdeck.app.welcomeEmail.configMap.name" -}}
{{- if .Values.quarterdeck.app.welcomeEmail.configMap -}}
{{ .Values.quarterdeck.app.welcomeEmail.configMap }}
{{- else -}}
{{ include "quarterdeck.name" . }}-welcome-emails
{{- end -}}
{{- end -}}