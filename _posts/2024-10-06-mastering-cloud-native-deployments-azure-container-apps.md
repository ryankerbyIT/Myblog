---
title: "Hands-On with Azure Container Apps: A Guided Project for Cloud-Native Deployments"
description: "Follow my step-by-step journey through a guided project on deploying and managing containerized applications using Azure Container Apps. Learn about secure connections, CI/CD with Azure Pipelines, scaling strategies, and revision management—all backed by real-world, hands-on experience."
author: Ryan Kerby
date: 2024-10-06 12:00:00 +0800
categories: [Projects, Credentials]
tags: [Azure Container Apps, Cloud-Native, DevOps, Containerization, Azure DevOps, Continuous Integration, Azure Pipelines, Docker, Kubernetes, Azure Container Registry, Scaling, Revisions, Cloud Computing, CI/CD, Cloud Security, Microsoft Azure, Infrastructure as Code, App Deployment, Cloud Solutions, Managed Identity]
pin: true
math: false
mermaid: false
image:
  path: /assets/images/azure-container-apps-guided-project.jpg
  alt: "An abstract visual representation of programming The Game of Domineering in Java."
---

# Study Guide for the Applied Skills Assessment Lab: Deploy Cloud-Native Apps Using Azure Container Apps

## Introduction

The world of cloud-native applications is rapidly evolving, and deploying containerized applications efficiently and securely is crucial for modern software development. Azure Container Apps (ACA) offers a seamless platform to deploy, manage, and scale containerized applications with minimal infrastructure overhead. In this guide, we'll explore the essential skills and configurations needed to deploy cloud-native apps using Azure Container Apps, focusing on secure connections, container registry management, scaling, and integration with other Azure services.

By the end of this guide, you'll have a deep understanding of how to:
- Set up a secure connection between an Azure Container Registry and Azure Container Apps.
- Create and configure container apps, including storage and ingress.
- Automate deployments with Azure Pipelines for continuous integration.
- Scale and manage deployed applications effectively.
- Implement revision management, including traffic splitting for staging and production environments.

This study guide breaks down each task in the assessment lab, providing detailed instructions, useful tips, and supplemental resources to help you succeed. **Let's dive into the first key task: configuring a secure connection between an Azure Container Registry and Azure Container Apps.**

> **Tip:** For beginners, it's important to understand the core concepts of containerization, Docker, and Kubernetes. If you're not familiar with these, consider exploring Microsoft's [Introduction to Containers](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview) before proceeding with this guide.
{:.prompt-tip}

### Purpose of this Document
The purpose of this study guide is to provide an overview of the topics covered in the Azure Container Apps assessment lab. Each section provides a concise summary of key tasks, configuration steps, and best practices. Alongside each section, you'll find additional resources to reinforce your learning and help you gain a holistic understanding of deploying cloud-native apps in Azure.

---

# Section 1: Configure a Secure Connection Between an Azure Container Registry and an Azure Container App

In cloud-native app deployment, securing the connection between your Azure Container Registry (ACR) and Azure Container Apps (ACA) is crucial. This section outlines how to configure a secure connection using managed identities, ACRpull permissions, and private endpoints. We will go through each step to ensure a seamless and secure setup.

## 1.1 Configure a Managed Identity
A managed identity allows Azure services to authenticate and access other Azure resources without storing credentials in code. Here's how to set up a managed identity for your container app:

1. **Create a Managed Identity:**
   - When creating a container app in Azure, navigate to the **Identity** tab in the configuration settings.
   - Enable **System-assigned managed identity**. This will automatically generate an identity tied to your container app.
   
2. **Grant Permissions to the Managed Identity:**
   - Go to the **Azure Container Registry** that will store your container images.
   - Under **Access Control (IAM)**, add a **Role assignment**.
   - Select **ACRPull** as the role and assign it to the managed identity created in the previous step. This grants your container app the necessary permissions to pull images securely from ACR.

> **Tip:** Always use managed identities to avoid hard-coding credentials in your application, enhancing security and simplifying identity management.
{:.prompt-tip}

## 1.2 Configure ACRpull Permissions for the Managed Identity
After creating the managed identity and granting basic permissions, you'll need to configure specific ACRpull permissions:

1. **Assign ACRpull Role:**
   - Navigate to your Azure Container Registry.
   - Under **Access Control (IAM)**, select **Add role assignment**.
   - Choose **ACRPull** from the roles list and assign it to the system-assigned managed identity for your container app.
   
2. **Test the Connection:**
   - Attempt to pull a container image from your ACR to ensure the managed identity has the correct permissions.
   - Use the `az acr login` command to verify that the managed identity can access the ACR without manual credentials.

