# Celery helpers
{{/*
Create a default fully qualified app name.
*/}}
{{- define "celery.fullname" -}}
{{- $name := ( include "geonode.fullname" . ) | trunc 57 | trimSuffix "-" -}}
{{- printf "%s-celery" $name }}
{{- end }}

{{/*
Celery Common labels
*/}}
{{- define "celery.labels" -}}
helm.sh/chart: {{ include "geonode.chart" . }}
{{ include "celery.selectorLabels" . }}
{{- if .Values.services.celery.image.tag }}
app.kubernetes.io/version: {{ .Values.services.celery.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: celery
app.kubernetes.io/component: worker
app.kubernetes.io/part-of: geonode
{{- end }}

{{/*
Celery Selector labels
*/}}
{{- define "celery.selectorLabels" -}}
app.kubernetes.io/name: celery
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
