{{- define "kubeflow.pipeline.visualizationServer.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-visualization
{{- end }}

{{- define "kubeflow.pipeline.visualizationServer.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.visualizationServer.fullname" . }}
app: {{ include "kubeflow.pipeline.visualizationServer.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.visualizationServer.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.visualizationServer.matchLabels" . }}
{{- end }}