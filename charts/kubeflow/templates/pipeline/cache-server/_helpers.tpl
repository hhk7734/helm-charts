{{- define "kubeflow.pipeline.cacheServer.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-cache-server
{{- end }}

{{- define "kubeflow.pipeline.cacheServer.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.cacheServer.fullname" . }}
app: {{ include "kubeflow.pipeline.cacheServer.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.cacheServer.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.cacheServer.matchLabels" . }}
{{- end }}