> **Tip:** If you encounter permission issues during this step, ensure the managed identity is correctly assigned to the ACRpull role. Double-check that the permissions have propagated, which may take a few minutes after initial assignment.
{:.prompt-tip}

## 1.3 Configure Private Endpoints
Private endpoints allow your container app to connect securely to the Azure Container Registry through an Azure virtual network. This step further enhances the security of your deployment.

1. **Create a Private Endpoint:**
   - In the Azure portal, navigate to your **Azure Container Registry**.
   - Under **Networking**, select **Private endpoint connections** and then click **+ Private endpoint**.
   - Follow the prompts to create a private endpoint within your virtual network.

2. **Integrate with Container Apps:**
   - Go to your container app environment in Azure.
   - Under **Networking**, link the virtual network containing the private endpoint to the container app.
   - Ensure that the DNS settings are configured correctly for the private endpoint.

> **Info:** Configuring private endpoints ensures that traffic between your container app and the ACR remains within the Azure network, avoiding exposure to the public internet and enhancing security.
{:.prompt-info}

3. **Test Private Endpoint Connectivity:**
   - After configuring the private endpoint, test the connectivity by deploying a container from the ACR to your Azure Container App.
   - Use tools like `curl` or `wget` within the container app environment to verify access to the ACR's private IP.

> **Tip:** Regularly audit your private endpoint configurations to ensure they are up-to-date and securely configured. Remove any unnecessary private endpoints to minimize potential attack surfaces.
{:.prompt-tip}

## Supporting Modules
- **Configure Azure Container Registry for Container App Deployments:** This module on Microsoft Learn offers a detailed walkthrough on setting up your ACR for secure container app deployments. Check it out for more in-depth information.

---

# Section 2: Create and Configure a Container App in Azure Container Apps

Creating a container app in Azure Container Apps involves setting up an environment, deploying the container, configuring services, and securing it with ingress settings and secrets. This section will guide you through each step to ensure your container app is set up correctly for deployment and scaling.

## 2.1 Create a Container App Environment
An environment is a secure boundary within which your container apps operate, sharing a common network, storage, and other resources.

1. **Create a New Environment:**
   - In the Azure portal, search for **Azure Container Apps** and select **Create**.
   - Under the **Basics** tab, select the **Subscription** and **Resource Group** for your container app environment.
   - Under the **Environment** section, select **Create new** and provide a name for the environment.
   - Choose a **Region** for the environment to determine the data center where your app will be hosted.
   - Configure the **Network** settings as required. You can select between a virtual network and a public network based on your app's needs.

> **Tip:** Choose the region closest to your target users to minimize latency and enhance app performance.
{:.prompt-tip}

## 2.2 Create a Container App
After setting up the environment, you need to create the container app itself.

1. **Define Container App Properties:**
   - In the **Basics** tab of the container app creation process, provide a name for the app and link it to the environment created earlier.
   - Under **Image Source**, select **Azure Container Registry** and specify the image to be deployed. Ensure that the managed identity has been configured to pull images from this registry.

2. **Configure the Container:**
   - Navigate to the **Configuration** tab.
   - Define the **CPU** and **Memory** allocation for the container. Select appropriate values based on the app’s resource requirements.

3. **Set Environment Variables:**
   - Add any necessary environment variables under the **Environment Variables** section. These variables allow you to pass configuration information to the container at runtime.

> **Info:** Environment variables are a crucial way to inject runtime configurations into your container, enabling flexibility without altering the codebase.
{:.prompt-info}

## 2.3 Add Services to the Environment
In a container app environment, you can add various services, such as databases, message queues, or other microservices, to enhance the app's functionality.

1. **Add a Service:**
   - Navigate to the environment’s overview page in the Azure portal.
   - Select **Add Service** and choose from the available options (e.g., Azure Cosmos DB, Azure Storage).
   - Follow the prompts to configure the service based on your app's needs.

2. **Integrate Services with the App:**
   - Update your container app to use the service. For example, add the database connection string as an environment variable or as a secret (discussed later) for secure access.

> **Tip:** Use Azure's managed services for common app components like databases and storage to simplify maintenance and scale efficiently.
{:.prompt-tip}

## 2.4 Configure Ingress for Services
Ingress controls how traffic is routed to your container app. By default, the container app is private, but you can expose it to the internet using ingress.

1. **Enable Ingress:**
   - Go to the **Networking** tab of your container app's settings.
   - Toggle the **Ingress** option to enable it.
   - Choose the **External** option if you want to expose the app to the internet, or **Internal** if it should only be accessible within the environment’s virtual network.

2. **Configure Ports and Protocols:**
   - Specify the port on which the container listens (e.g., 80 for HTTP).
   - Choose the protocol (HTTP, HTTPS, or TCP) based on your app’s requirements.

