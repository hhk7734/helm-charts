{{- define "kubeflow.pipeline.mysql.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-mysql
{{- end }}

{{- define "kubeflow.pipeline.mysql.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.mysql.fullname" . }}
app: {{ include "kubeflow.pipeline.mysql.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.mysql.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.mysql.matchLabels" . }}
{{- end }}
