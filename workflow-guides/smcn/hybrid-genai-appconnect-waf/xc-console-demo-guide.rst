Manual step by step process to connect and secure distributed Generative AI applications with F5 XC AppConnect and XC WAF
============================================================================================================================

Prerequisites
**************
- F5 Distributed Cloud Console SaaS account
- Access to Amazon Web Service (AWS) Management console & Command Line
- Access to Google Cloud (GCP) Management console & Command Line
- Install Kubectl command line tool to connect and push the app manifest file to EKS and GKE clusters


Create AWS credentials in XC by following the steps mentioned in this `Devcentral article <https://community.f5.com/kb/technicalarticles/creating-a-credential-in-f5-distributed-cloud-to-use-with-aws/298111>`_ 

Create GCP credentials in XC by following the steps mentioned in this `Devcentral article <https://community.f5.com/kb/technicalarticles/creating-a-credential-in-f5-distributed-cloud-for-gcp/298290>`_ 

Deployment Steps
*****************
To deploy an AppStack mk8s cluster on an AWS CE Site, steps are categorized as mentioned below.

1. In AWS console, create the EKS cluster
2. Using Kubectl, deploy the LLM workload on the EKS cluster
3. Deploy the Distributed Cloud VPC site Customer Edge workload on the EKS cluster
4. In GCP console, create the GKE cluster
5. Using Kubectl, deploy the GenAI front-end application on the GKE cluster
6. Deploy the Distributed Cloud GCP site Customer Edge workload on the GKE cluster
7. Publish the LLM service from EKS as a local service in GKE
8. Advertise externally the GenAI application
9. Test the GenAI application for sensitive information disclosure
10. Enable DataGuard on the HTTP LoadBalancer
11. Retest the GenAI application for sensitive information disclosure



Below we shall take a look into detailed steps as mentioned above.

1. In AWS console, create the EKS cluster following the steps mentioned in this `article <https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html>`_ and complete the steps to configure your computer to communicate with your cluster.

2. Using Kubectl, deploy the LLM workload on the EKS cluster by applying the following configuration:
    
   .. code-block::
    
    apiVersion: v1
    kind: Namespace
    metadata:
      name: llm
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: llama
      labels:
        app: llama
      namespace: llm
    spec:
      type: ClusterIP
      ports:
      - port: 8000
      selector:
        app: llama
    
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: llama
      namespace: llm
    spec:
      selector:
        matchLabels:
          app: llama
      replicas: 1
      template:
        metadata:
          labels:
            app: llama
        spec:
          containers:
          - name: llama
            image: registry.gitlab.com/f5-public/llama-cpp-python:latest
            imagePullPolicy: Always
            ports:
            - containerPort: 8000

   **Note**: The 'llama' LLM service will be created in 'llm' namespace in the EKS cluster. 

3. Deploy the Distributed Cloud site Customer Edge workload on the EKS cluster by following the `Create Kubernetes site <https://docs.cloud.f5.com/docs/how-to/site-management/create-k8s-site>`_ user guide.

4. In GCP console, create the `regional <https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-regional-cluster>`_ or `zonal <https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster>`_ GKE cluster following the steps mentioned in the linked user guide `article  and complete the steps to configure your computer to communicate with your cluster.

5. Using Kubectl, deploy the GenAI front-end application on the GKE cluster by applying the following configuration:

   .. code-block::

    apiVersion: v1
    kind: Namespace
    metadata:
      name: genai-apps
    ---
    #llama.llm service exposed from EKS will be created in llm namespace
    apiVersion: v1
    kind: Namespace
    metadata:
      name: llm
    ---
    
    apiVersion: v1
    kind: Service
    metadata:
      name: langchain-search
      labels:
        app: langchain-search
      namespace: genai-apps
    spec:
      type: ClusterIP
      ports:
      - port: 8501
      selector:
        app: langchain-search
    
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: langchain-search
      namespace: genai-apps
    spec:
      selector:
        matchLabels:
          app: langchain-search
      replicas: 1
      template:
        metadata:
          labels:
            app: langchain-search
        spec:
          containers:
          - name: langchain-search
            image: registry.gitlab.com/f5-public/langchain-search:latest
            imagePullPolicy: Always
            ports:
            - containerPort: 8501
            env:
              - name: OPENAI_API_BASE
                value: "http://llama.llm/v1"

   **Note**: The Generative AI application 'langchain-search' created in namespace ''genai-apps' on the GKE cluster will try to connect to the remote service of 'llama.llm' created in EKS in      the same way as if it were a local service. For this to be succesfull, we will need to expose the remote 'llama.llm' service as local to the GKE cluster, by creating a HTTP load balancer       on the GKE CE, having the nodes pointing to the 'llama' service on the 'llm' namespace created in the EKS cluster.

6. Deploy the Distributed Cloud site Customer Edge workload on the GKE cluster by following the `Create Kubernetes site <https://docs.cloud.f5.com/docs/how-to/site-management/create-k8s-site>`_ user guide.

