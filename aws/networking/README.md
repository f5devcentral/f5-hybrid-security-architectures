# F5 Distributed Cloud AWS Networking

## Prerequisites

### For CI/CD

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)
* [AWS Programmatic Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html)

## Tools

* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** The following workspaces will be created in Terraform Cloud unless otherwise specified in the Actions Environments.


  | **Workflow**                | **Assets/Workspaces**  |
  | ----------------------------| ---------------------- |
  | aws-networking              | aws-networking         |
  
## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo


  | **Name**                           | **Required** | **Description**                                                             |
  | ---------------------------------- | ------------ | --------------------------------------------------------------------------- |
  | TF_API_TOKEN                       | true         | Your Terraform Cloud API token                                              |
  | TF_CLOUD_ORGANIZATION              | true         | Your Terraform Cloud Organization name                                      |
  | AWS_ACCESS_KEY                     | true         | AWS access key for the account                                              |
  | AWS_SECRET_KEY                     | true         | AWS secret key for the account                                              |
  | AWS_SESSION_TOKEN                  | true         | AWS session token for the account                                           |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo

Complex values are represented as an encoded json strings. For example:

```json
  "TF_VAR_az_names": "[\"us-east-1a\"]"
```

The full input parameters list can be found in the [aws-vpc-site-networking module inputs](https://registry.terraform.io/modules/f5devcentral/aws-vpc-site-networking/xc/latest?tab=inputs).

  | **Name**                                        | **Default**            | **Description**                                  |
  | ----------------------------------------------- | ---------------------- | ------------------------------------------------ |
  | TF_VAR_name                                     | aws-networking         | Name for the resources                           |
  | TF_VAR_prefix                                   |                        | Prefix for the resources                         |
  | TF_CLOUD_WORKSPACE_AWS_NETWORKING               | aws-networking         | Name of the Terraform Cloud workspace            |
  | TF_VAR_aws_region                               | us-east-1              | AWS region for the resources                     |
  | TF_VAR_existing_vpc_id                          |                        | ID of an existing VPC                            |
  | TF_VAR_create_outside_route_table               | true                   | Whether to create an outside route table         |
  | TF_VAR_create_internet_gateway                  | true                   | Whether to create an internet gateway            |
  | TF_VAR_create_outside_security_group            | ture                   | Whether to create an outside security group      |
  | TF_VAR_create_inside_security_group             | ture                   | Whether to create an inside security group       |
  | TF_VAR_create_udp_security_group_rules          | true                   | Whether to create UDP security group rules       |
  | TF_VAR_tags                                     |                        | Tags for the resources                           |
  | TF_VAR_az_names                                 | ["us-east-1a", "us-east-1b", "us-east-1c"]           | Availability zone names                          |
  | TF_VAR_local_subnets                            | ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]  | Local subnets                                    |
  | TF_VAR_inside_subnets                           | ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]  | Inside subnets                                   |
  | TF_VAR_outside_subnets                          | ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]  | Outside subnets                                  |
  | TF_VAR_workload_subnets                         | ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]  | Workload subnets                                 |
  | TF_VAR_vpc_cidr                                 | 10.10.0.0/16           | CIDR block of the VPC                             |
  | TF_VAR_vpc_instance_tenancy                     | default                | Tenancy option for the VPC                        |
  | TF_VAR_vpc_enable_dns_hostnames                 | true                   | Whether to enable DNS hostnames for the VPC       |
  | TF_VAR_vpc_enable_dns_support                   | true                   | Whether to enable DNS support for the VPC         |
  | TF_VAR_vpc_enable_network_address_usage_metrics | false                  | Whether to enable network address usage metrics   |


## Worflow Outputs

  | **Name**                      | **Description**                               |
  | ----------------------------- | --------------------------------------------- |
  | vpc_id                        | ID of the VPC                                 |
  | vpc_name                      | Name of the VPC                               |
  | vpc_cidr                      | CIDR block of the VPC                         |
  | outside_subnet_ids            | IDs of the outside subnets                    |
  | inside_subnet_ids             | IDs of the inside subnets                     |
  | workload_subnet_ids           | IDs of the workload subnets                   |
  | local_subnet_ids              | IDs of the local subnets                      |
  | outside_route_table_id        | ID of the outside route table                 |
  | internet_gateway_id           | ID of the internet gateway                    |
  | outside_security_group_id     | ID of the outside security group              |
  | inside_security_group_id      | ID of the inside security group               |
  | default_security_group_id     | ID of the default security group              |
  | az_names                      | Availability zone names                       |


## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "AWS Networking Apply" workflow. Fill required parameters, click "Run Workflow" and select the branch you want to run the workflow on.

  **DEPLOY**
  
  | Workflow                         | Name                           |
  | -------------------------------- | ------------------------------ |
  | aws-networking-apply.yaml        | AWS Networking Apply           |
 
  **DESTROY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | aws-networking-destroy.yaml        | AWS Networking Destroy           |