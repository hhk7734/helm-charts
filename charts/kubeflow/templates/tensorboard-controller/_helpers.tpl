{{- define "kubeflow.tensorboardController.fullname" -}}
{{ include "kubeflow.fullname" . }}-tensorboard-controller
{{- end }}

{{- define "kubeflow.tensorboardController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.tensorboardController.fullname" . }}
app: {{ include "kubeflow.tensorboardController.fullname" . }}
{{- end }}

{{- define "kubeflow.tensorboardController.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.tensorboardController.matchLabels" . }}
{{- end }}