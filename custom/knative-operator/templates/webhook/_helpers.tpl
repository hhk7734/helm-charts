{{- define "operator.webhook.fullname" -}}
{{ include "operator.fullname" . }}-webhook
{{- end -}}

{{- define "operator.webhook.matchLabels" -}}
app.kubernetes.io/name: {{ include "operator.webhook.fullname" . }}
app.kubernetes.io/component: knative-operator-webhook
app: {{ include "operator.webhook.fullname" . }}
{{- end -}}

{{- define "operator.webhook.labels" -}}
{{ include "operator.labels" . }}
{{ include "operator.webhook.matchLabels" . }}
{{- end -}}

{{- define "operator.webhook.image" -}}
{{- if .Values.webhook.image.digest -}}
{{ printf "%s@%s" .Values.webhook.image.repository .Values.webhook.image.digest }}
{{- else -}}
{{- $tag := default "latest" .Values.webhook.image.tag -}}
{{ printf "%s:%s" .Values.webhook.image.repository $tag }}
{{- end -}}
{{- end -}}