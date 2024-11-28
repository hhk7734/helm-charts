{{- define "rdmaSharedDevicePlugin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rdmaSharedDevicePlugin.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "rdmaSharedDevicePlugin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rdmaSharedDevicePlugin.matchLabels" -}}
app.kubernetes.io/name: {{ include "rdmaSharedDevicePlugin.fullname" . }}
app: {{ include "rdmaSharedDevicePlugin.fullname" . }}
{{- end }}

{{- define "rdmaSharedDevicePlugin.labels" -}}
{{- range $name, $value := .Values.commonLabels -}}
{{ $name }}: {{ tpl $value $ }}
{{ end -}}
helm.sh/chart: {{ include "rdmaSharedDevicePlugin.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "rdmaSharedDevicePlugin.matchLabels" . }}
{{- end }}

{{- define "rdmaSharedDevicePlugin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rdmaSharedDevicePlugin.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}