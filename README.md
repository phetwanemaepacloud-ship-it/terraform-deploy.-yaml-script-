Infrastructure Deployment README

Overview

This directory contains the Terraform and shell configuration used to provision and configure the application's AWS infrastructure.


The files are organized around the main stages of deployment:


1. Provider and variables – define AWS access, regions, and deployment inputs.
2. Networking – create the VPC, subnets, routing, and NAT connectivity.
3. Security – define security groups and IAM permissions.
4. Data layer – provision RDS and supporting database migration infrastructure.
5. Application/backend layer – define the compute resources and application configuration.
6. AWS services – configure DNS, notifications, secrets, and other supporting services.
7. Outputs – expose important values such as endpoints and resource identifiers.


Important: The descriptions below are based on the filenames shown in the deployment directory. The exact resources and behavior depend on the contents of each Terraform file.




File-by-file deployment responsibilities,
Deployment stage and purpose. 

provider.tf	
Initialization	
Configures Terraform providers, primarily AWS, and establishes the region/provider settings used by the rest of the infrastructure.

variables.tf	
Configuration	
Declares reusable Terraform variables such as environment, region, VPC settings, instance configuration, database settings, and other deployment inputs.

terraform.tfvars	
Configuration	
Supplies concrete values for the variables declared in variables.tf. This is normally where environment-specific settings are provided. Do not commit sensitive values.

vpc.tf	
Networking	
Creates the core VPC networking infrastructure, such as the VPC, subnets, internet connectivity, and associated network configuration.

route53.tf	
DNS	
Creates or configures Route 53 DNS records and/or hosted zones so application domains can resolve to the deployed infrastructure.

nat-gateway.tf	
Networking	
Provides outbound internet access from private subnets through a NAT Gateway, while keeping private resources inaccessible directly from the public internet.

security-groups.tf	Security	Defines AWS security groups and network access rules controlling which systems can communicate with EC2, RDS, and other resources.

ec2-profile-role.tf	
IAM / Compute	
Creates an IAM role and instance profile for EC2, allowing deployed instances to access permitted AWS services without storing long-lived AWS credentials on the server.

acm.tf	
Security / TLS	
Provisions or references an AWS Certificate Manager certificate used to provide HTTPS/TLS encryption for application endpoints or domains.

alb.tf	
Load balancing	
Creates/configures the Application Load Balancer that receives incoming HTTP/HTTPS traffic and distributes it to backend application instances or targets.

backend.tf
Application	
Defines the backend/application infrastructure and its supporting AWS configuration. This is typically where application compute, target groups, listeners, or backend-specific resources are connected.

rds.tf	
Database	
Provisions the managed relational database environment using Amazon RDS, including database configuration, networking, storage, and security settings.

db-migrate-server.tf	
Database migration	
Defines infrastructure for a server or compute resource responsible for running database migrations during deployment.

db-migrate-script.sh	
Database migration	
Shell script used to execute database migration commands against the deployed database. It is typically run after the database and application prerequisites are available.

secrets-manager.tf	
Secrets / Security	
Creates or configures AWS Secrets Manager resources for securely storing sensitive values such as database credentials, API keys, tokens, or application secrets.

sns.tf	
Notifications	
Configures Amazon SNS resources used for notifications, alerts, or event-driven messaging between AWS components and/or subscribers.

eice.tf	
Secure administration	
Configures AWS EC2 Instance Connect Endpoint (EIC/EICE) functionality, where used, to allow secure administrative access to instances without requiring a public SSH endpoint.

outputs.tf	
Deployment outputs	
Exposes useful values after terraform apply, such as load balancer DNS names, database endpoints, VPC IDs, certificate information, or other resource identifiers.

terraform-module/	
Reusable infrastructure	
Contains Terraform modules used to package reusable infrastructure logic so the same deployment patterns can be applied consistently across environments or components.

.gitignore	
Source control	
Prevents files that should not be committed to Git from being tracked, such as Terraform state files, local variables, credentials, temporary files, and generated artifacts.
==========================================================================================



Deployment flow

A typical deployment using these files follows a dependency-driven process rather than simply executing the files from top to bottom. Terraform builds a dependency graph and creates resources in the appropriate order.


1. Terraform initialization

terraform init

Terraform downloads the required providers and initializes any configured modules/backend.


Primary files:


provider.tf
terraform-module/


2. Load deployment configuration

Terraform reads:


variables.tf – defines the available inputs.
terraform.tfvars – provides environment-specific values.

Example:


terraform plan -var-file="terraform.tfvars"

Sensitive values should preferably be supplied through secure CI/CD variables, environment variables, or a secrets-management solution rather than committed directly to Git.



3. Build the network

The networking layer provides the foundation for the rest of the deployment.


Primary files:


vpc.tf
nat-gateway.tf
route53.tf (DNS is generally configured alongside the infrastructure but may depend on later resources)
security-groups.tf

Conceptually:


AWS Region
   │
   └── VPC
       ├── Public Subnets
       │   ├── Internet-facing resources
       │   └── NAT Gateway
       │
       └── Private Subnets
           ├── Backend / EC2
           └── RDS

The exact subnet layout depends on the Terraform configuration.



4. Configure security and IAM

Before application resources can operate correctly, the required permissions and network rules need to exist.


Primary files:


security-groups.tf
ec2-profile-role.tf
secrets-manager.tf
eice.tf

This stage establishes:


Network-level access rules.
EC2 IAM permissions.
Secure secret storage.
Secure administrative connectivity where configured.

The principle of least privilege should be used: resources should receive only the permissions they actually require.



5. Provision the database