> **Info:** Use HTTPS for production environments to encrypt traffic and secure user data. Azure provides a built-in way to configure custom domains and TLS certificates for enhanced security.
{:.prompt-info}

## 2.5 Configure Secrets and Storage
Secrets and storage help manage sensitive information and persist data across container restarts.

1. **Add Secrets:**
   - In the **Secrets** tab of your container app, select **Add** and provide a key-value pair for each secret (e.g., database connection strings, API keys).
   - Reference these secrets within your container app using environment variables. For example, set an environment variable to the name of the secret and access it in your code at runtime.

2. **Configure Storage:**
   - Under the **Storage** tab, select **Add Volume**.
   - Choose a storage type (e.g., Azure Files) and provide a name for the volume.
   - Mount the storage to a path within your container app to persist data across restarts.

> **Tip:** Regularly rotate secrets and use Azure Key Vault to securely manage and automate secret handling. This ensures sensitive information is protected.
{:.prompt-info}

## Supporting Modules
- **Configure a Container App in Azure Container Apps:** For more detailed guidance on creating and configuring container apps, explore the relevant module in Microsoft Learn.

---

## Section 3: Configure Continuous Integration Using Azure Pipelines

# 3.1 Configure an Azure Container Apps Deployment Task – Part 1

The first part of setting up continuous integration involves creating a deployment pipeline in Azure DevOps that automatically deploys your container app whenever new code changes are pushed to your repository.

### Steps to Configure the Deployment Task

1. **Create a New Pipeline:**
   - Navigate to your **Azure DevOps** project.
   - Select **Pipelines** > **Create Pipeline**.
   - Choose the repository containing your container app code (e.g., GitHub, Azure Repos).
   - Select **Starter pipeline** or use an existing **YAML file** from your repository to define the pipeline configuration.

2. **Define the Deployment Task in YAML:**
   - In the YAML file, add a task to build your Docker image and push it to the Azure Container Registry (ACR). Here’s a simple example to get started:
     ```yaml
     jobs:
       - job: BuildAndPush
         pool:
           vmImage: 'ubuntu-latest'
         steps:
           - task: Docker@2
             displayName: 'Build and Push Docker Image'
             inputs:
               command: 'buildAndPush'
               repository: '$(Build.Repository.Name)'
               dockerfile: 'Dockerfile'
               containerRegistry: 'YourACRName.azurecr.io'
               tags: '$(Build.BuildId)'
     ```
   - Replace `YourACRName` with the name of your Azure Container Registry.

> **Tip:** Make sure your Dockerfile is correctly set up in the root of your repository for the build task to find it.
{:.prompt-tip}

3. **Run the Pipeline:**
   - Save the YAML file and run the pipeline. This will build the container image and push it to the Azure Container Registry.

# 3.1 Configure an Azure Container Apps Deployment Task – Part 2

With the container image built and pushed to the Azure Container Registry, the next step is to update your Azure Container App using the Azure CLI in the pipeline.

### Steps to Deploy the Container to Azure Container Apps

1. **Add the Azure CLI Task to the YAML File:**
   - In the same pipeline YAML file, add a new task using `AzureCLI@2` to deploy the container image to your Azure Container App:
  
     ```yaml
       - task: AzureCLI@2
         displayName: 'Deploy to Azure Container Apps'
         inputs:
           azureSubscription: 'YourAzureSubscription'
           scriptType: 'bash'
           scriptLocation: 'inlineScript'
           inlineScript: |
             az containerapp update --name YourContainerAppName \
                                   --resource-group YourResourceGroupName \
                                   --image YourACRName.azurecr.io/$(Build.Repository.Name):$(Build.BuildId)
     ```

   - Replace the placeholders:
     - `YourAzureSubscription`: The name of the Azure subscription in use.
     - `YourContainerAppName`: The name of the container app you want to update.
     - `YourResourceGroupName`: The resource group containing your container app.
     - `YourACRName`: The name of your Azure Container Registry.

2. **Run the Pipeline:**
   - Save the updated YAML file.
   - Run the pipeline again to update the Azure Container App with the new image from the container registry.

> **Tip:** You can use this deployment task to update the container app with different versions of your app by modifying the image tag. The `$(Build.BuildId)` tag is automatically generated to track different builds.
{:.prompt-tip}

---

# 3.2 Configure Secrets in Azure Key Vault

Azure Key Vault is a cloud service for securely storing and accessing secrets, such as API keys, passwords, or connection strings. In this part, you will create a Key Vault and store secrets needed for your container app.

### Steps to Create a Key Vault and Add Secrets

