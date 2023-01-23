resource "volterra_app_type" "app-type" {
  count = length(var.xc_app_type) != 0 ? 1 : 0
  name = format("%s-app-type-%s", local.project_prefix, local.build_suffix)
  namespace = "shared"
  features {  
        type = "USER_BEHAVIOR_ANALYSIS" 
  }
  business_logic_markup_setting {
      enable = true
    }
}
