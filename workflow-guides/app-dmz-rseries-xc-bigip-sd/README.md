## F5 Distributed Cloud Service Discovery for BIG-IP Customer Edge (CE) Sites

## Table of Contents
- [Overview](#overview)
- [1. Prerequisites](#1-prerequisites)
- [2. BigIP Service Discovery](#2-bigip-service-discovery)
  - [2.1. Configure BIG-IP for Service Discovery](#21-configure-big-ip-for-service-discovery)
  - [2.2. Create Load Balancer for the Virtual Server](#22-create-load-balancer-for-the-virtual-server)
  - [2.3. Enable High Availability for the Load Balancer](#23-enable-high-availability-for-the-load-balancer)
- [3. DMZ Deployment](#3-dmz-deployment)
- [4. Conclusion](#4-conclusion)

## Overview

This guide will walk you through the steps to configure and use the BIG-IP Service Discovery for the BIG-IP TMOS deployed on the F5 rSeries device.

The BIG-IP Service Discovery is a feature that allows you to automatically discover app services in an existing BIG-IP configuration. The BIG-IP Service Discovery uses the F5 XC Cloud CE node to communicate with the BIG-IP deployment and discover the Virtual Servers. This allows you to easily configure the HTTP and HTTPS load balancing and expose your applications to the internet.

In the diagram below you can see the overview of the solution:

![Overview](./assets/solution_overview.png)

The setup includes the following:

- BigIP Service Discovery configuration to discover the Virtual Servers;
- Application exposure to the Internet using HTTP Load Balancer;
- High Availability configuration with two BIG-IP instances;
- Upgrading the solution with a second Data Center and configuring HTTP Load Balancer for a complete DMZ configuration.

## 1. Prerequisites

This guide assumes that you have already completed the [Extending App DMZ to Global Service Tier with F5 rSeries and Distributed Cloud Services](https://github.com/f5devcentral/f5-hybrid-security-architectures/tree/main/workflow-guides/app-dmz-rseries-xc)

To complete this guide, you will need the following:

- [F5 Distributed Cloud Account](https://cloud.f5.com/)
- F5 rSeries: 5600 / 5800 / 5900/ 10600 / 10800 / 10900 / 12600 / 12800 / 12900
- [Big IP installed on the rSeries device](https://github.com/f5devcentral/f5-hybrid-security-architectures/tree/main/workflow-guides/app-dmz-rseries-xc#13-deploy-and-configure-big-ip-on-f5-rseries)
- [XC Site install on the rSeries device](https://github.com/f5devcentral/f5-hybrid-security-architectures/tree/main/workflow-guides/app-dmz-rseries-xc#21-deploy-ce-tenant-on-f5-rseries)
- Virtual Machine with NGINX docker container as a sample application
- [DNS Zone or Domain name](https://docs.cloud.f5.com/docs-v2/dns-management/how-to/manage-dns-zones#create-primary-zone)

The diagram below shows the network configuration of the solution:

![Network](./assets/solution_network.png)

## 2. BigIP Service Discovery

The BIG-IP Service Discovery feature automatically detects app services and configures HTTP/HTTPS load balancing for internet exposure. Using the F5 XC Cloud CE node, it communicates with BIG-IP to discover Virtual Servers.

![Discovery](./assets/solution_discovery.png)

### 2.1. Configure BIG-IP for Service Discovery

Proceed to `Multi-Cloud App Connect` and click on `Service Discoveries` in the left menu. Then click on `Add Service Discovery` to start the configuration.

![Service Discovery](./assets/xc_sd_navigate.png)

Give the Service Discovery a name. Optionally, you can add a description.

![Service Discovery](./assets/xc_sd_create.png)

In the `Where` section, select the `Site` option for rhe `Virtual-Site or Site or Network` field. Then select your `rSeries CE Site` from the list. And select `Site Local Inside Network` for the `Network` field.

![Service Discovery](./assets/xc_sd_create_where.png)

In the `Discovery Method` section, select the `Classic BIG-IP Discovery Configuration` option. Then click on `Add Item`.

![Service Discovery](./assets/xc_sd_add.png)

Give a name for the BIG-IP configuration. Then click on `Add Item` to add the BIG-IP details.

![Service Discovery](./assets/xc_sd_create_bigip.png)

Enter the `BIG-IP Management IP` and `Username`. Then click on `Configure` to add the `Admin Password`.

![Service Discovery](./assets/xc_sd_bigip_details.png)

Enter the `Admin Password` in the `Secret to Blindfold` field. Then click on `Apply`.

![Service Discovery](./assets/xc_sd_bigip_secret.png)

In the `Virtual Server Filter` you can filter the Virtual Servers by `Name`, `Description` and `Port Range`. For this example, we will filter by:

- Name: use regex `^*app*` to filter the Virtual Servers that have the word `app` in the name;
- Port Range: use `8080-8090` to filter the Virtual Servers that are using that port.

Then click on `Apply`.

![Service Discovery](./assets/xc_sd_bigip_virtual_server.png)

Click on `Apply` to finish the configuration.

![Service Discovery](./assets/xc_sd_bigip_apply.png)

After the configuration is applied, you will see the Discovered Virtual Servers. It may take a few minutes to load the Virtual Servers. Click on the discovered Services to see the details.

![Service Discovery](./assets/xc_sd_ready.png)

We can login to the BIG-IP to see the Virtual Servers that were discovered. Navigate to the `Local Traffic` => `Virtual Servers` section to see the Virtual Servers.

![Service Discovery](./assets/xc_sd_ready_bigip.png)

### 2.2. Create Load Balancer for the Virtual Server

The HTTP Load Balancer is used to expose the application to the internet. The Load Balancer will be created for the Virtual Server that was discovered in the previous step.

![HTTP_LB](./assets/solution_httplb.png)

In our example we have discovered 3 Virtual Servers. Select `Add HTTP Load Balancer` from the Actions menu to create a Load Balancer for the Virtual Server.

![Service Discovery](./assets/xc_sd_add_lb.png)

In the modal window, fill the details for the Load Balancer:

- `Name`: give a name for the Load Balancer;
- `Domain`: enter the domain for the Load Balancer. In this example we are using delegated domain that allows us to automatically create the DNS records for the Load Balancer;
- `LoadBalancer Type`: select the `HTTPS with Automatic Certificate` option;
- `Root CE Certificate of origin server`: select the certificate that will be used for the Load Balancer to communicate with the origin server;

Then click on `Save and Exit`.

![Service Discovery](./assets/xc_sd_confirm_lb.png)

Navigate to the `Load Balancers` => `HTTP Load Balancers` section to see the Load Balancer that was created. It may take a few minutes to provision the Load Balancer. You will see the Load Balancer status as `Valid` when it is ready to use.

![Service Discovery](./assets/xc_sd_lb_ready.png)

Once the Load Balancer is ready, you can use the domain to access the application. Open the website in the browser to see the application.

![Service Discovery](./assets/xc_sd_app_loaded.png)

### 2.3. Enable High Availability for the Load Balancer

To enable High Availability for the Load Balancer, you can add a second BIG-IP instance to the Load Balancer. The Load Balancer will automatically switch to the second BIG-IP instance if the first one is down.

![HTTP_LB](./assets/solution_ha.png)

Repeat the steps [2.1. Configure BIG-IP for Service Discovery](#21-configure-big-ip-for-service-discovery) to configure second instance of the BIG-IP. Then open the `Origin Pool` assigned to the Load Balancer.

![Pool](./assets/xc_pool_navigate.png)

Click on the `Edit Configuration` button to edit the Pool.

![Pool](./assets/xc_pool_edit.png)

In the `Origin Servers` section, click on the `Add Item` button to add the second BIG-IP instance to the Pool.

![Pool](./assets/xc_pool_add.png)

Select `cBIP Service Name of Origin Server` as a Type. Then enter the `Service Name` of the second BIG-IP instance in the format `{service-discovery-name}-{bigip-name}-{app-name}`. Then click on `Apply`.

![Pool](./assets/xc_pool_create.png)

Health Check is recommended to be enabled for the Pool. Click on the dropdown and then `Add Item` button to add the Health Check.

![Pool](./assets/xc_pool_health_add.png)

Give it a name and leave the default values for the Health Check. Then click on `Continue`.

![Pool](./assets/xc_pool_health_details.png)

Click `Save and Exit` to save the Pool configuration.

![Pool](./assets/xc_pool_save.png)

To test the High Availability, you can stop the first BIG-IP instance. The Load Balancer will automatically switch to the second BIG-IP instance. Then open the website in the browser to see the application.

![Service Discovery](./assets/xc_sd_app_loaded.png)

## 3. DMZ Deployment

DMZ deployment is a common practice to improve the resiliency of the application. In this section we will add a second Data Center to the solution and configure the HTTP Load Balancer for a complete DMZ configuration.

Second Data Center will be configured in the same way as the first Data Center. Repeat the steps [2.1. Configure BIG-IP for Service Discovery](#21-configure-big-ip-for-service-discovery) to configure the second BIG-IP instance. Then create the second `Origin Pool` as described in the [2.3. Enable High Availability for the Load Balancer](#23-enable-high-availability-for-the-load-balancer) section.

![HTTP_LB](./assets/solution_dmz.png)

Let's add the second Data Center to the Load Balancer. Open the Load Balancer configuration.

![DMZ](./assets/dmz_navigate.png)

Click on the `Edit Configuration` button to edit the Load Balancer.

![DMZ](./assets/dmz_edit.png)

In the `Origin Pool` section, edit the existing Pool.

![DMZ](./assets/origin_edit.png)

Change `Priority` of the existing Pool to `1`. Then click on `Apply` to save the changes.

![DMZ](./assets/dmz_origin_1.png)

Click on the `Add Item` button to add the second Pool to the Load Balancer.

![DMZ](./assets/dmz_origin_2.png)

Select the second Pool from the list. Change the `Priority` of the second Pool to `0`. Then click on `Apply` to save the changes.

![DMZ](./assets/dmz_origin_3.png)

Review the configuration and make sure that the `Priority` is set correctly. Click on `Save and Exit` to save the Load Balancer configuration.

![DMZ](./assets/dmz_origin_4.png)

To test the DMZ configuration, you can stop the first BIG-IP instance. The Load Balancer will automatically switch to the second BIG-IP instance. Then open the website in the browser to see the application.

## 4. Conclusion

In this guide, we have configured the BIG-IP Service Discovery to discover the Virtual Servers and create the HTTP Load Balancer to expose the application to the internet. We have also enabled High Availability for the Load Balancer and added a second Data Center to the solution to configure the DMZ deployment.