The database layer is created using:


rds.tf

The RDS instance/cluster should be placed in the intended private network and protected by the appropriate security group.


Typical dependency chain:


VPC
 │
 ├── Private Subnets
 │
 ├── Database Security Group
 │
 └── RDS

Application resources should only be permitted to communicate with the database on the required database port.



6. Configure HTTPS

The certificate infrastructure is handled by:


acm.tf

The ACM certificate provides TLS encryption for supported public application endpoints.


Typical flow:


Client
  │
 HTTPS
  ▼
ALB
  │
  ▼
Backend

Certificate validation may require Route 53 DNS records when DNS validation is used.



7. Deploy the application/backend

The backend infrastructure is defined primarily through:


backend.tf
alb.tf
ec2-profile-role.tf

The deployment generally connects:


Internet
   │
   ▼
Route 53
   │
   ▼
ACM / HTTPS
   │
   ▼
Application Load Balancer
   │
   ▼
Backend / EC2
   │
   ▼
RDS

The EC2 IAM instance profile allows the application server to access approved AWS services without embedding permanent AWS access keys.



8. Run database migrations

After the database and required application configuration are available, the migration infrastructure can be used.


Files:


db-migrate-server.tf
db-migrate-script.sh

The general process is:


RDS available
     │
     ▼
Migration server/environment
     │
     ▼
db-migrate-script.sh
     │
     ▼
Database schema updated

Migrations should normally be run only after confirming that the target database is reachable and the required secrets/environment variables are available.



9. Configure notifications

sns.tf

SNS can be used for:


Deployment/application notifications.
Alerts.
Event-driven messaging.
Publishing events to subscribed services.

The exact notification workflow depends on the resources defined in this file.



10. Configure DNS

route53.tf

Route 53 connects the application's domain name to the appropriate AWS endpoint.


For example:


https://api.example.com
          │
          ▼
      Route 53
          │
          ▼
         ALB
          │
          ▼
       Backend


11. Review deployment outputs

After deployment:


terraform output

The values exposed by:


outputs.tf

can provide important information needed by developers, operators, CI/CD pipelines, or application configuration.


Examples may include:

Load balancer DNS name.
Application URL.
VPC ID.
RDS endpoint.
Resource IDs.
Other deployment-specific values.
==========================================================================================



Recommended Terraform deployment sequence

Although Terraform automatically handles dependencies, a normal deployment workflow can be thought of as:


1. provider.tf
       │
       ▼
2. variables.tf + terraform.tfvars
       │
       ▼
3. terraform-module/
       │
       ▼
4. vpc.tf
       │
       ├──────────────┐
       ▼              ▼
5. security-     6. nat-gateway.tf
   groups.tf
       │
       ├──────────────┐
       ▼              ▼
7. ec2-profile-   8. rds.tf
   role.tf
       │              │
       └──────┬───────┘
              ▼
9. secrets-manager.tf
              │
              ▼
10. backend.tf + alb.tf
              │
              ▼
11. acm.tf
              │
              ▼
12. route53.tf
              │
              ▼
13. db-migrate-server.tf
              │
              ▼
14. db-migrate-script.sh
              │
              ▼
15. sns.tf
              │
              ▼
16. outputs.tf

Note: This diagram represents a logical deployment flow. Terraform does not execute .tf files sequentially; it evaluates all configuration and determines the resource creation order from dependencies.
========================================================================================


Common Terraform commands

Initialize

terraform init

Format

terraform fmt -recursive

Validate

terraform validate

Review changes

terraform plan

or:


terraform plan -var-file="terraform.tfvars"

Deploy

terraform apply

or:


terraform apply -var-file="terraform.tfvars"

View outputs

terraform output

Destroy the infrastructure

terraform destroy


Warning: terraform destroy can permanently remove infrastructure and data. In particular, verify the RDS deletion/protection configuration before using it against a production environment.
===========================================================================================

Security considerations
Before committing or deploying this infrastructure:

Do not commit AWS access keys.
Do not commit database passwords or application secrets.
Review terraform.tfvars for sensitive values.
Protect Terraform state because it can contain sensitive infrastructure information.
Use AWS Secrets Manager for application/database secrets where appropriate.
Restrict security-group ingress rules to the minimum required sources.
Avoid exposing RDS directly to the public internet.
Use HTTPS through ACM for public application traffic.
Follow least-privilege IAM policies for EC2 roles.
Protect production Terraform state with appropriate remote-state locking and access controls.
Review the plan carefully before applying infrastructure changes.


Directory responsibility summary

Terraform Deployment
│

├── Configuration
│   ├── provider.tf
│   ├── variables.tf
│   └── terraform.tfvars
│

├── Networking
│   ├── vpc.tf
│   ├── nat-gateway.tf
│   └── route53.tf
│

├── Security
│   ├── security-groups.tf
│   ├── ec2-profile-role.tf
│   ├── secrets-manager.tf
│   ├── acm.tf
│   └── eice.tf
│

├── Application
│   ├── backend.tf
│   └── alb.tf
│

├── Database
│   ├── rds.tf
│   ├── db-migrate-server.tf
│   └── db-migrate-script.sh
│

├── Messaging
│   └── sns.tf
│

├── Reusable Infrastructure
│   └── terraform-module/
│

├── Deployment Results
│   └── outputs.tf
│

└── Source Control
    └── .gitignore

Final note

This README documents the expected deployment responsibility based on the filenames visible in the project. For an exact technical description—including every AWS resource, dependency, variable, IAM permission, port, subnet, and migration command—the contents of the Terraform and shell files should be reviewed as well.


