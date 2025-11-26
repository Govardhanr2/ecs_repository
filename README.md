# ECS WordPress and Microservice Deployment

This project deploys a WordPress website and a Node.js microservice to Amazon ECS using Terraform. The entire infrastructure is defined as code, making it easy to create, update, and manage. The deployment process is automated using GitHub Actions for CI/CD.

## Architecture

The infrastructure consists of the following components:

*   **VPC:** A custom VPC with public and private subnets for network isolation.
*   **Application Load Balancer (ALB):** An ALB to route traffic to the WordPress and microservice containers.
*   **ECS (Elastic Container Service):** An ECS cluster to manage the WordPress and microservice containers. The containers are run as Fargate tasks.
*   **ECR (Elastic Container Registry):** An ECR repository to store the Docker image for the microservice.
*   **RDS (Relational Database Service):** An RDS MySQL instance for the WordPress database.
*   **Route 53:** Route 53 is used to manage the domain and create DNS records for the services.
*   **IAM (Identity and Access Management):** IAM roles and policies are used to grant permissions to the different services and for the CI/CD workflow.
*   **GitHub Actions:** A GitHub Actions workflow is used to automatically build and push the microservice Docker image to ECR and deploy it to ECS.

## Prerequisites

Before you begin, ensure you have the following:

*   An AWS account with the necessary permissions.
*   The AWS CLI installed and configured with your credentials.
*   Terraform installed on your local machine.
*   Docker installed on your local machine.
*   A registered domain in Route 53.
*   A GitHub repository for your project.

## Configuration

1.  Create a file named `terraform.tfvars` in the root of the project.
2.  Add the following to the file, replacing the values with your own:

    ```terraform
    aws_region       = "your-aws-region"
    domain_name      = "your-domain.com"
    db_username      = "your-db-username"
    db_password      = "your-db-password"
    github_org       = "your-github-org"
    github_repo      = "your-github-repo-url" # e.g ""https://github.com/xxxx/xxxx.git""
    aws_account_id   = "your-aws-account-id"
    ```

3.  In your GitHub repository, go to **Settings > Secrets and variables > Actions** and add the following secrets:

    *   `AWS_GIT_ARN`: Your AWS Github Actions Role ARN.
    *   `AWS_REGION`: The AWS region you are deploying to.

## Deployment

1.  Navigate to the root of the project in your terminal.
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Plan the deployment:
    ```bash
    terraform plan
    ```
4.  Apply the plan to create the AWS resources:
    ```bash
    terraform apply
    ```

## CI/CD

This project includes a GitHub Actions workflow that automates the build and deployment of the microservice. When you push changes to the `main` branch of your repository, the workflow will:

1.  Build the Docker image for the microservice.
2.  Push the image to the ECR repository.
3.  Force a new deployment of the ECS service to pull the new image.

## Accessing the Services

Once the deployment is complete, you can access your services at the following URLs:

*   **WordPress:** `https://wordpress.your-domain.com`
*   **Microservice:** `https://microservice.your-domain.com`

## WordPress Setup

1.  Open the WordPress URL in your web browser.
2.  You should be taken directly to the "Site Information" screen. If you are asked for database details, use the values from your `terraform.tfvars` file and the database host from the Terraform output (`terraform output -raw db_instance_address`).
3.  Fill in the site title, admin username, password, and email address.
4.  Click "Install WordPress".

## Managing the Infrastructure

You can manage your infrastructure using the following Terraform commands:

*   `terraform plan`: See a plan of changes before applying them.
*   `terraform apply`: Apply changes to your infrastructure.
*   `terraform destroy`: Tear down all the resources created by this Terraform configuration. **Use this command with caution.**

 ## Access Your Services:

Your Terraform deployment has created two services. You can access them at the following URLs:

   * WordPress: https://wordpress.domainname.com
   * Microservice: https://microservice.domainname.com

Please open these URLs in your web browser to verify that the services are running correctly. The WordPress site may take a few minutes to become available.

  ## Future Updates (CI/CD):

As we've set up the GitHub Actions workflow, any future changes you push to the main branch of your GitHub repository will automatically trigger a new Docker image build and push it to ECR. This will then be deployed to your ECS service.

  To update your microservice:
   1. Make changes to the microservice/app.js file.
   2. Commit and push the changes to the main branch of your GitHub repository.
   3. The GitHub Actions workflow will automatically build and deploy the new version.


## Benefits of this Approach:

* Enhanced Security: Your database credentials are not hardcoded in your Terraform files, task definitions, or Docker images. They are stored centrally and securely in Secrets Manager.
* Improved Management: You can easily rotate the database credentials in Secrets Manager without needing to update your ECS task definition or redeploy your service.
* Compliance: Using a dedicated secrets management service like Secrets Manager helps you meet compliance requirements for handling sensitive data.
  
## Summary, 

* Installation Requires Database Access: The WordPress installation process involves creating a wp-config.php file with the database credentials and then creating a number of tables in the database (for
posts, users, settings, etc.). If WordPress could not connect to the RDS database, you would have seen a "Error establishing a database connection" message and would not have been able to proceed with
the installation.
* Secrets Manager acts as a secure vault for your database credentials, and your ECS service is granted permission to retrieve them on-demand when the WordPress container starts.

## Troubleshooting

*   **"No OpenIDConnect provider found..." error in GitHub Actions:** This means the IAM OIDC provider was not created. Ensure the `aws_iam_openid_connect_provider` resource is in your `modules/security/iam_cicd.tf` file and run `terraform apply` again.
*   **"Not authorized to perform sts:AssumeRoleWithWebIdentity" error in GitHub Actions:** This is a permissions issue with the IAM role's trust policy. Ensure the `github_org` and `github_repo` values in your `terraform.tfvars` file are correct and that the trust policy in `modules/security/iam_cicd.tf` is correctly configured.
*   **Microservice not updating after push:** Ensure the GitHub Actions workflow is completing successfully and that the `aws ecs update-service --force-new-deployment` command is being run.
*   **WordPress database connection error:** Verify that the RDS instance is running and that the security groups are correctly configured to allow traffic from the ECS service.
