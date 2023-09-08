{{- define "kubeflow.notebookController.fullname" -}}
{{ include "kubeflow.fullname" . }}-notebook-controller
{{- end }}

{{- define "kubeflow.notebookController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.notebookController.fullname" . }}
app: {{ include "kubeflow.notebookController.fullname" . }}
{{- end }}

{{- define "kubeflow.notebookController.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.notebookController.matchLabels" . }}
{{- end }}