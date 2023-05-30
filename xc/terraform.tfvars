#XC GLobal
api_url = "https://tme-lab-works.console.ves.volterra.io/api"
xc_tenant = "tme-lab-works-oeaclgke"
xc_namespace = "cameron"

#XC LB
app_domain = "brewz-cd.sr.f5-cloud-demo.com"

#XC WAF
xc_waf_blocking = true

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = true
xc_api_pro = true
xc_api_spec = ["https://tme-lab-works/api/object_store/namespaces/cameron/stored_objects/swagger/brewz-oas/v1-23-03-27"]

#XC Bot Defense
xc_bot_def = false

#XC DDoS
xc_ddos_pro = false

#XC Malicious User Detection
xc_mud = true

