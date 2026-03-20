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
Volume mounts for file:// blob storage (PVC-backed).
*/}}
{{- define "endeavor.volumeMounts" -}}
{{- if and .Values.endeavor.blobs.uri (hasPrefix "file://" .Values.endeavor.blobs.uri) }}
volumeMounts:
  - name: {{ include "endeavor.name" . }}-blobs
    mountPath: {{ include "endeavor.blobs.mountPath" . }}
{{- end }}
{{- end }}

{{/*
Pod volumes for file:// blob storage.
*/}}
{{- define "endeavor.volumes" -}}
{{- if and .Values.endeavor.blobs.uri (hasPrefix "file://" .Values.endeavor.blobs.uri) }}
volumes:
  - name: {{ include "endeavor.name" . }}-blobs
    persistentVolumeClaim:
      claimName: {{ include "endeavor.blobs.claimName" . }}
{{- end }}
{{- end }}
