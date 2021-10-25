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
  Parse config
*/}}
{{- define "config" -}}
{{- $configitems := printf "items:\n%s" (indent 2 (default "[]" .Values.config)) | fromYaml -}}
{{- if .Values.configKey -}}
  {{- if kindIs "map" $configitems.items -}}
    {{- if hasKey $configitems.items .Values.configKey -}}
      {{- $_ := set $configitems "items" (get $configitems.items .Values.configKey) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if empty $configitems.items -}}
  {{- if .Values.required -}}
  {{- fail "Require at least one item in 'config'" -}}
  {{- end -}}
{{- else if kindIs "map" $configitems.items -}}
  {{- $_ := set $configitems "items" (list $configitems.items) -}}
{{- end -}}
{{- if not (kindIs "slice" $configitems.items) -}}
{{- fail "Expecting a list or a dict for 'config'" -}}
{{- end -}}
{{ $configitems | toYaml }}
{{- end -}}
