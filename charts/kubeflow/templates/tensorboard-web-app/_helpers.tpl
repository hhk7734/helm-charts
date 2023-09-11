{{- define "kubeflow.tensorboardWebApp.fullname" -}}
{{ include "kubeflow.fullname" . }}-tensorboard-web-app
{{- end }}

{{- define "kubeflow.tensorboardWebApp.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.tensorboardWebApp.fullname" . }}
app: {{ include "kubeflow.tensorboardWebApp.fullname" . }}
{{- end }}

{{- define "kubeflow.tensorboardWebApp.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.tensorboardWebApp.matchLabels" . }}
{{- end }}