1. **Create a Key Vault:**
   - In the Azure portal, search for **Key Vaults** and select **Create**.
   - Provide the following details:
     - **Subscription**: Select your Azure subscription.
     - **Resource Group**: Choose an existing resource group or create a new one.
     - **Key Vault Name**: Enter a unique name for your Key Vault.
     - **Region**: Select the region closest to your app's deployment.
   - Click **Review + Create** and then **Create** to set up the Key Vault.

2. **Add Secrets to the Key Vault:**
   - After the Key Vault is created, navigate to it in the Azure portal.
   - Under the **Secrets** section, click **+ Generate/Import** to add a new secret.
   - Provide a name (e.g., `DatabasePassword`, `APIKey`) and value for the secret.
   - Click **Create** to store the secret.

> **Tip:** Use descriptive names for your secrets to make it easy to identify them in your application code or pipeline.
{:.prompt-tip}

Now that you've created a Key Vault and added secrets, the next step is to allow Azure Pipelines to access these secrets for use in your container app deployment pipeline.

### Steps to Grant Access to Azure Pipelines

1. **Grant Access to Azure Pipelines:**
   - In the Azure portal, navigate to your **Key Vault**.
   - In the left-hand menu, select **Access Policies** and click **+ Add Access Policy**.
   - Under **Configure from template (optional)**, select **Azure DevOps Service Connection**. This will automatically set the necessary permissions.
   - Under **Permissions**, ensure that **Get** permissions are selected for secrets.
   - In the **Select principal** section, choose the managed identity used by Azure Pipelines. If using an Azure DevOps service connection, you can locate the service principal by its name.
   - Click **Add** and then **Save** to apply the access policy.

> **Tip:** Always provide the least privileges necessary. For example, granting only **Get** permission ensures that Azure Pipelines can retrieve secrets but not modify them.
{:.prompt-tip}

2. **Verify Access:**
   - Once the access policy is applied, Azure Pipelines should have the necessary permissions to access the secrets stored in the Key Vault.

With the Azure Key Vault set up and access policies configured, the next step is to integrate Azure Key Vault into your pipeline to retrieve and use these secrets.

### Steps to Integrate Azure Key Vault in the Pipeline

1. **Add the Azure Key Vault Task to the YAML File:**
   - In your pipeline YAML file, add a task that retrieves secrets from Azure Key Vault using the `AzureKeyVault@2` task. Here’s an example configuration:

     ```yaml
       task: AzureKeyVault@2
       displayName: 'Fetch secrets from Azure Key Vault'
       inputs:
         azureSubscription: 'YourAzureSubscription'
         keyVaultName: 'YourKeyVaultName'
         secretsFilter: '*'
         runAsPreJob: true
     ```

   - Replace `YourAzureSubscription` with your Azure subscription's name and `YourKeyVaultName` with the name of the Key Vault you created.


1. **Use Secrets in the Pipeline:**
   - Once the secrets are fetched, you can use them as environment variables in the pipeline. For example:
     ```yaml
     - script: |
         echo "Database password is: $(DatabasePassword)"
       displayName: 'Use Key Vault Secrets'
     ```
   - Replace `DatabasePassword` with the name of the secret you created in Key Vault.

> **Tip:** Avoid echoing sensitive information like passwords in the pipeline output for security reasons. This example is for demonstration purposes only.
{:.prompt-tip}

3. **Verify the Integration:**
   - Save the YAML file and run the pipeline to ensure it can successfully retrieve and use the secrets from the Key Vault.

> **Info:** Using Azure Key Vault in the pipeline ensures that sensitive information like API keys, passwords, and connection strings are securely managed, reducing the risk of exposure.
{:.prompt-info}

---

# 3.3 Configure Environment Variables

Environment variables allow you to inject configuration settings into your containerized application without modifying the codebase. This part focuses on setting up environment variables in your Azure Pipeline.

### Steps to Configure Environment Variables in the Pipeline

1. **Define Environment Variables in the YAML File:**
   - In your pipeline YAML file, you can define environment variables that will be passed to the container during deployment. Here’s how to set an environment variable:
     ```yaml
     - script: |
         echo "##vso[task.setvariable variable=DATABASE_URL]$(DatabaseUrl)"
       displayName: 'Set Database URL Environment Variable'
     ```
   - Replace `DatabaseUrl` with the appropriate secret or configuration value.

2. **Use Environment Variables in Your Application:**
   - In your application code, access the environment variables using the standard method for your programming language:
     - For **Java**, use `System.getenv("DATABASE_URL")`.
     - For **Python**, use `os.environ.get("DATABASE_URL")`.
     - For **Node.js**, use `process.env.DATABASE_URL`.

