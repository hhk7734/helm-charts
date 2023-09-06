{{- define "kubeflow.centralDashboard.fullname" -}}
{{ include "kubeflow.fullname" . }}-centraldashboard
{{- end }}

{{- define "kubeflow.centralDashboard.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.centralDashboard.fullname" . }}
app: {{ include "kubeflow.centralDashboard.fullname" . }}
{{- end }}

{{- define "kubeflow.centralDashboard.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.centralDashboard.matchLabels" . }}
{{- end }}