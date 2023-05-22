# Section 3 Design 2

## Overview
- System design for data infrastructure on Azure cloud for a company whose main business is in processing images.
- Additionally, Apache Kafka is hosted on Confluent Cloud as SaaS that integrates readily with Azure cloud services.

## System Architecture Overview

There are 2 data flows in the design as per the task requirement, one that involves web application with cloud storage and another that involes web application with Kafka streams. See below for explanation.

### Design Flow A

- User uploads image via web application
    - Web application stores image and metadata in cloud through Azure Storage API
        - Azure Blob Storage stores unprocessed images and metadata
            - Azure Functions is deployed with script for processing images and metadata processing
                - Processed images are stored in Azure Blob Storage
                - Processed metadata is stored in Azure Cosmos DB 
                    - Power BI on Azure access data in blob storage and cosmos db for analysis

### Design Flow B

- User uploads image via web application
    - Web application passes image and metadata to Confluent Kafka using API
        - Confluent Kafka stores and serves image and metadata in real-time
            - Azure Functions is deployed with script for processing images and metadata processing
                - It is configured with Kafka Sink Connector for Confluent Platform to consume data from Kafka streams
                - Processed images are stored in Azure Blob Storage
                - Processed metadata is stored in Azure Cosmos DB 
                    - Power BI on Azure access data in blob storage and cosmos db for analysis

## System Architecture Diagram

- Both design flow A and design flow B are detailed in the [system-design.png](https://github.com/msafiullah/Safi-GovTech-SeniorDETechAssessment-23/blob/main/section3/design2/system-design.pdf) diagram.

### Designed Considerations

| Design Description | Addressed Best Practices |
|--|--|
| Deploying the 2 web apps in Azure App Service that can scale out to multiple containers depending on web app usage demand. | `Scalability`, `High Availability`, `Elasticity`, `Fault Tolerant and Disaster Recovery`
| Using Azure Functions to process incoming data that can scale up and out depending on usage demand. | `Scalability`, `High Availability`, `Elasticity`, `Fault Tolerant and Disaster Recovery`, `Managability`
| Using Azure Cosmos DB, a distributed MongoDB NoSQL implementation for storing data about uploaded and processed images. Can be scaled to support additional capacity or resource needs. | `Scalability`, `High Availability`, `Elasticity`, `Fault Tolerant and Disaster Recovery`, `Managability`, `Efficiency`
| Confluent Kafka is to be configured with back-up cluster with replication. | `Scalability`, `High Availability`, `Elasticity`, `Fault Tolerant and Disaster Recovery`, `Managability`
| Azure Blob Storage can be scaled to accomodate changing capacity needs. | `Scalability`, `High Availability`, `Elasticity`, `Fault Tolerant and Disaster Recovery`, `Managability`
| Data in transit is secured through Network Security Groups and Private Virtual Network connection with encryption keys stored in Key Vault. | `Managability`, `Secure`
| Identity Management for external users and internal employees is supported by using Azure Active Directory with least privilege permissions by default. | `Managability`, `Secure`, `Least Privilege`
| API calls are only allowed through HTTPS/TLS. | `Secure`
