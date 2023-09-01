{{- define "kubeflow.modelsWebApp.fullname" -}}
{{ include "kubeflow.fullname" . }}-models-web-app
{{- end }}

{{- define "kubeflow.modelsWebApp.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.modelsWebApp.fullname" . }}
app: {{ include "kubeflow.modelsWebApp.fullname" . }}
{{- end }}

{{- define "kubeflow.modelsWebApp.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.modelsWebApp.matchLabels" . }}
{{- end }}