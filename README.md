# Azure Container Apps Demo

## Introduction

When working on large and complex solutions that involve multiple delivery teams, achieving efficient and autonomous deployment practices can be a challenge. Azure Kubernetes Service (AKS) is a popular choice for managing containerised workloads, but cross-cutting concerns and resource management complexities can limit team autonomy.

In this repo, we’ll explore migrating such workloads to Azure Container Apps (ACA), and how this can help overcome these challenges by enabling autonomous deployments within a secure environment.

This repository demonstrates a container-based application deployed to Azure Container Apps, running within a virtual network, with secure networking to other Azure services such as PostgreSQL and Azure Key Vault.

We'll also implement an application gateway to allow external access to the container app through a single endpoint.

### Objectives

The objectives of this repository are to demonstrate:

- A container-based solution using Azure Container Apps and PostgreSQL flexible server
- Container image sourced from a private Azure Container Registry
- Secrets managed securely with Azure Key Vault
- Run services privately within a virtual network
- Provide external access to the container app via an application gateway
- Secure traffic between Azure services using private endpoints and managed identity

## Design

The following diagram illustrates the high level architecture of the solution:

![Architecture](docs/architecture.drawio.svg)

### Description

TODO

## Cost Estimation

TODO

## Conclusion

TODO

## Next Steps

TODO
