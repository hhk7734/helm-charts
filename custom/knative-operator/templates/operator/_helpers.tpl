{{- define "operator.operator.fullname" -}}
{{ include "operator.fullname" . }}
{{- end -}}

{{- define "operator.operator.matchLabels" -}}
app.kubernetes.io/name: {{ include "operator.operator.fullname" . }}
app.kubernetes.io/component: knative-operator
app: {{ include "operator.operator.fullname" . }}
{{- end -}}

{{- define "operator.operator.labels" -}}
{{ include "operator.labels" . }}
{{ include "operator.operator.matchLabels" . }}
{{- end -}}

{{- define "operator.operator.image" -}}
{{- if .Values.operator.image.digest -}}
{{ printf "%s@%s" .Values.operator.image.repository .Values.operator.image.digest }}
{{- else -}}
{{- $tag := default "latest" .Values.operator.image.tag -}}
{{ printf "%s:%s" .Values.operator.image.repository $tag }}
{{- end -}}
{{- end -}}