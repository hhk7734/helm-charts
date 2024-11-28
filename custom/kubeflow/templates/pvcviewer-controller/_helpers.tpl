{{- define "kubeflow.pvcViewerController.fullname" -}}
{{ include "kubeflow.fullname" . }}-pvcviewer-controller
{{- end }}

{{- define "kubeflow.pvcViewerController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pvcViewerController.fullname" . }}
app: {{ include "kubeflow.pvcViewerController.fullname" . }}
{{- end }}

{{- define "kubeflow.pvcViewerController.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pvcViewerController.matchLabels" . }}
{{- end }}