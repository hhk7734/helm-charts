{{- define "kubeflow.pipeline.metadataWriter.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-metadata-writer
{{- end }}

{{- define "kubeflow.pipeline.metadataWriter.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.metadataWriter.fullname" . }}
app: {{ include "kubeflow.pipeline.metadataWriter.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.metadataWriter.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.metadataWriter.matchLabels" . }}
{{- end }}