3. **Pass Environment Variables to the Container:**
   - To pass these variables to your Azure Container App, use the `az containerapp update` command in the pipeline:
     ```yaml
     - task: AzureCLI@2
       displayName: 'Update Container App with Environment Variables'
       inputs:
         azureSubscription: 'YourAzureSubscription'
         scriptType: 'bash'
         scriptLocation: 'inlineScript'
         inlineScript: |
           az containerapp update --name YourContainerAppName \
                                 --resource-group YourResourceGroupName \
                                 --set-env-vars DATABASE_URL=$(DATABASE_URL)
     ```
   - Replace `YourAzureSubscription`, `YourContainerAppName`, and `YourResourceGroupName` with their actual values.

> **Tip:** Make sure to use consistent naming for environment variables across your codebase and pipeline to avoid configuration issues.
{:.prompt-tip}

4. **Verify Environment Variable Configuration:**
   - Save the YAML file and run the pipeline to ensure that the environment variables are correctly set and passed to the container app.

> **Info:** Configuring environment variables in this manner allows you to manage settings dynamically without the need to alter the application code for each deployment.
{:.prompt-info}

---

# Section 4: Scale a Deployed App in Azure Container Apps 

Scaling your application is crucial for managing varying loads and optimizing resource usage. In this part, we’ll cover how to configure HTTP scale rules to automatically adjust the number of container instances based on HTTP traffic.

## 4.1 Configure HTTP Scale Rules

HTTP scale rules allow your container app to handle varying levels of web traffic efficiently by adjusting the number of instances based on the volume of HTTP requests.

### Steps to Configure HTTP Scaling

1. **Access Scaling Settings:**
   - In the Azure portal, navigate to your **Azure Container App**.
   - In the left panel, select **Scale**, then click on **+ Add scale rule**.

2. **Set Up HTTP Scaling:**
   - Choose **HTTP scaling** as the rule type.
   - Configure the **Concurrency** setting to define how many HTTP requests each container instance can handle before scaling up. For example, set it to `50` requests per instance.
   
3. **Define Scaling Limits:**
   - Set the **Minimum Instances** to ensure a baseline level of availability, even during low traffic periods (e.g., set to `1`).
   - Set the **Maximum Instances** to limit the number of instances that can be scaled up to control costs (e.g., set to `10`).

4. **Save the Scaling Rule:**
   - Click **Save** to apply the HTTP scaling rule to your container app.

> **Tip:** Monitor your app's performance using Azure Monitor to adjust the concurrency settings and instance limits based on real traffic patterns.
{:.prompt-tip}

In addition to HTTP scaling, you can configure TCP scale rules to manage applications that use TCP connections, such as chat applications, real-time services, or IoT solutions.

## 4.2 Configure TCP Scale Rules

TCP scale rules adjust the number of container instances based on the number of active TCP connections, ensuring that your app can handle varying levels of persistent connections efficiently.

### Steps to Configure TCP Scaling

1. **Access Scaling Settings:**
   - In the Azure portal, navigate to your **Azure Container App**.
   - Select **Scale** from the left-hand menu and click on **+ Add scale rule**.

2. **Set Up TCP Scaling:**
   - Choose **TCP scaling** as the rule type.
   - Define the **Connection Threshold**, which determines the number of active TCP connections that each container instance can handle before scaling up. For example, set the threshold to `100` connections.

3. **Define Scaling Limits:**
   - Set the **Minimum Instances** to a baseline number (e.g., `1`) to ensure your app is always available.
   - Set the **Maximum Instances** to a higher limit (e.g., `10`) to prevent excessive scaling and control costs.

4. **Save the Scaling Rule:**
   - Click **Save** to apply the TCP scaling rule to your container app.

> **Info:** TCP scaling is particularly useful for applications that rely on persistent connections, like real-time data processing or communication services. Adjust the connection threshold based on your app's performance and requirements.
{:.prompt-info}

# Section 4: Scale a Deployed App in Azure Container Apps – Part 3

Custom scale rules offer flexibility to scale your application based on custom metrics or events, such as CPU usage, memory consumption, or custom events from sources like Azure Event Hubs.

## 4.3 Configure Custom Scale Rules

Custom scale rules use **KEDA (Kubernetes-based Event Driven Autoscaling)** to define how and when to scale your container app based on specific metrics or triggers.

### Steps to Configure Custom Scaling

1. **Access Scaling Settings:**
   - In the Azure portal, navigate to your **Azure Container App**.
   - Select **Scale** from the left-hand menu and click **+ Add scale rule**.

