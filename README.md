## FLASK API

# AWS Deployment System Diagram
<img src="Aws_deplyment_diag.jpg" width="700">

## Structure
* [Dockerfile](./Dockerfile) : multistage Dockerfile for build tool image which will be used in jenkins k8s for running jenkins stages.
* [flask api code](./api-code/) : configs for python flask api.
* [Terraform](./terraform/) : terraform modules and tf configs to deploy application on AWS without Downtime.
* [Packer](./packer) : Packer configuration for setting up pre-baked AMI for AWS.
* [Ansible Roles](./packer/roles) : Ansible roles and config files to setup mysql DB and python flask app in AMI.
* [Jenkinsfile](./Jenkinsfile) : Jenkinsfile for running Jenkins stages on k8s cluster.

## Architecture Flow Details

Once User push code to __Github__ repository, Jenkins server running on k8s will get trigger job in one of jenkins k8s jenkins agent pod with image provided in __Jenkinsfile__ and execute stages where Packer will use ansible provisioner to run ansible roles which will setup Mysql DB and python flask App and create pre-baked AMI for AWS.

Once Packer stage completed, terraform stage executes and using packer prebaked AMI , AWS configuration will be provisioned replacing exising ALB and autoscaling group. All stages will be executed inside __build tool__ container which will be provisioned using __multisatge Dockerfile__.

We are using __supervisor__ deamon to run flask API in aws server which will start once server boots up. Supervisor configuration has
been taken care by __Ansible role__ (ansible-role-app).