7. Publish the LLM service from EKS as a local service in GKE:

   1. Login to F5 XC Console
   2. Select the 'Web App & API Protection' service
   3. Go to Manage-> Load Balancers -> Origin Pools and click on 'Add Origin Pool'. Configure the origin servers and the origin pool.

      .. figure:: assets/nodes.png
      Fig: Origin servers configuration


      .. figure:: assets/pool.png
      Fig: Pool configuration


   4. Go to Manage-> Load Balancers -> HTTP Load Balancer and click on 'Add HTTP Load Balancer'. Configure the HTTP Load balancer, including the 'Other Settings' -> 'Vip Advertisement' and           'More Options'


      .. figure:: assets/http-lb.png
      Fig: HTTP Load Balancer configuration
      
      **Note**: The domain name 'llama.llm' is the k8s service name that will be created in the GKE cluster. 

      .. figure:: assets/vip-adv.png
      Fig: Vip Advertisement configuration


      .. figure:: assets/options.png
      Fig: More Options -> Miscellaneous Options -> Idle Timeout configuration

8. Advertise externally the GenAI application

   1. Deploy an NGINX Ingress controller to the GKE cluster by following the `user guide <https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-manifests/>`_ .
   2. Edit (and apply) the following NGINX Ingress configuration files:
      
      ingress-class.yaml:

      .. code-block::

        apiVersion: networking.k8s.io/v1
        kind: IngressClass
        metadata:
          name: nginx
          # annotations:
          #   ingressclass.kubernetes.io/is-default-class: "true"
        spec:
          controller: nginx.org/ingress-controller

      nginx-config.yaml:

      .. code-block::

        kind: ConfigMap
        apiVersion: v1
        metadata:
          name: nginx-config
          namespace: nginx-ingress
        data:

      ns-and-sa.yaml:

      .. code-block::

        apiVersion: v1
        kind: Namespace
        metadata:
          name: nginx-ingress
        ---
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: nginx-ingress
          namespace: nginx-ingress
        #automountServiceAccountToken: false

   3. Create the Ingress object for the GenAI application by applying the following configuration:

      .. code-block::

        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
          name: langchain-search
          namespace: genai-apps
          annotations:
            nginx.org/websocket-services: "langchain-search"
            nginx.org/proxy-read-timeout: "3600"
            nginx.org/proxy-send-timeout: "3600"
        spec:
          ingressClassName: nginx
          defaultBackend:
            service:
              name: langchain-search
              port:
                number: 8501
          rules:
          - host: "*.com"
            http:
              paths:
              - path: "/"
                pathType: Prefix
                backend:
                  service:
                    name: langchain-search
                    port:
                      number: 8501


9. Test the GenAI application for sensitive information disclosure

   1. Open the GenAI app landing page. The GenAI application takes as inputs a web page to downloads and a query to parse against this page. For the purpose of this test, we will use a Data Loss prevention testing page 'https://dlptest.com/sample-data/namessndob/' that has a number of dummy personal details (such as SSN and DoB) and will ask the GenAI application to look for the SSN belonging to 'Robert Aragon'
   2. In the 'Web page to load' field, input 'https://dlptest.com/sample-data/namessndob/'. For 'Search Query', use 'What is Robert Aragon's SSN?'. Click 'Search'

      .. figure:: assets/test.png
      Fig: DLP test

   3. The GenAi application should output the SSN:

      .. figure:: assets/no-dataguard-result.png
      Fig: DLP test result

10. Enable DataGuard on the HTTP LoadBalancer

    1. Login to F5 XC Console
    2. Select the 'Web App & API Protection' service
    3. Go to Manage-> Load Balancers -> HTTP Load Balancers and click 'Manage configuration' option for the HTTP Load Balancer we created previously. Click 'Edit configuration'. On 'Web Application Firewall' section, edit the 'Data Guard Rules':

       .. figure:: assets/dataguard-config.png
       Fig: data Guard Configuration

    4. Save and Exit

11. Retest the GenAI application for sensitive information disclosure using the same inputs as before. The GenAI app output is now masked as it matches the SSN format configured by default as sensitive information.  

    .. figure:: assets/dataguard-result.png
    Fig: DLP test result with Data Guard enabled    



Conclusion
###########
The F5 XC connects distributed Generative AI Applications and protects against loss of sensitive information.

