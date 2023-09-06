{{- define "kubeflow.profileController.fullname" -}}
{{ include "kubeflow.fullname" . }}-profile-controller
{{- end }}

{{- define "kubeflow.profileController.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.profileController.fullname" . }}
app: {{ include "kubeflow.profileController.fullname" . }}
{{- end }}

{{- define "kubeflow.profileController.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.profileController.matchLabels" . }}
{{- end }}