2. **Set Up Custom Scaling with KEDA:**
   - Choose **Custom scaling** as the rule type.
   - Select a scaling mechanism. Some common options include:
     - **CPU:** Scale based on CPU usage.
     - **Memory:** Scale based on memory usage.
     - **Azure Queue:** Scale based on the number of messages in an Azure Storage queue.
     - **Azure Service Bus:** Scale based on the number of messages in a Service Bus queue or topic.

3. **Configure KEDA Trigger Parameters:**
   - For example, to scale based on CPU usage:
     - Set the **Trigger** to **CPU**.
     - Define the **Target CPU** utilization percentage that will trigger scaling (e.g., 70%).
   - For other triggers, such as Azure Queue, specify the **queue length** that will prompt scaling.

4. **Define Scaling Limits:**
   - Set the **Minimum Instances** to ensure a baseline level of availability.
   - Set the **Maximum Instances** to control the maximum scale and manage costs.

5. **Save the Custom Scale Rule:**
   - Click **Save** to apply the custom scaling rule to your container app.

> **Tip:** Custom scale rules give you fine-grained control over scaling behavior, allowing you to tailor it to your app's specific workload. Use metrics from Azure Monitor to help define appropriate trigger parameters.
{:.prompt-tip}

---

# Section 5: Manage Revisions in Azure Container Apps – Part 1

Managing revisions is crucial for deploying changes, testing new features, and rolling back to previous versions in your application. This part covers how to set up a staging environment to safely test changes before they go live.

## 5.1 Set Up a Staging Environment

A staging environment is a replica of your production environment where you can deploy and test new changes. This allows you to identify potential issues before deploying to production, ensuring that updates work as expected.

### Steps to Set Up a Staging Environment

1. **Create a New Environment:**
   - In the Azure portal, go to **Azure Container Apps** and select **Create**.
   - Under the **Basics** tab, select the **Subscription** and **Resource Group** you want to use.
   - Name the environment something like "Staging" to distinguish it from the production environment.
   - Choose the **Region** closest to your production deployment for consistency.

2. **Replicate Production Settings:**
   - Configure the **Networking** and other settings to match those in your production environment. This ensures that the staging environment behaves similarly to the production environment.
   - Include the same services, secrets, and storage configurations in the staging environment to mirror the production setup.

3. **Deploy to the Staging Environment:**
   - Deploy your container app to the newly created staging environment using the same pipeline or Azure CLI commands.
   - Test the application in the staging environment to verify that the changes work as intended.

> **Tip:** Always test new changes in the staging environment before deploying to production. This minimizes the risk of introducing bugs or downtime in the production environment.
{:.prompt-tip}

Azure Container Apps support different revision modes that allow you to manage how new versions of your application are deployed and how traffic is routed between these revisions. This part covers how to choose the appropriate revision mode for your app.

## 5.2 Choose a Revision Mode

Choosing the right revision mode is crucial for managing deployments, testing new features, and rolling back to previous versions. Azure Container Apps offer two modes: **Single** and **Multiple**.

### Steps to Choose a Revision Mode

1. **Access Revision Settings:**
   - In the Azure portal, navigate to your **Azure Container App**.
   - Under the **Revisions** section, locate the **Revision Mode** settings.

2. **Select a Revision Mode:**
   - **Single Revision Mode:**
     - This mode activates only one revision of your app at any given time. Any new deployment replaces the current revision.
     - Choose this mode if your app does not require traffic splitting or gradual rollouts.
   - **Multiple Revision Mode:**
     - This mode allows multiple revisions of your app to run simultaneously, enabling advanced traffic management and testing capabilities.
     - Ideal for scenarios where you want to perform A/B testing, canary deployments, or gradual rollouts of new features.
   
3. **Save the Revision Mode:**
   - Select the desired revision mode and click **Save** to apply the changes.

> **Info:** It’s recommended to use **Multiple Revision Mode** for production environments where you need flexibility in managing deployments, traffic splitting, and rollbacks.
{:.prompt-info}

4. **Verify the Revision Mode:**
   - Ensure that the selected revision mode aligns with your deployment strategy and application requirements.

> **Tip:** If you're starting with a new application or testing features, use **Multiple Revision Mode** to gain more control over how new changes are introduced to users.
{:.prompt-tip}

Creating new revisions in Azure Container Apps allows you to implement updates and changes while keeping the previous version intact. This part covers how to create a new revision whenever you deploy an update to your application.

## 5.3 Create a New Revision

In **Multiple Revision Mode**, each deployment creates a new revision of your container app, enabling you to switch between different versions easily.

### Steps to Create a New Revision

1. **Update Your Application:**
   - Make the necessary changes to your application code or update environment variables, secrets, or configurations.
   - Ensure that your changes are committed to the repository that your CI/CD pipeline monitors.

