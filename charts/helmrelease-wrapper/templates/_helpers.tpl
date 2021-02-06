{{/*
  Replace vars in $.Values.template with values from $vars.
*/}}
{{- define "replace-vars" -}}
{{- range keys $.vars -}}
{{- if has (kindOf (get $.vars .)) (list "map" "slice") -}}
{{- $_ := set $ "template" ((regexReplaceAll (printf "{ var:%s }" .) ($.template | toYaml) (get $.vars . | toJson)) | fromYaml) -}}
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
