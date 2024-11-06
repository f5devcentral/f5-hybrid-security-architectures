# Extending App DMZ to Global Service Tier with F5 rSeries and Distributed Cloud Services

# Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [1. Initial preparations](#1-initial-preparations)
  - [1.1 Requirements](#11-requirements)
  - [1.2 Configure Application VMs](#12-configure-application-vms)
  - [1.3 Deploy and Configure BIG-IP on F5 rSeries](#13-deploy-and-configure-big-ip-on-f5-rseries)
    - [1.3.1 Deploy BIG-IP on F5 rSeries](#131-deploy-big-ip-on-f5-rseries)
    - [1.3.2 Configure BIG-IP on F5 rSeries](#132-configure-big-ip-on-f5-rseries)
    - [1.3.3 Create BIG-IP Virtual Server](#133-create-big-ip-virtual-server)
- [2. Configure Environment](#2-configure-environment)
  - [2.1 Deploy CE Tenant on F5 rSeries](#21-deploy-ce-tenant-on-f5-rseries)
    - [2.1.1 Create Secure Mesh Site in XC Cloud](#211-create-secure-mesh-site-in-xc-cloud)
    - [2.1.2 Deploy CE Tenant on F5 rSeries](#212-deploy-ce-tenant-on-f5-rseries)
    - [2.1.2 Configure Second rSeries device](#212-configure-second-rseries-device)
  - [2.2 Configure XC Virtual Site](#22-configure-xc-virtual-site)
- [3. Expose Application to the Internet](#3-expose-application-to-the-internet)
  - [3.1 Create the HTTP Load Balancer](#31-create-the-http-load-balancer)
- [4. Protect Application](#4-protect-application)
  - [4.1 Configure WAF](#41-configure-waf)
  - [4.2 Configure Bot Protection](#42-configure-bot-protection)
  - [4.3 Configure API Discovery](#43-configure-api-discovery)
  - [4.4 Configure DDoS Protection](#44-configure-ddos-protection)
  - [4.5 Configure Malicious User and IP Reputation](#45-configure-malicious-user-and-ip-reputation)
  - [4.6 Verify Application](#46-verify-application)
- [5. Setup DMZ Configuration](#5-setup-dmz-configuration)
- [6. Conclusion](#6-conclusion)

# Overview

This guide provides the steps for a comprehensive Demilitarized Zone (DMZ) setup using F5 Distributed Cloud Services (XC) environment and F5 rSeries appliance.

**Challenges**

DMZ is a physical or logical subnetwork that contains and exposes an organization's external-facing services to an untrusted network, typically the internet. It serves as a buffer zone between the secure internal network and external networks, providing an additional layer of security to ensure that potentially malicious traffic does not reach critical internal systems directly.

To make data center applications accessible on the internet, IT teams traditionally handle several networking operations, including:
* **NAT** (Network Address Translation): Converting public IP addresses to private server IPs.
* **DNS Resolution**: Ensuring domain names resolve to the correct IP addresses.
* **Load Balancing**: Distributes incoming application traffic across multiple servers to ensure reliability, optimal resource utilization, and high availability
* **Security Operations**: Deploying protections such as Web Application Firewalls (WAF) and Distributed Denial of Service (DDoS) mitigation.

![rseris](./assets/rseries-before-v2.png)

Handling these operations at the App Services tier and on a per-application basis adds complexity, making application delivery more challenging, such as:
- Management and "stitching" of multiple app DMZ environments at scale
- Standardized consistent policy across overall data center deployments
- Handling unwanted traffic (bad actors and bots) at the global services tier

These challenges compound into serious problems when considering modern microservices app architectures, in particular **handling unwanted/unfiltered traffic** to app services and API endpoints, and **having no uniform security or visibility** when managing multiple sites (multiple datacenters and/or clouds). 

**Solution** 

F5 Distributed Cloud services (XC) simplify these challenges by providing centralized security services, which include volumetric DDoS protection, API protection, and Bot mitigation as part of WAF configurations at the network edge. This is possible through the installation and operation of a Customer Edge (CE) in various on-premises environments, such as VMware, OpenShift, Nutanix, or F5’s own rSeries appliances.

(1) **Global Services Tier** 
- Keeps unwanted traffic off your infrastructure
- Broad spectrum volumetric DDoS mitigation (L3/L)
- Anti-abuse including bot/fraud detection and mitigation
- Ease of securely exposing applications to the public internet by simplifying or eliminating manual handling of routing and other networking tasks
- Simplifying workflows for pushing out App DMZ toward the network edge
- Standard company app security policy / policies used by all apps

(2) **App Services Tier**
- Retains important / integrated security controls and policy including automation and CI/CD pipelines at your app
- Workload-specific security policy definitions & enforcement
- Closest to the application & Line of Business / security teams managing specific app services

![rseris](./assets/diagram-overview-2.png)

# Setup 

The objective of this setup is to create a secure DMZ environment for the application using the F5 rSeries hardware platform that provides modern topology for flexible and scalable networking connectivity, enhanced performance, and protection. The diagram below shows high-level components and their interactions. The setup includes two Data Centers, each has an origin pool that connects to the XC site installed in F5 rSeries. The XC site is connected to the BIG-IP where a Virtual Server is configured. Our sample app (Arcadia) is inside the Virtual Server Pool of the BIG-IP. The application is protected by Web Application Firewall (WAF), DDoS Protection, Bot Protection, and API Discovery.

The setup flow includes the following:

- Configuration of BIG-IP on F5 rSeries;
- Configuration of Data Centers with Customer Edge (CE) Sites on F5 rSeries;
- Demo application deployment in the Data Center;
- XC Cloud Secure Mesh Site configuration and combining them into a single Virtual Site;
- Application exposure to the Internet using HTTP Load Balancer;
- Application protection with Web Application Firewall (WAF), DDoS Protection, Bot Protection, and API Discovery;
- Upgrading the solution with a second Data Center and configuring HTTP Load Balancer for a complete DMZ configuration.
  
# 1. Initial preparations

## 1.1 Requirements

The following components are required to complete the setup:

- Access to the [XC Cloud](https://cloud.f5.com) with the following services enabled:
  - ability to create Sites
  - Bot Protect
  - DDoS Protect
  - Api Protect
  - Api Discovery
- F5 rSeries: 5600 / 5800 / 5900/ 10600 / 10800 / 10900 / 12600 / 12800 / 12900
- Ubuntu VM with access to the F5 rSeries network
- Domain Name

The following diagram shows the components and network configuration of the setup:

![rseris](./assets/diagram-configure.png)

## 1.2 Configure Application VMs

The main application is a simple web application that simulates a banking application. The application is hosted on an Ubuntu VM. The following steps are required to configure the main application VM:

- SSH into the VM
- Install [docker and docker-compose](https://docs.docker.com/engine/install/ubuntu/)
- Clone the repository
- Open `./application/main/` folder
- Run `docker compose up -d`

Optionally update the environment variables in the `docker-compose.yml` file.

Verify that the application is running by accessing `http://{{your_vm_ip}}:8080` in the browser or using curl command.

![Secure Mesh Site](./assets/vmware_app.png)

## 1.3 Deploy and Configure BIG-IP on F5 rSeries

### 1.3.1 Deploy BIG-IP on F5 rSeries

Download the BigIP image from the [F5 Downloads](https://my.f5.com/manage/s/downloads) for F5OS and save it to your local machine.

In the F5 rSeries interface navigate to `Tenant Images` and click on the `Upload` button.

![rseries-bigip](./assets/f5os_bigip_tenant_image.png)

Select the BIG-IP image and click `Open`.

![rseries-bigip](./assets/f5os_bigip_tenant_image_upload.png)

Navigate to `Tenant Deployments` and click on the `Add` button.

![rseries-bigip](./assets/f5os_bigip_create.png)

Fill in the required fields:

- `Name`: big-ip-tmos
- `Type`: BIG-IP
- `Image`: select the image you uploaded
- `IP Address`: IP address of the BIG-IP management interface
- `Gateway`: Gateway IP address
- `VLANs`: check the `XC-SLI` and `BIG-IP` VLANs
- `vCPUs`: 4
- `Virtual Disk Size`: 82 GB
- `State`: Deployed

Click on the `Save & Close` button to apply the changes.

![rseries-bigip](./assets/f5os_bigip_create_part_1.png)

![rseries-bigip](./assets/f5os_bigip_create_part_2.png)

### 1.3.2 Configure BIG-IP on F5 rSeries

Log in your BIG-IP TMOS instance and navigate to `Network`. Select `VLANs` and click the `Create` button.

![rseries-bigip](./assets/bigip_config_vlan_navigate.png)

In the opened form fill in the VLAN name, tag and interface. Click `Finished` as soon as the fields are filled out.

![rseries-bigip](./assets/bigip_config_vlan_create.png)

Next, proceed to `Self IPs` and click `Create`.

![rseries-bigip](./assets/bigip_config_selfip_navigate.png)

This will open the configuration form. Fill in the following fields:

- `Name`: 10.5.11.20
- `IP Address`: 10.5.11.20 (or any other IP address you want to assign in XC SLI network)
- `Netmask`: 255.255.255.0
- `VLAN / Tunnel`: select the VLAN you create in the previous step

Click `Finished` as soon as the fields are filled out.

![rseries-bigip](./assets/bigip_config_selfip_create.png)

### 1.3.3 Create BIG-IP Virtual Server

In this section, we will configure the BIG-IP Virtual Server to expose the application to the XC SLI network. We will create a pool with the application VM as a member and then create a Virtual Server to route the traffic to the pool.

Open the BIG-IP interface and navigate to the `Local Traffic` tab. Click on the `Pools` and then click on the `Create` button.

![bigip](./assets/bigip_pool_create.png)

Fill in the required fields:

- `Name`: application-pool
- `Health Monitors`: select `http`
- `Node Name`: give a name to the node
- `Address`: IP address of the application VM
- `Service Port`: 8080

Click on the `Add` button to add the node to the pool and then click on the `Finished` button to create the pool.

![bigip](./assets/bigip_pool_details.png)

In the `Local Traffic` tab click on the `Virtual Servers`. Then click on the `Create` button.

![bigip](./assets/bigip_vs_navigate.png)

Fill in the required fields:

- `Name`: arcadia-application
- `Destination Address`: select the `SLI` network IP address
- `Service Port`: 8080
- Set `HTTP Profile (Client)` to `http`

![bigip](./assets/bigip_vs_name.png)

- Set `Source Address Translation` to `Auto Map`

![bigip](./assets/bigip_vs_map.png)

- Set `Default Pool` to `application-pool` and click on the `Finished` button to create the Virtual Server.

![bigip](./assets/bigip_vs_pool.png)

The application is now exposed to the XC SLI network. You can try to access the application using the IP address of the SLI network.

# 2. Configure Environment

## 2.1 Deploy CE Tenant on F5 rSeries

In this section, we will create a Secure Mesh Site in the XC Cloud. We will provide only the basic information required to create the site. The detailed information can be found here: [Deploy Secure Mesh Site v2 on F5 BIG-IP rSeries Appliance (ClickOps)](https://docs.cloud.f5.com/docs-v2/multi-cloud-network-connect/how-to/site-management/deploy-sms-rseries#procedure).

### 2.1.1 Create Secure Mesh Site in XC Cloud

Open XC Cloud and navigate to the `Multi-Cloud Network Connect`. In the left navigation pane, click on `Site Management` and then click on `Secure Mesh Sites v2`. In the `Secure Mesh Sites v2` page, click on the `Add Secure Mesh Site` button.

![rseries-sms](./assets/rseries-xc-navigate.png)

Fill the name of the site and assign custom label `dc == dc1-dmz`.

![rseries-sms](./assets/rseries-xc-name.png)

Select the provider as `F5 rSeries`. Leave other fields as default.

![rseries-sms](./assets/rseries-xc-provider.png)

Click on the `Save and Exit` button to apply the changes.

![rseries-sms](./assets/rseries-xc-save.png)

Open the action menu of the created site and click on `Download Image`. Save the image to your local machine, you will need it later.

![rseries-sms](./assets/rseries-xc-image.png)

Open the action menu again and click on `Generate Node Token`.

![rseries-sms](./assets/rseries-xc-token.png)

From the `Generate Node Token` dialog, copy the token.

![rseries-sms](./assets/rseries-xc-token-copy.png)

### 2.1.2 Deploy CE Tenant on F5 rSeries

Sign in to the F5 rSeries interface and navigate to the `TENANT MANAGEMENT` tab. Click on the `Tenant Images`. Then click on the `Upload` button.

![rseries-sms](./assets/rseries-tenant.png)

Select the image you downloaded in the previous step and click `Open`.

![rseries-sms](./assets/rseries-upload.png)

Navigate to `Tenant Deployments` and click on the `Add` button.

![rseries-sms](./assets/rseries-create.png)

Fill in the required fields:

- `Name`: rseries-dmz-site
- `Type`: Generic
- `Image`: select the image you uploaded
- `IP Address`: IP address of the SLO interface
- `Gateway`: Gateway IP address
- `VLANs`: check the `XC-SLO` and `XC-SLI` VLANs
- `vCPUs`: 4
- `Virtual Disk Size`: 50 GB
- `Metadata`: paste the token you copied in the previous step and VLAN ID in the following format: `[primary-vlan:SLO token:your_token_from_xc_cloud]`

Click on the `Save & Close` button to apply the changes.

![rseries-sms](./assets/rseries-details_part_1.png)

![rseries-sms](./assets/rseries-details_part_2.png)

Go back to the XC Cloud and navigate to the `Sites`. Wait until the site is deployed and provisioned.

![rseries-sms](./assets/rseries-confirm.png)

If your network does not use DHCP, you may need to configure the network settings manually. Once the site status changes to "Ready," go to the site details and complete the network configuration.

### 2.1.2 Configure Second rSeries device

Repeat the steps from the [1.3 Deploy and Configure BIG-IP on F5 rSeries](#13-deploy-and-configure-big-ip-on-f5-rseries) section and from the [2.1 Deploy CE Tenant on F5 rSeries](#21-deploy-ce-tenant-on-f5-rseries) section to configure the second rSeries device.

## 2.2 Configure XC Virtual Site

To simplify the management of the application, we will create a Virtual Site in the XC Cloud that will assign the Secure Mesh Site to the Virtual Site. This will allow us to access the application using the Virtual Site name and allow us to scale the application by adding more Secure Mesh Sites in the future.

![rseris](./assets/diagram-vsite.png)

Let's start with adding a virtual site. Back in the F5 Distributed Cloud Console, navigate to the **Shared Configuration** service. From there, select **Virtual Sites** and click the **Add Virtual Site** button.

![Virtual Site](./assets/virtual_site_add.png)

In the opened form give virtual site a name that we specified as [label](#151-create-secure-mesh-site-in-xc-cloud) for Secure Mesh Sites. Then make sure to select the **CE** site type. After that add selector expression specifying its name as value and complete by clicking the **Save and Exit** button.

![Virtual Site](./assets/virtual_site_config.png)

# 3. Expose Application to the Internet

![rseris](./assets/diagram-before.png)


## 3.1 Create the HTTP Load Balancer

Next, we will configure the HTTP Load Balancer to expose the created Virtual Site to the Internet.

![rseris](./assets/diagram-httplb.png)

Proceed to the **Multi-Cloud App Connect** service => **Load Balancers** => **HTTP Load Balancers**. Click the **Add HTTP Load Balancer** button.

![HTTP LB](./assets/http_lb_create.png)

First, give the HTTP Load Balancer a name.

![HTTP LB](./assets/http_lb_name.png)

Then we will configure **Domains and LB Type** section. Type in the **arcadia-dmz.f5-cloud-demo.com** domain and select **HTTPS with Automatic Certificate** as Load Balancer Type. Make sure to enable HTTP redirect to HTTPS and add HSTS header.

![HTTP LB](./assets/http_lb_domain.png)

Scroll down to the **Origins** section and add an origin pool by clicking the **Add Item** button.

![HTTP LB](./assets/http_lb_origin.png)

Open the **Origin Pool** drop-down menu and click **Add Item** to add an origin pool.

![HTTP LB](./assets/http_lb_add_pool.png)

Give the origin pool a name.

![HTTP LB](./assets/http_lb_pool_name.png)

Then click **Add Item** to add an origin server.

![HTTP LB](./assets/http_lb_pool_origin.png)

Select **IP address of Origin Server on given Sites** as Origin Server type and type in the **10.5.11.20** private IP (your BigIP XC interface). Then in the drop-down menu select the [Virtual Site](#21-configure-xc-virtual-site) we created earlier. Complete the configuration by clicking the **Apply** button.

![HTTP LB](./assets/http_lb_pool_details.png)

Configure the second origin server for the second BigIP instance in the same way. The IP address is **10.5.11.21**

Type in the **8080** origin server port.

![HTTP LB](./assets/http_lb_pool_port.png)

Scroll down to the **Health Checks** section and click the **Add Item** button to add a health check.

![HTTP LB](./assets/http_lb_health_add.png)

Give health check a name and leave the default settings. Then click **Continue** to save the health check configuration.

![HTTP LB](./assets/http_lb_health_details.png)

Scroll down and click **Continue**.

![HTTP LB](./assets/http_lb_pool_save.png)

**Apply** origin pool configuration.

![HTTP LB](./assets/http_lb_pool_apply.png)

Now that the HTTP Load Balancer is configured, click **Save and Exit** to save it.

![HTTP LB](./assets/http_lb_save.png)

# 4. Protect Application

Now that we have exposed the Virtual Site to the Internet using an HTTP Load Balancer, we will configure protection for the deployed application: WAF, Bot Protect, API Discovery, DDoS Protection, and Malicious User and IP Reputation.

![rseris](./assets/diagram-waf.png)

To do that go back to the F5 Distributed Cloud Console and select **Manage Configuration** in the service menu of the created HTTP Load Balancer.

![Configure](./assets/configure_manage.png)

Click the **Edit Configuration** button to enable the editing mode.

![Configure](./assets/configure_edit.png)

## 4.1 Configure WAF

First, let's configure WAF protection. Scroll down to the **Web Application Firewall** section and enable WAF. Open the dropdown menu and click **Add Item**.

![Configure](./assets/configure_waf.png)

Give WAF a name and move on to **Enforcement Mode** configuration.

![Configure](./assets/configure_waf_name.png)

Select **Blocking** mode in the drop-down menu to log and block threats.

![Configure](./assets/configure_waf_mode.png)

Proceed to **Detection Settings**. Select **Custom** Security Policy and take a look at its settings. Then scroll down to the **Signature-Based Bot Protection** and select **Custom**.

![Configure](./assets/configure_waf_detection.png)

Finally, let's configure **Blocking Response Page** in **Advanced configuration**. Select **Custom** and configure as needed. Click **Continue** to complete WAF configuration and go back to the HTTP configuration page.

![Configure](./assets/configure_waf_advanced.png)

## 4.2 Configure Bot Protection

Next, we will configure Bot Protection. Scroll to the **Bot Protection** section and select **Enable Bot Defense Standard** in the drop-down menu. Move on by clicking **Configure**.

![Configure](./assets/configure_bot.png)

Proceed to configure Protected App Endpoint.

![Configure](./assets/configure_bot_app_endpoints.png)

Click the **Add Item** button which will open the creation form.

![Configure](./assets/configure_bot_add_endpoint.png)

Let's configure the endpoint. First, give it a name. Then select HTTP methods and choose to specify the endpoint label category. Specify **Authentication** as flow label category and select **Login** for flow label. Move on and specify path prefix - **/trading/auth**. Select **Block** for the Bot Mitigation action and save the configuration by clicking **Apply**.

![Configure](./assets/configure_bot_endpoint_config.png)

Take a look at the created App Endpoint and apply its configuration.

![Configure](./assets/configure_bot_endpoint_apply.png)

You will see Bot Defense Policy settings. Click the **Apply** button to proceed.

![Configure](./assets/configure_bot_apply.png)

Now that the Bot Protection is configured for the HTTP Load Balancer, we can move on to API Discovery.

## 4.3 Configure API Discovery

In the **API Protection** part enable API Discovery and enable learning fom redirect traffic. Once the configuration is ready, proceed to the DDoS settings.

![Configure](./assets/configure_api.png)

## 4.4 Configure DDoS Protection

Go to the **DoS Protection** section and select serving JavaScript challenge to suspicious sources. Proceed and select **Custom** for Slow DDoS Mitigation.

![Configure](./assets/configure_ddos.png)

## 4.5 Configure Malicious User and IP Reputation

In the **Common Security Controls** section enable IP Reputation service and Malicious User Detection. Then select **JavaScript Challenge** for this HTTP LB.

![Configure](./assets/configure_other.png)

The whole safety configuration is done. Take a look at it and click **Save and Exit**.

![Configure](./assets/configure_save.png)

## 4.6 Verify Application

Now that all the protection is configured, we can verify the application. To do that access the application using the domain name specified in the [Create HTTP Load Balancer](#21-create-http-load-balancer) section.

To verify the WAF protection, try to access the application using a browser or curl command and check if the request is blocked by WAF. Let's simulate a simple XSS attack by adding a script tag to the request. Open the browser console and navigate to the application URL `https://arcadia-dmz.f5-cloud-demo.com?param=<script>alert('XSS')</script>`. You should see the WAF blocking page.

![Configure](./assets/test_xss.png)

To verify the Bot Protection, try to access the application using a browser or curl command and check if the request is blocked by Bot Protection. Let's simulate a bot attack by sending a request to the protected endpoint. Open the Terminal and run the following command `curl -i -X POST https://arcadia-dmz.f5-cloud-demo.com/trading/auth`. You should see the Bot Protection blocking page in the response.

```bash
curl -i -X POST https://arcadia-dmz.f5-cloud-demo.com/trading/auth

HTTP/2 403
server: volt-adc
strict-transport-security: max-age=31536000
cache-control: no-cache
content-type: text/html; charset=UTF-8
pragma: no-cache
x-volterra-location: pa4-par
content-length: 71
date: Wed, 31 Jul 2024 23:00:45 GMT

The requested URL was rejected. Please consult with your administrator.
```

To verify the API Discovery, open the `docker-compose.yml` file and replace the `BASE_URL` variable with the application URL. Then run `docker-compose up -d` from the `docker/api_discovery` directory.
This will send a request to the application and trigger the API Discovery. It will take some time for the API Discovery to learn the traffic. After that, you can check the API Discovery dashboard in the F5 Distributed Cloud Console.

```bash
version: '3'
services:
  openbanking-traffic:
    image: ghcr.io/yoctoalex/arcadia-finance/openbanking-traffic:v0.0.2
    environment:
      BASE_URL: https://{{your-domain-here}}/openbanking
```

Navigate to the **Applications** tab and select your HTTP Load Balancer. Then click on the **API Endpoints** tab to see the learned API endpoints. Change view to **Graph** to see the API endpoints graph.

![Configure](./assets/http_discovery.png)

# 5. Setup DMZ Configuration

Finally, we will configure the HTTP Load Balancer by creating the second origin pool for the second Data Center and configuring it.

![rseris](./assets/diagram-dmz.png)

This setup requires a second Data Center with the same configuration as the first one. Repeat the steps from [1. Initial preparations](#1-initial-preparations) and [2. Configure Environment](#2-configure-environment) sections to create a second Data Center with the same components. Then create a Virtual Site for the second Data Center as described in the [2.1 Configure XC Virtual Site](#21-configure-xc-virtual-site) section.

Once the second Data Center is ready, we can proceed with the configuration. Go to the F5 Distributed Cloud Console and select **Manage Configuration** in the service menu of the earlier [created HTTP Load Balancer](#21-create-http-load-balancer).

![Second DC](./assets/dc2_manage.png)

Click the **Edit Configuration** button to enable the editing mode.

![Second DC](./assets/dc2_edit.png)

Scroll to the **Origins** section and click the **Add Item** button. This will open origin pool creation form.

![Second DC](./assets/dc2_add_pool.png)

Open the **Origin Pool** drop-down menu and click **Add Item** to add an origin pool.

![Second DC](./assets/dc2_create_pool.png)

Give the origin pool a name.

![Second DC](./assets/dc2_pool_name.png)

Then click **Add Item** to add an origin server.

![Second DC](./assets/dc2_add_origin.png)

Select **IP address of Origin Server on given Sites** as Origin Server type and type in the **10.6.11.20** private IP (Your BigIP XC interface in the second DC). Then in the drop-down menu select the second created Virtual Site. Complete the configuration by clicking the **Apply** button.

![Second DC](./assets/dc2_configure_origin.png)

Create a second origin server for the second BigIP instance. In our case, the IP address is ** **10.6.11.21**

Type in the **8080** origin server port.

![Second DC](./assets/dc2_port.png)

Scroll down and click **Continue**.

![Second DC](./assets/dc2_save_pool.png)

Change the **Priority** of the origin pool to **0**. This will make the second origin pool backup for the first one. **Apply** origin pool configuration.

![Second DC](./assets/dc2_apply_pool.png)

The second configured origin pool will appear on the list.

![Second DC](./assets/dc2_pool_result.png)

Now that we have added and configured the second origin pool of the HTTP Load Balancer for the second Data Center, click **Save and Exit** to save it.

# 6. Conclusion

In this guide, we have configured a comprehensive DMZ setup using F5 rSeries hardware, BIG-IP and F5 XC Cloud environment. We have deployed a simple web application, configured the BIG-IP and XC CE Tenant on F5 rSeries, exposed the application to the Internet using HTTP Load Balancer, and protected the application with WAF, Bot Protection, API Discovery, DDoS Protection, Malicious User, and IP Reputation. We have also configured the second Data Center and added it to the HTTP Load Balancer as a backup origin pool.

This setup provides a secure and scalable environment for exposing on-prem applications to the public internet access with advanced protection and networking management performed at the network edge with the help of F5 Distributed Cloud Services. The F5 rSeries hardware and F5 XC Cloud environment provide a powerful platform for deploying and managing networking and security of applications in a scalable and efficient way.
