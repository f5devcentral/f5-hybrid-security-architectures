
provider "aws" {
    region     = var.aws_region
}
provider "volterra" {
    api_cert = var.api_cert
    api_key = var.api_key
    url   = var.api_url
}
provider "kubernetes" {
    host = var.k_endpoint
    config_path = var.k_config
    config_context = var.k_context
    cluster_ca_certificate = var.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.aws_region]
      command     = "aws"    
    }
}

# Create a random id
resource "random_id" "build_suffix" {
    byte_length = 2
}

module "onboarding" {
    source = "./modules"

    #Globals
    project_prefix = var.project_prefix
    resource_owner = var.resource_owner
    build_suffix = random_id.build_suffix.hex

    #Deploy AWS infra(vpc, sg, etc) - Required for all AWS assets (BIG-IP, EKS, Monitoring, JuiceShop)
    create_infra = var.create_infra
    aws_region = var.aws_region
    azs = var.azs
    #management_cidr_blocks = var.management_cidr_blocks
    #Deploy Big-IP in AWS
    create_bigip = var.create_bigip
    ssh_key = var.ssh_key
    mgmtSubAz1 = var.mgmtSubAz1
    intSubAz1 = var.intSubAz1
    extSubAz1 = var.extSubAz1
    f5_password = var.f5_password
    admin_src_addr = var.admin_src_addr
    private_az1_cidr_block = var.private_az1_cidr_block
    public_az1_cidr_block = var.public_az1_cidr_block

    #Deploy Big-IP LTM VIP config for LTM ONLY
    create_ltm_config = var.create_ltm_config
    ltm_config_payload = var.ltm_config_payload

    #Deploy AWAF Policy to Big-IP
    create_awaf_config = var.create_awaf_config
    awaf_config_payload = var.awaf_config_payload
    
    #Deploy NAP WAF

    #Deploy NAP API

    #Create XC LB
    create_xc_lb = var.create_xc_lb 
    api_url = var.api_url
    api_cert = var.api_cert
    api_key = var.api_key
    xc_namespace = var.xc_namespace
    app_domain = var.app_domain
    dns_origin_pool = var.dns_origin_pool
    origin_server_dns_name = var.origin_server_dns_name
    origin_server_ip_address = var.origin_server_ip_address
    
    #Create XC WAF
    create_xc_waf = var.create_xc_waf
    xc_waf_blocking = var.xc_waf_blocking

    #Deploy juice Shop
    create_juice_shop = var.create_juice_shop
    juice_shop_ip = var.juice_shop_ip
    route_table_id = var.route_table_id
    public_subnet_ids = var.public_subnet_ids
    private_subnet_ids = var.private_subnet_ids
    private_cidr_blocks = var.private_cidr_blocks
    public_cidr_blocks = var.public_cidr_blocks

    #Deploy Arcadia Finance
}