2. **Deploy the Updated App:**
   - Trigger your CI/CD pipeline to deploy the updated container image. When using **Multiple Revision Mode**, this deployment automatically creates a new revision.
   - If you are using Azure CLI, deploy the update using:
     ```bash
     az containerapp update --name YourContainerAppName \
                           --resource-group YourResourceGroupName \
                           --image YourACRName.azurecr.io/YourImageName:tag
     ```
   - Replace the placeholders with the relevant names for your application.

3. **View Revisions:**
   - In the Azure portal, go to your **Azure Container App** and select **Revisions**.
   - You will see a list of active and inactive revisions. The newly created revision will appear here with details such as the image tag, environment variables, and other configuration settings.

4. **Test the New Revision:**
   - If you are using traffic splitting (covered in the next section), route a portion of the traffic to the new revision to test its performance and behavior.

> **Info:** Each new revision is immutable, meaning once it is created, you cannot modify it. This approach allows you to safely test new changes and roll back to a previous stable revision if needed.
{:.prompt-info}

> **Tip:** Use descriptive tags or notes for each revision during deployment to make it easy to identify changes and track different versions of your app.
{:.prompt-tip}

Traffic splitting allows you to control how much traffic each revision of your application receives. This enables you to perform A/B testing, canary deployments, or gradually roll out new features in a controlled manner.

## 5.4 Configure Traffic Splitting

With traffic splitting, you can manage and monitor the rollout of new revisions to ensure they are performing as expected before directing all traffic to them.

### Steps to Configure Traffic Splitting

1. **Access Traffic Settings:**
   - In the Azure portal, navigate to your **Azure Container App**.
   - Select the **Revisions** section, then click on **Traffic**.

2. **Set Up Traffic Splitting:**
   - You will see a list of active revisions. By default, the newest revision may receive 100% of the traffic.
   - Adjust the traffic distribution by modifying the percentage of traffic allocated to each revision. For example:
     - Allocate 90% of the traffic to the stable revision.
     - Allocate 10% of the traffic to the new revision.
   - Use the sliders or input the exact percentage values to control how traffic is divided between revisions.

3. **Save Traffic Settings:**
   - Click **Save** to apply the traffic split configuration. Azure Container Apps will automatically route incoming requests based on the percentages specified.

4. **Monitor Traffic and Performance:**
   - Use **Azure Monitor** and **Application Insights** to observe the behavior of users interacting with the different revisions. Monitor metrics such as error rates, response times, and resource usage.
   - If the new revision performs well, gradually increase its traffic allocation until it reaches 100%. Conversely, if issues arise, reduce its traffic or route all traffic back to the stable revision.

> **Tip:** Traffic splitting is especially useful when you want to test new features with a small subset of users (canary releases) or conduct A/B testing to evaluate different versions of your application.
{:.prompt-tip}

5. **Roll Back if Necessary:**
   - If you encounter problems with the new revision, you can quickly adjust the traffic settings to route 100% of the traffic back to the previous stable revision.

> **Info:** Traffic splitting offers a flexible way to safely test changes in a live environment, ensuring that new revisions do not negatively impact user experience.
{:.prompt-info}

---

# Conclusion

Deploying cloud-native apps using Azure Container Apps provides a powerful, flexible, and secure environment for managing containerized applications. This study guide has walked you through the essential tasks involved in this process, from setting up a secure connection with Azure Container Registry to managing application revisions with traffic splitting. By understanding and mastering these areas, you can efficiently deploy, scale, and manage containerized apps in Azure with confidence.

## Summary of Key Points

Here’s a quick recap of the key topics covered in this study guide:

1. **Configure a Secure Connection:** Managed identities, ACRpull permissions, and private endpoints work together to secure the connection between Azure Container Registry and Azure Container Apps, ensuring that your deployments are both secure and efficient.

2. **Create and Configure a Container App:** Creating an environment for your container apps and setting up services, ingress, secrets, and storage is foundational to building a robust containerized application.

3. **Configure Continuous Integration:** Using Azure Pipelines allows for seamless automation of building, testing, and deploying your container app. Integrating Azure Key Vault for secret management further enhances the security of your pipeline.

4. **Scale the App:** Azure Container Apps provide flexibility with HTTP, TCP, and custom scaling rules to handle varying workloads. Properly configuring these rules ensures optimal performance and resource usage.

5. **Manage Revisions:** Using revisions and traffic splitting in Azure Container Apps enables safe deployments, A/B testing, and quick rollbacks, helping to maintain a stable production environment.

> **Info:** The modular nature of Azure Container Apps allows you to mix and match services, scaling strategies, and deployment approaches to meet the unique needs of your application. Always tailor these configurations to suit your app's workload and user requirements.
{:.prompt-info}

