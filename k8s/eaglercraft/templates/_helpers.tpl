{{/*
Expand the name of the chart.
*/}}
{{- define "eaglercraft.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "eaglercraft.fullname" -}}
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
{{- define "eaglercraft.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eaglercraft.labels" -}}
helm.sh/chart: {{ include "eaglercraft.chart" . }}
{{ include "eaglercraft.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eaglercraft.selectorLabels" -}}
app.kubernetes.io/name: {{ include "eaglercraft.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Nginx Proxy fullname
*/}}
{{- define "eaglercraft.nginxProxy.fullname" -}}
{{- printf "%s-nginx-proxy" (include "eaglercraft.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Nginx Proxy labels
*/}}
{{- define "eaglercraft.nginxProxy.labels" -}}
{{ include "eaglercraft.labels" . }}
app.kubernetes.io/component: nginx-proxy
{{- end }}

{{/*
Nginx Proxy selector labels
*/}}
{{- define "eaglercraft.nginxProxy.selectorLabels" -}}
{{ include "eaglercraft.selectorLabels" . }}
app.kubernetes.io/component: nginx-proxy
{{- end }}

{{/*
Landing Page fullname
*/}}
{{- define "eaglercraft.landingPage.fullname" -}}
{{- printf "%s-landing-page" (include "eaglercraft.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Landing Page labels
*/}}
{{- define "eaglercraft.landingPage.labels" -}}
{{ include "eaglercraft.labels" . }}
app.kubernetes.io/component: landing-page
{{- end }}

{{/*
Landing Page selector labels
*/}}
{{- define "eaglercraft.landingPage.selectorLabels" -}}
{{ include "eaglercraft.selectorLabels" . }}
app.kubernetes.io/component: landing-page
{{- end }}

{{/*
Eaglercraft fullname
*/}}
{{- define "eaglercraft.eaglercraft.fullname" -}}
{{- printf "%s-server" (include "eaglercraft.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Eaglercraft labels
*/}}
{{- define "eaglercraft.eaglercraft.labels" -}}
{{ include "eaglercraft.labels" . }}
app.kubernetes.io/component: game-server
{{- end }}

{{/*
Eaglercraft selector labels
*/}}
{{- define "eaglercraft.eaglercraft.selectorLabels" -}}
{{ include "eaglercraft.selectorLabels" . }}
app.kubernetes.io/component: game-server
{{- end }}
