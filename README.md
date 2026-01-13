# Cost-Optimized-Multi-Tier-Web-Application-on-AWS-Terraform-
This project demonstrates the design and implementation of a cost-optimized, multi-tier web application on AWS, provisioned using Terraform.
The goal of this project is not to build a fully production-hardened system, but to demonstrate clear infrastructure design decisions, strong use of Infrastructure as Code, secure access patterns, and an understanding of AWS trade-offs under real-world constraints such as cost, scope, and maintainability.
The architecture focuses on foundational DevOps concepts rather than maximum feature breadth.
Note: The overall design (including CDN and TLS termination) is actively used in my personal website.
This repository intentionally implements a scoped subset of that design to keep the infrastructure reproducible and focused.
________________________________________
High-Level Architecture
Tiers
Content Delivery (Design-Level)
•	CloudFront used as a CDN
•	ACM for certificate management
•	Route 53 for domain registration and DNS management
This layer is part of the architectural design but intentionally not implemented in Terraform for this repository (see below).
Web Tier
•	EC2 instance running Nginx
•	Hosts a static HTML frontend
•	Acts as a reverse proxy to the backend API
•	No SSH access (managed via AWS Systems Manager)
Application Tier
•	API Gateway exposing an HTTP endpoint
•	AWS Lambda function implementing business logic
•	Backend API is not directly exposed to the client
Data Tier
•	Amazon DynamoDB table storing a simple counter
•	S3 bucket used for static assets
________________________________________
Traffic Flow
1.	Client requests the web page from Nginx
2.	Frontend JavaScript makes a relative request (/function_call)
3.	Nginx proxies the request to API Gateway
4.	API Gateway invokes Lambda
5.	Lambda updates DynamoDB and returns a response
This pattern abstracts backend implementation details from the client and mirrors common production reverse-proxy designs.
________________________________________
Infrastructure as Code
All infrastructure implemented in this repository is provisioned using Terraform and organized into logical modules.
Key characteristics:
•	Explicit VPC and subnet definitions
•	Security groups scoped to minimum required access
•	Clear separation between networking and compute resources
•	Outputs used to wire dependencies between modules
Terraform is used not only to create resources, but to document architectural intent through structure and naming.
________________________________________
Security Design
Security decisions are intentionally simple and explicit:
•	No SSH access
o	EC2 managed exclusively via AWS Systems Manager (SSM)
•	Private service access
o	S3 access via VPC endpoint where applicable
•	Least-privilege IAM roles
o	Lambda, EC2, and API Gateway have scoped permissions
•	Backend abstraction
o	API Gateway endpoint is not directly exposed to the browser and supports throttling
This mirrors common enterprise patterns while remaining easy to reason about.
________________________________________
CDN / CloudFront Considerations (Intentionally Not Implemented)
A CloudFront + ACM + Route53 setup was deliberately designed but not implemented in Terraform for this repository.
While CloudFront would typically be used in production to:
•	Provide TLS termination
•	Improve global latency
•	Protect the origin
•	Enable advanced security controls
…it was intentionally deferred in this project.
Rationale
CloudFront, ACM, and DNS introduce operational concerns that are orthogonal to the primary learning goals of this repository, including:
•	DNS delegation and certificate lifecycle management
•	Cross-region ACM constraints (us-east-1 for CloudFront)
•	Longer provisioning times and more complex debugging
•	Increased cognitive overhead for a non-core concern
To keep the project:
•	reproducible
•	easy to evaluate
•	focused on Terraform, networking, and backend integration
…the CDN layer was left at the design level.
This reflects real-world practice where foundational infrastructure is built first, and global delivery is added incrementally.
________________________________________
Cost and Scope Trade-Offs
To remain within AWS Free Tier constraints and focus on core DevOps skills, the following were intentionally excluded:
•	Load balancer and autoscaling groups
•	Multi-AZ redundancy
•	CloudFront and ACM automation
•	CI/CD pipeline for this specific project
These features are either well understood or demonstrated in separate portfolio projects.
________________________________________
Known Limitations
This project is intentionally not production-grade:
•	Single EC2 instance (no high availability)
•	Manual deployment of web assets
•	No automated scaling
These limitations are documented by design and discussed openly.
________________________________________
How to Deploy
terraform init
terraform apply
After deployment, Terraform outputs provide the public endpoint to access the application.
To remove all resources:
terraform destroy
________________________________________
What This Project Demonstrates
•	Practical Terraform usage
•	Secure EC2 access patterns (SSM over SSH)
•	Reverse proxy design with Nginx
•	Serverless backend integration
•	Cost-aware architectural decision-making
•	Clear documentation and trade-off analysis
________________________________________
Related Projects
This repository is part of a broader portfolio:
•	Project 2: Kubernetes (EKS) deployment with Docker and CI/CD (GitHub Actions)
•	Project 3: Monitoring and observability using Prometheus and Grafana
Each project focuses on a distinct DevOps responsibility to avoid overlap.
________________________________________
Final Note
This project reflects real engineering trade-offs, not maximal service usage.
Design decisions were made deliberately to balance learning value, clarity, and maintainability.
________________________________________