## Additional Tips for Real-World Deployments

- **Monitor Continuously:** Use Azure Monitor and Application Insights to gather insights into app performance, traffic patterns, and resource usage. These metrics are invaluable for refining scaling rules and identifying bottlenecks.

- **Automate Testing:** Integrate testing into your CI/CD pipeline to automatically validate new changes in the staging environment. This helps catch bugs before they reach production, reducing downtime and improving user experience.

- **Optimize Costs:** Azure Container Apps charge based on usage. By fine-tuning scaling rules, configuring optimal resource limits, and leveraging traffic splitting, you can ensure your app runs efficiently, minimizing costs while maintaining performance.

- **Use Blue-Green Deployments:** For mission-critical applications, consider using blue-green deployment strategies with traffic splitting. This approach minimizes downtime and allows for easy rollback if issues arise.

## Next Steps

With this comprehensive overview, you're now well-prepared to deploy cloud-native applications using Azure Container Apps. However, there is always room to deepen your knowledge and refine your deployment practices. Here are some additional learning resources to explore:

- **Microsoft Learn Modules:** Expand your expertise by exploring related modules on Microsoft Learn, such as "Implement Infrastructure as Code" and "Monitor Container Apps with Azure Monitor."

- **Experiment with Different Scaling Strategies:** Hands-on practice is key to mastering scaling. Experiment with different scaling rules, such as CPU or custom metrics, to find the optimal configuration for your specific app.

- **Explore Advanced Security Features:** Beyond managed identities and Key Vault, delve into other Azure security features like **Azure Policy** and **Network Security Groups (NSGs)** to enforce compliance and secure your containerized apps.

## Final Thoughts

Azure Container Apps simplifies the complexity of deploying, managing, and scaling cloud-native applications. By utilizing the features and best practices discussed in this guide, you can build resilient, secure, and high-performing container apps that adapt to changing demands.

> **Tip:** Continuously improve your deployment strategy. Regularly review logs, performance metrics, and user feedback to fine-tune configurations and enhance your application's reliability and user experience.
{:.prompt-tip}

---

## Achievement: Guided Project Completion

I have completed the "Deploy and manage a container app using Azure Container Apps" guided project. Here is the trophy I earned upon completion:

- [Trophy for Guided Project Completion](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/ZKPGG332?sharingId=832434226F60339B)

## Modules Completed

Here are the individual modules I completed as part of this guided project:

- [Module 1 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/B6LG5BKD?sharingId=832434226F60339B)
- [Module 2 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/FVZEP9ZX?sharingId=832434226F60339B)
- [Module 3 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/J96HVUNT?sharingId=832434226F60339B)
- [Module 4 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/HAY2L2Z8?sharingId=832434226F60339B)
- [Module 5 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/UYF7GG93?sharingId=832434226F60339B)
- [Module 6 Badge](https://learn.microsoft.com/api/achievements/share/en-us/RyanKerby-2350/ESJ33FNP?sharingId=832434226F60339B)


---

# References

Here are some resources that provide additional information on the topics covered in this guide:

1. **Azure Container Apps Documentation:**  
   [https://learn.microsoft.com/en-us/azure/container-apps/](https://learn.microsoft.com/en-us/azure/container-apps/)

2. **Azure Key Vault Documentation:**  
   [https://learn.microsoft.com/en-us/azure/key-vault/](https://learn.microsoft.com/en-us/azure/key-vault/)

3. **Azure Pipelines Documentation:**  
   [https://learn.microsoft.com/en-us/azure/devops/pipelines/](https://learn.microsoft.com/en-us/azure/devops/pipelines/)

4. **Azure Container Registry Documentation:**  
   [https://learn.microsoft.com/en-us/azure/container-registry/](https://learn.microsoft.com/en-us/azure/container-registry/)

5. **Kubernetes-based Event Driven Autoscaling (KEDA):**  
   [https://keda.sh/](https://keda.sh/)

6. **Scaling in Azure Container Apps:**  
   [https://learn.microsoft.com/en-us/azure/container-apps/scale-app](https://learn.microsoft.com/en-us/azure/container-apps/scale-app)

7. **Monitoring Azure Container Apps:**  
   [https://learn.microsoft.com/en-us/azure/container-apps/monitor](https://learn.microsoft.com/en-us/azure/container-apps/monitor)

8. **Microsoft Learn Modules:**  
   Explore more in-depth guides and hands-on tutorials: [https://learn.microsoft.com/en-us/training/](https://learn.microsoft.com/en-us/training/)

> **Note:** Refer to the official Azure documentation for the latest information, best practices, and updates related to Azure Container Apps and other Azure services.
{:.prompt-warning}








