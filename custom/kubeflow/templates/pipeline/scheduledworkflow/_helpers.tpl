{{- define "kubeflow.pipeline.scheduledWorkflow.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-scheduleworkflow
{{- end }}

{{- define "kubeflow.pipeline.scheduledWorkflow.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.scheduledWorkflow.fullname" . }}
app: {{ include "kubeflow.pipeline.scheduledWorkflow.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.scheduledWorkflow.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.scheduledWorkflow.matchLabels" . }}
{{- end }}