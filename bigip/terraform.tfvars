#Global
project_prefix = ""
resource_owner = ""


#AWS INFRA
aws_region     = "us-east-1"
azs           = ["us-east-1a", "us-east-1b"]

#BIG-IP
f5_ami_search_name = "F5 BIGIP-16.1.3* PAYG-Adv WAF Plus 25Mbps*"
aws_secretmanager_auth = false
public_az1_cidr_block = "blah"
private_az1_cidr_block = "blah"


#LTM
create_ltm_config = false
ltm_config_payload = "ltm-config.json"

#AWAF
create_awaf_config = true
awaf_config_payload = "awaf-config.json"
