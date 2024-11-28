{{- define "kubeflow.pipeline.fullname" -}}
{{ include "kubeflow.fullname" . }}-pipeline
{{- end }}
