# F5 Distributed Cloud Hybrid Security Architecture Deployments

## Overview

Examples of hybrid security deployments utilizing F5 Distributed Cloud WAAP in conjunction with the F5 product portfolio.  For more information on the project, please see the following article series [F5 Hybrid Security Architectures: One WAF Engine, Total Flexibility](https://community.f5.com/t5/technical-articles/f5-hybrid-security-architectures-one-waf-engine-total/ta-p/307248)

## Getting Started

## Prerequisites

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
  * [User Domain delegated](https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation)
* [NGINX Plus with App Protect and Ingress license](https://www.nginx.com/free-trial-request/)
* [AWS Account](https://aws.amazon.com) - Due to the assets being created, free tier will not work.
  * The F5 BIG-IP AMI being used from the [AWS Marketplace](https://aws.amazon.com/marketplace) must be subscribed to your account
  * Please make sure resources like VPC and Elastic IP's are below the threshold limit in that aws region
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)

## Assets

* **xc:**        F5 Distributed Cloud WAAP
* **nap:**       NGINX Ingress Controller for Kubernetes with NGINX App Protect (WAF and API Protection)
* **bigip-base:**     F5 BIG-IP Base
* **bigip-awaf:**     F5 BIG-IP Advanced WAF
* **bigip-cis:**      F5 Big-IP Container Ingress Services
* **infra:**     AWS Infrastructure (VPC, IGW, etc.)
* **eks:**       AWS Elastic Kubernetes Service
* **brewz:**     Brews Microservice
* **arcadia:**   Arcadia Finance test web application and API
* **juiceshop:** OWASP Juice Shop test web application

## Tools

* **Cloud Provider:** AWS
* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** Create a CLI or API workspace for each asset in the workflow chosen. Check your work-flow article for more details


  | **Workflow** | **Assets/Workspaces**                             |
  | ------------ | ------------------------------------------------- |
  | xc-bigip     | infra, bigip-base, bigip-awaf, juiceshop, xc      |
  | xc-nap       | infra, eks, nap, arcadia, xc                      |
  | xc-nap-api   | infra, eks, nic, brewz, xc                        |
  | xc-bigip+bot | infra, bigip-base, bigip-awaf, juiceshop, xc      |
  | xcbn-cis     | infra, bigip-base, bigip-cis, eks, nic, brewz, xc |
  

* **Workspace Sharing:** Under the settings for each Workspace, set the **Remote state sharing** to share with each Workspace created.
  
* **Variable Set:** Create a Variable Set with the following values:

  | **Name**              | **Type**    | **Description**                                                                              |
  | --------------------- | ----------- | -------------------------------------------------------------------------------------------- |
  | AWS_ACCESS_KEY_ID     | Environment | Your AWS Access Key ID                                                                       |
  | AWS_SECRET_ACCESS_KEY | Environment | Your AWS Secret Access Key                                                                   |
  | AWS_SESSION_TOKEN     | Environment | Your AWS Session Token                                                                       |
  | NGINX_JWT             | Environment | Your NGINX JSON Web Token associated with your NGINX license. Set this to **nginx-repo.jwt** |
  | VOLT_API_P12_FILE     | Environment | Your F5XC API certificate. Set this to **api.p12**                                           |
  | VES_P12_PASSWORD      | Environment | Set this to the password you supplied when creating your F5 XC API certificate               |
  | ssh_key               | Terraform   | Your ssh key for accessing the created BIG-IP and compute assets                             |
  | admin_src_addr        | Terraform   | The source address and subnet in CIDR format of your administrative workstation              |
  | tf_cloud_organization | Terraform   | Your Terraform Cloud Organization name                                                       |

## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo
  *  NGINX_JWT: The linux base64 encoded NGINX Java Web Token associated with your NGINX Ingress license
  *  P12: The linux base64 encoded F5XC API certificate
  *  TF_API_TOKEN: Your Terraform Cloud API token
  *  TF_CLOUD_ORGANIZATION: Your Terraform Cloud Organization name
  *  TF_CLOUD_WORKSPACE_*\<Workspace Name\>*: Create for each workspace in your workflow
      * EX: TF_CLOUD_WORKSPACE_BIGIP_BASE would be created with the value `bigip-base`

## Workflow Runs

**STEP 1:** Check out a branch for the workflow you wish to run using the following naming convention. 

  **DEPLOY**
  
  | Workflow     | Branch Name      |
  | ------------ | ---------------- |
  | xc-bigip     | deploy-xc-bigip  |
  | xc-nap       | deploy-xc-nap    |
  | xcapi-nic    | deploy-xcapi-nic |
  | xc-bigip+bot | deploy-xc-bigip  |
  | xcbn-cis     | deploy-xcbn-cis  |
 
  **DESTROY**
  
  | Workflow     | Branch Name       |
  | ------------ | ----------------- |
  | xc-bigip     | destroy-xc-bigip  |
  | xc-nap       | destroy-xc-nap    |
  | xcapi-nic    | destroy-xcapi-nic |
  | xc-bigip+bot | destroy-xc-bigip  |
  | xcbn-cis     | destroy-xcbn-cis  |


**STEP 2:** Rename `infra/terraform.tfvars.examples` to `infra/terraform.tfvars` and add the following data:
  * project_prefix  = "Your project identifier name in **lower case** letters only - this will be applied as a prefix to all assets"
  * resource_owner = "Your-name"
  * aws_region     = "AWS Region" ex. us-east-1
  * azs            = ["us-east-1a", "us-east1b"] - Change to Correct Availability Zones based on selected Region
  * Also update assets boolean value as per your work-flow


**STEP 3:** Depending on your work-flow, rename and update related .tfvars. For example in xc-bigip work-flow, update `bigip/terraform.tfvars.examples` to `bigip/terraform.tfvars` and add the following data:
  * f5_ami_search_name = "F5 BIGIP-16.1.3* PAYG-Adv WAF Plus 25Mbps*" - You must be subscribed to the AMI in the [AWS Marketplace](https://aws.amazon.com/marketplace)
  * aws_secretmanager_auth = false
  * create_awaf_config = true
  * awaf_config_payload = "awaf-config.json"


**Step 3:** Rename `xc/terraform.tfvars.examples` to `xc/terraform.tfvars` and add the following data:
  * api_url         = "Your F5XC tenant"
  * xc_tenant       = "Your tenant id available in F5 XC `Administration` section `Tenant Overview` menu"
  * xc_namespace    = "The existing XC namespace where you want to deploy resources"
  * app_domain      = "the FQDN of your app (cert will be autogenerated)"
  * xc_waf_blocking = "Set to true to enable blocking"
  * Also update assets boolean value as per your work-flow based on the values in the tfvars example.

**STEP 5:** Commit and push your build branch to your forked repo
  * Build will run and can be monitored in the GitHub Actions tab and TF Cloud console


**STEP 6:** Once the pipeline completes, verify your assets were deployed or destroyed based on your workflow.  
            **NOTE:**  The autocert process takes time.  It may be 5 to 10 minutes before Let's Encrypt has provided the cert.


## Development

Outline any requirements to setup a development environment if someone would like to contribute.  You may also link to another file for this information.

## Support

For support, please open a GitHub issue.  Note, the code in this repository is community supported and is not supported by F5 Networks.  

## Community Code of Conduct

Please refer to the [F5 DevCentral Community Code of Conduct](code_of_conduct.md).

## License

[Apache License 2.0](LICENSE)

## Copyright

Copyright 2014-2020 F5 Networks Inc.

### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects.
Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein.
You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA.
