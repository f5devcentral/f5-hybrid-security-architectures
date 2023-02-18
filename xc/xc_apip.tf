resource "volterra_api_definition" "api-def" {
  count = var.xc_api_pro ? 1 : 0
  name = format("%s-api-def-%s", local.project_prefix, local.build_suffix)
  namespace = var.xc_namespace 
  swagger_specs = var.xc_api_spec
}