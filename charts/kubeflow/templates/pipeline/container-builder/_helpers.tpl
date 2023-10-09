{{- define "kubeflow.pipeline.containerBuilder.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-container-builder
{{- end }}

{{- define "kubeflow.pipeline.containerBuilder.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.containerBuilder.fullname" . }}
app: {{ include "kubeflow.pipeline.containerBuilder.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.containerBuilder.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.containerBuilder.matchLabels" . }}
{{- end }}