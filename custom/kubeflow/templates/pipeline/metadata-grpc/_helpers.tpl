{{- define "kubeflow.pipeline.metadataGRPC.fullname" -}}
{{ include "kubeflow.pipeline.fullname" . }}-metadata-grpc
{{- end }}

{{- define "kubeflow.pipeline.metadataGRPC.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.metadataGRPC.fullname" . }}
app: {{ include "kubeflow.pipeline.metadataGRPC.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.metadataGRPC.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.metadataGRPC.matchLabels" . }}
{{- end }}

{{- define "kubeflow.pipeline.metadataGRPC.envoy.fullname" -}}
{{ include "kubeflow.pipeline.metadataGRPC.fullname" . }}-envoy
{{- end }}

{{- define "kubeflow.pipeline.metadataGRPC.envoy.matchLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.pipeline.metadataGRPC.envoy.fullname" . }}
app: {{ include "kubeflow.pipeline.metadataGRPC.envoy.fullname" . }}
{{- end }}

{{- define "kubeflow.pipeline.metadataGRPC.envoy.labels" -}}
{{- include "kubeflow.labels" . }}
{{ include "kubeflow.pipeline.metadataGRPC.envoy.matchLabels" . }}
{{- end }}