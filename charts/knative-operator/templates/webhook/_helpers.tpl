{{- define "operator.webhook.fullname" -}}
{{ include "operator.fullname" . }}-webhook
{{- end }}

{{- define "operator.webhook.matchLabels" -}}
app.kubernetes.io/name: {{ include "operator.webhook.fullname" . }}
app.kubernetes.io/component: knative-operator-webhook
app: {{ include "operator.webhook.fullname" . }}
{{- end }}

{{- define "operator.webhook.labels" }}
{{- include "operator.labels" . }}
{{ include "operator.webhook.matchLabels" . }}
{{- end }}