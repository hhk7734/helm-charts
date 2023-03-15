{{- define "operator.operator.fullname" -}}
{{ include "operator.fullname" . }}
{{- end }}

{{- define "operator.operator.matchLabels" -}}
app.kubernetes.io/name: {{ include "operator.operator.fullname" . }}
app.kubernetes.io/component: knative-operator
app: {{ include "operator.operator.fullname" . }}
{{- end }}

{{- define "operator.operator.labels" }}
{{- include "operator.labels" . }}
{{ include "operator.operator.matchLabels" . }}
{{- end }}