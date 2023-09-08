{{- define "kubeflow.accessManagement.fullname" -}}
{{ include "kubeflow.fullname" . }}-access-management
{{- end }}

{{- define "kubeflow.accessManagement.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.accessManagement.fullname" . }}
app: {{ include "kubeflow.accessManagement.fullname" . }}
{{- end }}

{{- define "kubeflow.accessManagement.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.accessManagement.matchLabels" . }}
{{- end }}