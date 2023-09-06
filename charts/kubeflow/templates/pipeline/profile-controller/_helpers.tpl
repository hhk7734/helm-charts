{{- define "kubeflow.pipeline.profileController.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-profile-controller
{{- end }}

{{- define "kubeflow.pipeline.profileController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.profileController.fullname" . }}
app: {{ include "kubeflow.pipeline.profileController.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.profileController.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.profileController.matchLabels" . }}
{{- end }}