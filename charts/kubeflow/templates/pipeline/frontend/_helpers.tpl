{{- define "kubeflow.pipeline.frontend.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-ui
{{- end }}

{{- define "kubeflow.pipeline.frontend.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.frontend.fullname" . }}
app: {{ include "kubeflow.pipeline.frontend.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.frontend.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.frontend.matchLabels" . }}
{{- end }}