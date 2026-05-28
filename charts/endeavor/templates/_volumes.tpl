{{/*
PVC name for chart-managed blob storage (stable per release).
*/}}
{{- define "endeavor.blobs.pvcName" -}}
{{- printf "%s-blobs" (include "endeavor.fullname" .) }}
{{- end }}

{{/*
Resolved mount path inside the container for file:// blob URIs.
*/}}
{{- define "endeavor.blobs.mountPath" -}}
{{- trimPrefix "file://" (default "" .Values.endeavor.blobs.uri) }}
{{- end }}

{{/*
Resolved PersistentVolumeClaim name for the blob volume (existing or chart-created).
*/}}
{{- define "endeavor.blobs.claimName" -}}
{{- if .Values.storage.blobs.existingClaim }}
{{- .Values.storage.blobs.existingClaim }}
{{- else }}
{{- include "endeavor.blobs.pvcName" . }}
{{- end }}
{{- end }}

{{/*
Volume mounts for file:// blob PVC and/or ephemeral task archive storage.
*/}}
{{- define "endeavor.volumeMounts" -}}
{{- $fileBlobs := and .Values.endeavor.blobs.uri (hasPrefix "file://" .Values.endeavor.blobs.uri) }}
{{- $tasksVol := or .Values.endeavor.tasks.enableLoader .Values.endeavor.tasks.beacon.beaconUrl }}
{{- if or $fileBlobs $tasksVol }}
volumeMounts:
{{- if $fileBlobs }}
  - name: {{ include "endeavor.name" . }}-blobs
    mountPath: {{ include "endeavor.blobs.mountPath" . }}
{{- end }}
{{- if $tasksVol }}
  - name: {{ include "endeavor.name" . }}-tasks
    mountPath: {{ .Values.storage.tasks.mountPath }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Pod volumes for file:// blob PVC and/or ephemeral task archive storage.
*/}}
{{- define "endeavor.volumes" -}}
{{- $fileBlobs := and .Values.endeavor.blobs.uri (hasPrefix "file://" .Values.endeavor.blobs.uri) }}
{{- $tasksVol := or .Values.endeavor.tasks.enableLoader .Values.endeavor.tasks.beacon.beaconUrl }}
{{- if or $fileBlobs $tasksVol }}
volumes:
{{- if $fileBlobs }}
  - name: {{ include "endeavor.name" . }}-blobs
    persistentVolumeClaim:
      claimName: {{ include "endeavor.blobs.claimName" . }}
{{- end }}
{{- if $tasksVol }}
  - name: {{ include "endeavor.name" . }}-tasks
    emptyDir:
      {{- with .Values.storage.tasks.emptyDir }}
      {{- toYaml . | nindent 6 }}
      {{- else }}
      {}
      {{- end }}
{{- end }}
{{- end }}
{{- end }}
