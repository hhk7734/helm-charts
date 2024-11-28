{{- define "kubeflow.pipeline.viewerController.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-viewer
{{- end }}

{{- define "kubeflow.pipeline.viewerController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.viewerController.fullname" . }}
app: {{ include "kubeflow.pipeline.viewerController.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.viewerController.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.viewerController.matchLabels" . }}
{{- end }}