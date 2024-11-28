{{- define "kubeflow.pipeline.pipelineRunner.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-pipeline-runner
{{- end }}

{{- define "kubeflow.pipeline.pipelineRunner.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.pipelineRunner.fullname" . }}
app: {{ include "kubeflow.pipeline.pipelineRunner.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.pipelineRunner.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.pipelineRunner.matchLabels" . }}
{{- end }}