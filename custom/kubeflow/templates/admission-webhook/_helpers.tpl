{{- define "kubeflow.admissionWebhook.fullname" -}}
{{ include "kubeflow.fullname" . }}-admission-webhook
{{- end }}

{{- define "kubeflow.admissionWebhook.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.admissionWebhook.fullname" . }}
app: {{ include "kubeflow.admissionWebhook.fullname" . }}
{{- end }}

{{- define "kubeflow.admissionWebhook.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.admissionWebhook.matchLabels" . }}
{{- end }}