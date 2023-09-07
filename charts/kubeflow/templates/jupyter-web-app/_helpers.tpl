{{- define "kubeflow.jupyterWebApp.fullname" -}}
{{ include "kubeflow.fullname" . }}-jupyter-web-app
{{- end }}

{{- define "kubeflow.jupyterWebApp.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.jupyterWebApp.fullname" . }}
app: {{ include "kubeflow.jupyterWebApp.fullname" . }}
{{- end }}

{{- define "kubeflow.jupyterWebApp.labels" }}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.jupyterWebApp.matchLabels" . }}
{{- end }}