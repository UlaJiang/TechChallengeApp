## Summary
This app has been deployed to AWS.
Tools:
Dockerfile: to create application image to be used for cloud deployment.
docker-compose.yaml file: to manage multiple container images and its configurations.
Terraform: IaC to provision and manage cloud and services.

## Architecture of Solutions
I have 2 solutions with a bit different architectures:
**Solotuin 1. Single-EC2 solution**
(please refer to folder: "terraform_single_ec2"): 
  1) Deploy one EC2 in a public subnet inside an custom VPC.
  3) Modify the default Dockerfile.
  2) Use docker-compose to manage multiple docker images (application + postgres).

**Solotuin 2. Two-tier architecture High Availability solution**
(please refer to folder: "terraform_high_availability"):
  1) Create a custom VPC with 2 public-subets and 2 private-subnets, also include Internet Gateway, proper route table for each subnet, etc.
  2) Deploy 2 EC2 with application doccker container running inside, one in each public-subnet. 
  3) Deploy high availability postgres RDS, one primary in one of the private-subnet, and one replica in another private-subnet. 
  4) Deploy an Application Load Balance in front of those EC2.
![plot](./screenshot/architecture.png?raw=true)

## Following files have been changed
**1. conf.toml**
Updated DbHost = "mypostgres" and ListenHost = "0.0.0.0"

**2. Dockerfile**
1) Installed missing golang dependencies to make the container can run shell commands/scripts
  "RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"
2) Create a shell scripts to update the DB and run the application
3) Updated ENTRYPOINT to run the shell script.

**3. Create two Terraform folders**
preparation: build an golden image in region "ap-southeast-2" with docker and docker-compose installed.
1) folder "terraform_single_ec2": for single EC2 solution
2) folder "terraform_high_availability": for two tiers high availability solution

## Execute Code and Results
To run the code, several things need to be setup:
* Make sure terraform is properly installed on local PC
* Have an aws credentials (access-key and secret-key), you will be asked to input your key when run the code. Recommended to store your aws credentials in default path: "~/.aws/credentials"kv
* Have ssh key-pair generated in your local PC. If you don't have, please input "ssh-keygen" in your terminal. Recommended to store your key-pairs in default path: "~/.ssh"

####Solotuin 1. Single-EC2 solution
***1. steps of run terraform code***
Please go to the folder"terraform_single_ec2", and run the following command in order:
```shell script
terraform init
terraform plan
terraform apply
```
You will get your public-ip of the EC2, please input that IP into your browser (http://your-public-ip:80)

***2. screenshot***
EC2 Public IP and NDS output after Terraform code
![plot](./screenshot/terraform-output.png?raw=true)

Visit Application UI with IP
![plot](./screenshot/ip-webpage.png?raw=true)

Health Check with IP
![plot](./screenshot/ip-healthcheck.png?raw=true)

Visit Application UI with IP
![plot](./screenshot/dns-webpage.png?raw=true)

Health Check with IP
![plot](./screenshot/dns-healthcheck.png?raw=true)

####Solotuin 2. Two-tier architecture High Availability solution**
***1. current status and some issue to be improved***
For two-tier high availability solution, I am able to deploy two EC2 instances in two different public-subnets behind an Application Load balancer. I can get the webpage showing based on the ALB DNS.

But my EC2 instances cannot communicate with postgres. Currently, the application docker container in ec2 can login to posgres, but when it tried to update the database, it got "Permission Denied" error, I searched online, and got the hints that it's about the Postgres version (should use version 9.6). But I did use version 9.6.

So I deployed a single-ec2 solution instead (solution1).

***2. steps of run terraform code***
Please go to the folder"terraform_high_availability", and run the following command in order:
```shell script
terraform init
terraform plan
terraform apply
```
***3. screenshot***
Output of ALB DNS after running "terraform apply"
![plot](./screenshot/output-abl-dns.png?raw=true)

Use ALB DNS to visit the webpage
![plot](./screenshot/alb-dns-show-web.png?raw=true)

EC2 can login to Postgres and show Database
![plot](./screenshot/ec2-login-to-psql.png?raw=true)








