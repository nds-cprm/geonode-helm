{{/*
Expand the name of the chart.
*/}}
{{- define "geonode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "geonode.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "geonode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "geonode.labels" -}}
helm.sh/chart: {{ include "geonode.chart" . }}
{{ include "geonode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "geonode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "geonode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "geonode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "geonode.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Define configmaps
*/}}
{{- define "geonode.environment" -}}
{{- printf "%s-environment" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.uwsgi-override" -}}
{{- printf "%s-wsgi-override" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.settings-local" -}}
{{- printf "%s-settings-local" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.backup-restore-settings" -}}
{{- printf "%s-backup-restore-settings" (include "geonode.name" .) }}
{{- end }}


{{/*
Default host
*/}}
{{- define "geonode.hostname" -}}
{{- default (printf "%s.%s.%s" .Release.Name .Release.Namespace .Values.configs.domain) .Values.ingress.hostname }}
{{- end }}

{{/*
Define PVC names
*/}}
{{- define "geonode.backup-restore-pvc" -}}
{{- printf "%s-backup-restore" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.data-pvc" -}}
{{- printf "%s-data" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.geoserver-data-pvc" -}}
{{- printf "%s-geoserver-data" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.statics-pvc" -}}
{{- printf "%s-statics" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.tmp-pvc" -}}
{{- printf "%s-tmp" (include "geonode.name" .) }}
{{- end }}

{{/*
Define Secret names
*/}}
{{- define "geonode.main-secret" -}}
{{- printf "%s-main" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.database-secret" -}}
{{- printf "%s-database" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.mail-secret" -}}
{{- printf "%s-mail" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.recaptcha-secret" -}}
{{- printf "%s-recaptcha" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.memcached-secret" -}}
{{- printf "%s-memcached" (include "geonode.name" .) }}
{{- end }}

{{- define "geonode.ldap-secret" -}}
{{- printf "%s-ldap" (include "geonode.name" .) }}
{{- end }}

{{/*
DB Service - hostname
*/}}
{{- define "geonode.db.hostname" -}}
{{- if not .Values.postgresql.enabled }}
{{- $dbHost := .Values.configs.postgres.host -}}
{{- if not $dbHost }}
{{- fail "If services.db.external is True, you must set a valid PostgreSQL hostname" -}}
{{- end }} 
{{- $dbHost }}
{{- else -}}
{{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end }}
{{- end }}

{{/*
Memcached service - hostname
*/}}
{{- define "geonode.memcached.hostname" -}}
{{- if not .Values.memcached.enabled }}
{{- .Values.configs.memcached.location -}}
{{- else -}}
{{ $memcachedPort := ( default 11211 $.Values.memcached.service.ports.memcached ) | toString }}
{{- printf "%s-memcached.%s.svc.cluster.local:%s" .Release.Name .Release.Namespace $memcachedPort -}}
{{- end }}
{{- end }}
