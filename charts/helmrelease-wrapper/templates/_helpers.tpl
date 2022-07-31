{{/*
  Replace vars in $.Values.template with values from $vars.
*/}}
{{- define "replace-vars" -}}
{{- range keys $.vars -}}
{{- if has (kindOf (get $.vars .)) (list "map" "slice") -}}
{{- $_ := set $ "template" ((regexReplaceAll (printf "'{ var:%s }'" .) ($.template | toYaml) (get $.vars . | toJson)) | fromYaml) -}}
{{- else -}}
{{- $_ := set $ "template" ((regexReplaceAll (printf "{ var:%s }" .) ($.template | toYaml) (get $.vars . | toString)) | fromYaml) -}}
{{- end -}}
{{- end -}}
{{ $.template | toYaml }}
{{- end -}}

{{/*
  Check for missing replaces vars
*/}}
{{- define "missing-vars" -}}
{{- $missing := regexFindAll "{ var:[a-zA-Z0-9-_]+ }" ($.template | toYaml) -1 | uniq -}}
{{- if $missing -}}
{{- $error := printf "Missing required variable '%s' for %s/%s." (regexReplaceAll "{ var:([a-zA-Z0-9-_]+) }" (first $missing) "${1}") .name .namespace  -}}
{{- fail $error -}}
{{- end -}}
{{- end -}}

{{/*
  Parse config into per-release configuration
*/}}
{{- define "releases" -}}
{{- $config := printf "items:\n%s" (indent 2 (default "{}" .Values.config)) | fromYaml -}}
{{- $releases := printf "{ releases: false }" | fromYaml -}}
{{- if .Values.configKey -}}
  {{- if hasKey $config.items .Values.configKey -}}
    {{- $_ := set $releases "releases" (get $config.items .Values.configKey) -}}
    {{- if kindIs "map" $releases.releases -}}
      {{- $_ := set $releases "releases" (list $releases.releases) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if empty $releases.releases -}}
  {{- if .Values.required -}}
    {{- fail "Require at least one item in 'config'" -}}
  {{- end -}}
{{- end -}}
{{ $releases | toYaml }}
{{- end -}}
