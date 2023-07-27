# Talent-plus Take-Home Project

## Project: Design and Implement a Microservice-based Application with Helm and a DevOps Pipeline

## Objective

The objective of this documentation is to guide you through the process of designing and implementing a simple microservice-based application, packaging it with Helm, and constructing a CI/CD pipeline using GitHub Actions. The application consists of a frontend and backend, both built using Node.js, and it will be deployed to an Amazon EKS cluster provisioned using Terraform.

## Table of Contents

1. Prerequisites
2. Application Overview
3. Creating the Microservices to run locally
4. Provisioning the EKS Cluster with Terraform
5. Setting Up GitHub Actions CI/CD Pipeline
6. Conclusion

## 1. Prerequisites

Before starting the implementation, ensure you have the following prerequisites in place:

- An AWS account with appropriate permissions to create and manage EKS resources.
- AWS CLI installed and configured with your AWS credentials.
- Node.js and npm installed on your local development machine.
- Docker installed on your local development machine.
- Terraform installed on your local development machine.
- A GitHub repository to host your application code and GitHub Actions.

## 2. Application Overview

The microservice-based application will consist of two components:

- Frontend: A Node.js web application that provides a user interface.
- Backend: A Node.js server application that processes requests from the frontend and communicates with a MySQL database.




## 3. Creating the Microservices to run Locally

In the `app` folder, create the frontend and backend components.

### Frontend
- Frontend: The frontend application was built using React framework 
which communicates with backend.

Install the dependencies for the frontend application 

```bash
cd frontend
npm i
npm start
``````

### Bavkend

- Backend: The backend application was built using RNodejs which communicates with a mysql database.

```bash
cd backend
npm i
npm start
``````

## 4. Provisioning the EKS Cluster with Terraform

In the `terraform` folder, create the Terraform configuration files to provision the EKS cluster and other necessary resources.

- `main.tf`: Define the AWS provider, VPC, EKS cluster, and other required resources.
- `variables.tf`: Declare the variables needed for your Terraform configuration.

Run `terraform init`, `terraform plan`, and `terraform apply` to create the EKS cluster and related resources on AWS.

## 5.  GitHub Actions CI/CD Pipeline

The pipeline runs and executes the following steps:

1. On push to the main branch, trigger the pipeline.
2. Use Terraform to provision the EKS cluster and infrastructure (e.g., VPC, subnets).
3. Build Docker images for the frontend and backend applications.
4. Push the Docker images to Amazon ECR repository.
5. Deploy the application to the EKS cluster using Helm.

The pipeline includes environment variables for AWS credentials to securely access AWS resources.

## 6. Conclusion

I designed and implemented a simple microservice-based application, packaged it with Helm, and constructed a CI/CD pipeline using GitHub Actions. The application is now automatically deployed to an EKS cluster whenever you push changes to the main branch. This pipeline ensures a seamless and efficient workflow for your development and deployment process.


