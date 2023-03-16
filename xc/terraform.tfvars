#XC Global
api_url = "https://tme-lab-works.console.ves.volterra.io/api"
xc_tenant = "tme-lab-works"
xc_namespace = "fdx-demo"

#XC LB
app_domain = "ri.fdx.f5-cloud-demo.com"

#XC WAF
xc_waf_blocking = true

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = false
xc_api_pro = true
xc_api_spec = ["https://raw.githubusercontent.com/vtobi/fdx-controls-reference-implementation/main/fdx/fdxapi.yaml"]

#XC Bot Defense
xc_bot_def = false

#XC DDoS
xc_ddos = false

#XC Malicious User Detection
xc_mud = true
