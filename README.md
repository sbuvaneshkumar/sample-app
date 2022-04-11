w## Setup
This repo helps to build a Docker image for a simple webapp based on Python Flask framework and deploys to ECS Fargate.

The application has two endponts - `/` and `/version`.
The root path serves the content for the app, `/version` prints the version of the application.

## Notes
* The codebase for HTTPS redirection and Route53 are available in [lb.tf](https://github.com/sbuvaneshkumar/sample-app/blob/main/infrastructure/modules/network/lb.tf#L46) and [acm.tf](https://github.com/sbuvaneshkumar/sample-app/blob/main/infrastructure/modules/network/acm.tf) 
* The HTTPS redirection and Route53 are commented out as of now, but can be enabled when testing (TODO: this codebase is yet to be tested).

## Local Development
Use the following instructions to test and deploy the app locally. Additionally, to change the version of the app, or the content, modify the [app.py](https://github.com/sbuvaneshkumar/sample-app/blob/main/application/app.py) file 
1. Build the Docker image
```bash
$ cd sample-app/application/
$ docker build -t sample-app:v1 .
```
2. Run the app container and test it 
```
$ docker run -d --name sample-app -p 8080:8080 sample-app:v1

$ curl localhost:8080
<p>This is a simple web app!<p>
                                                                                                                                                அ  application [main] curl localhost:8080        
$ curl localhost:8080/version
<p>Version: 1.0.0-alpha</p>
```
## Deployment to ECS Fargate
Use the following instructions to deploy the application to ECS Fargate
#### Prerequisite
* Ensure you've the AWS credentials configured in your laptop
* Terraform > 0.12
* Ensure you've created S3 bucket specified in [backend.tfvars](https://github.com/sbuvaneshkumar/sample-app/blob/main/infrastructure/environments/dev/backend.tfvars#L1) - `aws s3 mb s://<bucket-name>`
```bash
$ cd sample-app/infrastructure/
$ terraform init -backend-config=environments/dev/backend.tfvars
$ terraform plan -var=environment=dev -var=app_image_tag=v1 
$ terraform apply -var=environment=dev -var=app_image_tag=v1
```
Once the execution is completed, it will print out the DNS URL for ALB.
It will not be accessible yet as the app image is yet to be available in ECR.

Use the following instructions to build the app Docker image, tag and push to ECR registy.
```bash
$ cd sample-app/application/
$ docker build -t sample-app:v1 $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/sample-app:v1
$ docker push $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/sample-app:v1
```
Wait for a few secs, then try hitting the LB URL printed in above terraform output.
```bash
# E.g.
$ curl sample-app-alb-733725906.us-east-1.elb.amazonaws.com
<p>This is a simple web app!<p>

$ curl sample-app-alb-733725906.us-east-1.elb.amazonaws.com/version
<p>Version: 1.0.0-alpha</p>
```

## Redeployment for further versioning
1. Change the version [in app codebase](https://github.com/sbuvaneshkumar/sample-app/blob/main/application/app.py#L11), if required change the content as well
2. Create a new version of the docker image and push to ECR
```bash
$ cd sample-app/application/
$ docker build -t sample-app:v2 $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/sample-app:v2
$ docker push $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/sample-app:v2
```
3. Rerun the terraform with the specified Docker image version in `app_image_tag` variable
```
$ cd sample-app/infrastructure/
$ terraform plan -var=environment=dev -var=app_image_tag=v2
$ terraform apply -var=environment=dev -var=app_image_tag=v2
```
4. Once the execution is completed, review the version by hitting `/version` endpoint in ALB URL. It should be printing the new version now.
## Things to keep in mind when deploying in production 
1. The image build and push steps should be part of the CI/CD process, using tools such as Jenkins or GitHub Actions.
2. The variables for the environment (dev/stage/prod) and the version of the image can be passed as parameters for the CI/CD tools
3. Security-hardening:
    * Use tools such as [checkov](https://github.com/bridgecrewio/checkov) for security scanning to find common vulnerabilities and misconfiguration in Terraform codebase
    * Use scanning option available in ECR to detect vulnerabilities in image or use tools such as [clair](https://quay.github.io/clair/) if the desired environment is {multi,hybrid}-cloud.
    * The default user for the container should be a non-root user
4. As we scale with the number of applications, it would be nicer to have them moved to EKS as there will be much more features that can be achieved via container orchestration tools (E.g. Kubernetes) than in ECS