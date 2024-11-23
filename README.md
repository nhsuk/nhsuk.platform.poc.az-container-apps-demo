# Azure Container Apps Demo

## Introduction

When working on large solutions that involve multiple delivery teams, achieving efficient and autonomous deployment practices can be a challenge. Azure Kubernetes Services (AKS) is a popular choice for managing containerised workloads, but cross-cutting concerns and resource management complexities can limit team autonomy.

In this repo, we’ll explore migrating such workloads to Azure Container Apps (ACA), and how this can help overcome these challenges by enabling autonomous deployments within a secure environment.

This repository demonstrates a container-based application deployed to Azure Container Apps running within a virtual network, with secure networking to other commonly used Azure services such as PostgreSQL and Azure Key Vault.

We'll also implement an application gateway to allow external access to the private container app through a single endpoint.

## Design

The following diagram illustrates the high level design of the solution:

![Architecture](docs/architecture.drawio.svg)

### Description

**1.** All private services run within a virtual network, and are connected to their own subnets with a unique address range. Services that do not run natively within a vnet such as Key Vault and ACR are connected via private endpoints (see point 5).

**2.** External access to the container app routed via an application gateway with a public ip - only http traffic on port 80 is allowed and all other traffic will be blocked.

**3.** The Azure Container App deployment consists of an environment and a container app. The image used by the container app, which is a dummy web application running in an nginx, is sourced from Azure Container Registry (see point 7). The solution also demonstrates the provision of secrets to the container app as environment variables, sourced from Azure Key Vault (see point 6).

**4.** A private PostgreSQL flexible server instance is deployed as an example of typical infrastructure which features in an enterprise solution. **At time of writing the container app doesn't actually connect to the database - coming soon!**

**5.** Some Azure services do not run natively within a vnet, however they can be securely connected to the network via private link and private endpoints. Private endpoints need to be connected to their own subnet.

**6.** A private Azure Key Vault will be created as an example of a typical way of managing secrets in an enterprise solution. The PostgreSQL admin credentials are added to the key vault.

**7.** A private Azure Container Registry will be created, and an image for a dummy nginx web application (which can be found in the `./tools` directory) which is used by the container app will be pushed when the terraform is deployed.

**8.** The diagnostics produced by the app gateway are sent to a log analytics workspace for debugging and tracing.

## Usage

### Pre-Requisites

The following are pre-reqs to working with the solution:

- Windows environment (sorry Linux folk, PowerShell is currently used to run terminal commands)
- Terraform installed
- Docker installed
- An Azure subscription with the `Microsoft.App` resource provider registered (required for container apps)
- An Azure identity (e.g. service principal) with the following roles assigned at the subscription level:
    - `Contributor` (to create resources)
    - `AcrPush` (to push the container image of the hello world app to the ACR)
    - `RBAC Administrator` constrained to the following roles:
        - `AcrPull`

### Deployment

To deploy the solution, open a terminal and navigate to the `./infrastructure` directory.

Initialise terraform with the following command:

```pwsh
terraform init
```

Then apply the terraform with the following command:

```pwsh
terraform apply -auto-approve
```

### Known Issues

The following are known issues in the demo, which should be considered when using this it for something beyond a proof of concept:

- A firewall rule allowing traffic from the IP of the deployment agent (e.g. your IP) is created on various private resources to allow the terraform deployment to complete its tasks. The firewall rule should be removed after deployment, or alternatively run the deployment from an Azure agent that can access the private network.

- You may have certain policies in place that this module is not aware of which will cause the deployment to fail - e.g. mandatory tags. It is down to you to amend the code to adhere to the policies.
