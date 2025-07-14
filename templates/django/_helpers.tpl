# Django helpers
{{/*
Create a default fully qualified app name.
*/}}
{{- define "django.fullname" -}}
{{- $name := ( include "geonode.fullname" . ) | trunc 57 | trimSuffix "-" -}}
{{- printf "%s-django" $name }}
{{- end }}

{{/*
Django Common labels
*/}}
{{- define "django.labels" -}}
helm.sh/chart: {{ include "geonode.chart" . }}
{{ include "django.selectorLabels" . }}
{{- if .Values.services.django.image.tag }}
app.kubernetes.io/version: {{ .Values.services.django.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime: django
app.kubernetes.io/component: backend
app.kubernetes.io/part-of: geonode
{{- end }}

{{/*
Django Selector labels
*/}}
{{- define "django.selectorLabels" -}}
app.kubernetes.io/name: django
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Django Service - hostname
*/}}
{{- define "django.hostname" -}}
{{- printf "%s.%s.svc.cluster.local" ( include "django.fullname" . ) .Release.Namespace -}}
{{- end }}

{{- define "django.internalPath" -}}
{{- printf "http://%s:%d" ( include "django.hostname" . ) ( .Values.services.django.servicePort | int ) -}}
{{- end }}
