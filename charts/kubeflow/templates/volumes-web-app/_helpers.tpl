{{- define "kubeflow.volumesWebApp.fullname" -}}
{{ include "kubeflow.fullname" . }}-volumes-web-app
{{- end }}

{{- define "kubeflow.volumesWebApp.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.volumesWebApp.fullname" . }}
app: {{ include "kubeflow.volumesWebApp.fullname" . }}
{{- end }}

{{- define "kubeflow.volumesWebApp.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.volumesWebApp.matchLabels" . }}
{{- end }}