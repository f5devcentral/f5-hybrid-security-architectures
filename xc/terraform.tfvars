#XC Global
api_url = "https://f5-emea-ent.console.ves.volterra.io/api"
xc_tenant = "f5-emea-ent"
xc_namespace = "j-agboola"

#XC LB
app_domain = "juicy-cd-demos.emea-ent.f5demos.com"

#XC WAF
xc_waf_blocking = true

#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
xc_app_type = []
xc_multi_lb = false

#XC API Protection and Discovery
xc_api_disc = false
xc_api_pro = false
xc_api_spec = []
#Enable API schema validation
xc_api_val = false
#Enable API schema validation on all endpoints
xc_api_val_all = false 
#Validation properties for request and response validation
xc_api_val_properties = [] #Example ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]
xc_resp_val_properties = [] #Example ["PROPERTY_HTTP_HEADERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_HTTP_BODY", "PROPERTY_RESPONSE_CODE"]
#Validation Mode active for requests and responses (false = skip)
xc_api_val_active = false
xc_resp_val_active = false
#Validation Enforment Type (only one of these should be set to true)
enforcement_block = false
enforcement_report = false
#Allow access to unprotected endpoints 
fall_through_mode_allow = false
#Enable API Validation custom rules
xc_api_val_custom = false 

#XC Bot Defense
xc_bot_def = false

#XC DDoS
xc_ddos_pro = false

#XC Malicious User Detection
xc_mud = false
