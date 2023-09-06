{{- define "kubeflow.pipeline.persistenceAgent.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-persistenceagent
{{- end }}

{{- define "kubeflow.pipeline.persistenceAgent.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.persistenceAgent.fullname" . }}
app: {{ include "kubeflow.pipeline.persistenceAgent.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.persistenceAgent.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.persistenceAgent.matchLabels" . }}
{{- end }}