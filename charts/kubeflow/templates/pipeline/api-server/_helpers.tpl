{{- define "kubeflow.pipeline.apiServer.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-api
{{- end }}

{{- define "kubeflow.pipeline.apiServer.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.apiServer.fullname" . }}
app: {{ include "kubeflow.pipeline.apiServer.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.apiServer.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.apiServer.matchLabels" . }}
{{- end }}