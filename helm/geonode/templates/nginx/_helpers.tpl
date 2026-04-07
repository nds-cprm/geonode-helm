{{/*
Create a default fully qualified app name.
*/}}
{{- define "nginx.fullname" -}}
{{- $name := ( include "geonode.fullname" . ) | trunc 57 | trimSuffix "-" -}}
{{- printf "%s-nginx" $name }}
{{- end }}

{{/*
Nginx Common labels
*/}}
{{- define "nginx.labels" -}}
helm.sh/chart: {{ include "geonode.chart" . }}
{{ include "nginx.selectorLabels" . }}
{{- if .Values.services.nginx.tag }}
app.kubernetes.io/version: {{ .Values.services.nginx.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: nginx
app.kubernetes.io/component: reverse-proxy
app.kubernetes.io/part-of: geonode
{{- end }}

{{/*
Nginx Selector labels
*/}}
{{- define "nginx.selectorLabels" -}}
app.kubernetes.io/name: nginx
app.kubernetes.io/instance: {{ printf "%s-%s" ( .Release.Namespace ) ( include "nginx.fullname" . ) }}
{{- end }}

{{/*
Nginx Service - hostname
*/}}
{{- define "nginx.hostname" -}}
{{- printf "%s.%s.svc.cluster.local" ( include "nginx.fullname" . ) .Release.Namespace -}}
{{- end }}
