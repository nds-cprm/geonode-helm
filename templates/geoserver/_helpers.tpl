{{/*
Create a default fully qualified app name.
*/}}
{{- define "geoserver.fullname" -}}
{{- $name := ( include "geonode.fullname" . ) | trunc 57 | trimSuffix "-" -}}
{{- printf "%s-geoserver" $name }}
{{- end }}

{{/*
Geoserver Common labels
*/}}
{{- define "geoserver.labels" -}}
helm.sh/chart: {{ include "geonode.chart" . }}
{{ include "geoserver.selectorLabels" . }}
{{- if .Values.services.geoserver.image.app.tag }}
app.kubernetes.io/version: {{ .Values.services.geoserver.image.app.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: hibernate
app.kubernetes.io/component: ogc-server
app.kubernetes.io/part-of: geonode
{{- end }}

{{/*
Geoserver Selector labels
*/}}
{{- define "geoserver.selectorLabels" -}}
app.kubernetes.io/name: geoserver
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Geoserver Service - hostname
*/}}
{{- define "geoserver.hostname" -}}
{{- printf "%s.%s.svc.cluster.local" ( include "geoserver.fullname" . ) .Release.Namespace -}}
{{- end }}

{{- define "geoserver.internalPath" -}}
{{- printf "http://%s:%d/geoserver" ( include "geoserver.hostname" . ) ( .Values.services.geoserver.servicePort | int ) -}}
{{- end }}