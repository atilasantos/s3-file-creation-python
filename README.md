# Stack to create files on S3 buckets within intervals of 5 min

## Overview 
This repository will cover the following:
- Provide a containerized app to upload files to a S3 bucket. (folder src)
- The app is packaged by a helm chart and has variables according to its environments, which are qa and staging. (folder charts/)
- The underlying infrastructure needed to support the app will also be deployed as IaC, via terraform (folder iac)

Obs: This README.md file was written focused to Linux users, may other OS systems will be covered in the future 😅

## Pre-requesites ✔️
- Have an account on [AWS](https://aws.amazon.com/pt/premiumsupport/knowledge-center/create-and-activate-aws-account/ "Creating an aws account").
- While creating your [IAM](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html "How to create IAM user account"), don't forget to download the .csv file with the generated key/secret pair, you'll need them in the further steps.
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli "How to install terraform")
- Create a [S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/create-bucket.html "Create a S3 Bucket") service on AWS which will be responsible to store the infrastructure state (fix the name if necessary in [backend.tf](https://github.com/atilasantos/iac-terraform-remessa-online-poc/blob/main/backend.tf))
- Have [helm](https://helm.sh/docs/intro/install/ "How to install helm") and [kubectl](https://kubernetes.io/docs/tasks/tools/ "How to install kubectl") installed.

## Getting started 🚀
1. Install the [aws cli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/install-cliv2.html "Installing aws cli"), try execute ***aws --version*** right after the instalation, something like the snippet below must be displayed:

    ``aws-cli/2.0.56 Python/3.7.3 Linux/5.4.0-51-generic exe/x86_64.ubuntu.18``
2. [Associate AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html "Configure aws credentials") to our local aws CLI so terraform would be able to identify what credentials to use while provisioning the infrastructure


## Terraform files
This repository is responsible for provisioning the aimed infrastructure, however it uses two modularized structures, one written by me which is inside the folder iac/modules and another one provided by [hashicorp](https://learn.hashicorp.com/tutorials/terraform/eks "How to create an EKS cluster") in this section i`ll go through the files I have created.
-  **backend.tf**: Define a remote versioned backend using S3 bucket service. The S3 bucket must be created before initializing terraform.
- **main.tf**: Define how to create the cluster, s3 buckets and s3 bucket lifecycles by providing the required variables from all the necessary modules.
- **output.tf**: Define which information will be displayed when the apply is successfully executed.
- **provider.tf**: Define the required modules to deploy/create the infrastructure.
- **security-groups.tf**: Define the security group to be attached to the EC2 instances and allow access through 22 port(ssh).
- **kubernetes**: Define the required namespaces to be created right after the cluster deployment
- **variables**: The variable values to fill the module call.

## Helm chart files
- **cronjob.yaml**: Define the resource which will be created when running helm install
- **env-values.yaml**: Define the values to be applied according to the environment of deployment, also has the requirement of running every five minutes.

## App files
- **Dockerfile**: The file used to build the docker image containing the code app.
- **requirements.txt**: The required packages to run the application
- **src/run.py**: The code itself which is responsible to create files inside a S3 bucket.

## Provisioning
Follow the steps bellow to provision the infrastructure without hadaches:
1. Inside the iac/ repository folder, execute:
```shell
terraform init
```
2. Once the modules, backend and plugins were initialized, execute:
```shell
terraform plan
```
3. Check if all the necessary resources are planned to be provisioned and then execute:
```shell
terraform apply -auto-approve
```
4. Once all the infrastructure is deployed, execute the following command, in the repository root dir, to configure the EKS cluster context inside your machine:
```shell
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```
Execute **kubectl get ns** to see if qa and staging namespaces were created:
```
NAME              STATUS   AGE
default           Active   3h9m
kube-node-lease   Active   3h9m
kube-public       Active   3h9m
kube-system       Active   3h9m
qa                Active   10s
staging           Active   10s
```
5. After validating it, you can go in two ways, use my builded docker image, which is already configured in qa-values.yaml and staging-values.yaml and available on docker.hub or you can build it in another public registry/repository:
```shell
docker build -t registry/repository/image:tag .
ex: docker build -t docker.io/atilarmao/s3-file-creation:0.0.1 .
```
6. Push the docker image as follow:
```shell
docker push registry/repository/image:tag
```
7. If you opted to go to your own image, update it on qa-values.yaml and staging-values.yaml in the fild **image**.
8. Last but not least, deploy the app using helm for both environments, qa and staging:
```shell
qa environment
helm install s3-creation charts/ -f charts/environments/qa-values.yaml -n qa --set cronjob.spec.env.ACCESS_KEY=<AWS_ACCESS_KEY_ID> --set cronjob.spec.env.SECRET_KEY=<AWS_SECRET_ACCESS_KEY>

staging environment
helm install s3-creation charts/ -f charts/environments/qa-values.yaml -n qa --set cronjob.spec.env.ACCESS_KEY=<AWS_ACCESS_KEY_ID> --set cronjob.spec.env.SECRET_KEY=<AWS_SECRET_ACCESS_KEY>
```
After that, something like the snippet below must be displayed:
```
NAME: s3-creation
LAST DEPLOYED: Mon May 16 00:46:17 2022
NAMESPACE: staging
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
Five minutes later, a POD execution must be created and a log like that must be displayed:
```
kubectl logs -n staging staging-s3-file-creation-1652673000-7pqvj

INFO:asyncio:file created with success: platform-challange-2022-05-16-03:50:07.txt
```
## Destroying the provisioned infrastructure
1. Uninstall the deployed app:
```shell
helm uninstall s3-creation -n qa
helm uninstall s3-creation -n staging
```
2. Clear all the buckets:
```shell
aws s3 rm s3://<BUCKET_NAME> --recursive
```
Once the buckets are empty, execute the following command inside iac folder:
```shell
terraform destroy -auto-approve
```

## Any questions?
Feel free to contact me via atila.romao@hotmail.com