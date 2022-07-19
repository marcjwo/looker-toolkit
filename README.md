# Looker Toolkit as Code 18th of July, Test
## Introduction
Looker Toolkit as Code is a set of tools that can be used to create and spin up a preconfigured VM images that contains open source third party tools to complement your exisiting Looker infrastructure and save users the hassle of installing and configuring these tools individually. The way to achieve this is via this repo is two-fold and you can decide eventually if you want to deploy the image manually or via terraform. I will explain both variants.

## Tools contained in the toolkit
1. [Henry](https://github.com/looker-open-source/henry)
2. [Gazer](https://github.com/looker-open-source/gzr)
3. [Looker deployer](https://github.com/looker-open-source/looker_deployer)

## Support
This is not an official Google product and support will happen on a best-effort basis.

## Requirements
1. Packer >= 1.7.2
2. Terraform >= 1.2.4
3. Ansible >= 2.13.1

# How-to
### 1. Install required software
Make sure you already have installed or install the required software stack in your development enviroment.  See below for links to installation instructions for each tool.
1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
3. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) (Note that Ansible requires Python)

### 2. Set up GCP Project
If you don't already have a project you would like to use for this, please follow the [documentation](https://cloud.google.com/resource-manager/docs/creating-managing-projects#console) to create a new GCP project and ensure it has a billing account attached to it.

### 3. Activate the required API
If not activated already or if you are using a new project, make sure to enable the required APIs. You do so by either going to the section in the GCP console, or getting to the gcloud CLI and type `$ gcloud services enable compute.googleapis.com `

- Compute Engine API

### 4. Create service account
While it would be possible to use your application default credentials to authorize to your GCP project it is considered a best practice to create a dedicated [service account](https://cloud.google.com/iam/docs/service-accounts) for the job.

The service account needs the following permissions:
- Compute Admin (v1)
- Service Account User
- Compute Image User

### 5. Clone the git repository
Assuming that you have git installed and working in your development enviroment, clone the git repository to the folder of your choice.<br>
`git clone https://github.com/marcjwo/looker-toolkit.git`

## Packer
We use the tool Packer together with ansible to create a custom vm image that has the tools preinstalled. Packer creates the image and ansible contains a playbook that holds the required steps in order to install the software packages. We need to adjust a few things to ensure Packers works as expected.
### Define Packer variables
Being in the looker-toolkit folder, navigate to the packer subfolder `cd packer`. Create a vars.auto.pkrvars.hcl file in the packer folder.
> Note: the `auto` in the filename will tell Packer to automatically apply this variables file when we deploy. If you'd rather manually specify the variables file then remove `auto` from the filename.
Edit the `pkrvars` file to set the definitions for the required variables; it should look like this:<br>

```
project_id = "YOUR_GCP_PROJECT"
tooling_playbook = "./ansible/playbook.yaml"
zone = "YOUR_GCP_ZONE"
sa_email = "Your Service Account"
```
<br>
Definitions are as follows:

| Name                    | Description                                                                                                                                                                                         |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| project_id              | Your GCP Project ID                                                                                                                                                                                 |
| tooling_playbook        | The ansible playbook to use for provisioning.                                                                                                                                                       |
| zone                    | The GCP zone to use                                                                                                                                                                                 |
| sa_email                | The email address of your service account                                                                                                                                                           |

<br>

### Initialize & execute Packer
- Initialize packer with the command `packer init .` (Do not forget to type out the dot behind the init)
- Start the build with the command `packer build .` - this step will take ~ 4 minutes to complete and you will see the output in the terminal in a green font (Note: You will see the instance creation as well as the tasks/steps of the ansible playbook packer goes through)
- **Congrats, you have created a vm image that has the tools preinstalled**

## Create VM
Now that we have the image in place, we can spin up a VM using it

### Using the console
The "easy" way would be to just use the GCP console.
- Navigate to Compute Engine section
- `Create instance`
- Set the settings as per your preferences
- Under the boot disk section click on `change`, switch to Custom Images, and select the packer image just created
- Create instance
- SSH into the instance and use the preinstalled tools

### Using Terraform
As we might want to stick to "Toolkit as Code" and in order to streamline deployments, we can use Terraform to spin up an instance using the image that was previously created. For that, you additionally have to give the created service account the permission of `Compute Image User`.

#### Define Terraform variables
- Being in the looker-toolkit folder, navigate to the terraform subfolder `cd terraform`
- Create a file called `terraform.tfvars`
- Edit the previously created file `terraform.tfvars`
```
instance_name = "looker-ps-toolkit-gcmarc"
project_id = "YOUR_GCP_PROJECT"
zone = "YOUR_GCP_ZONE"
region = "YOUR_GCP_REGION"
machine_type = "f1-micro" ### this is the smallest type; adjust if necessary
sa_email ="Your Service Account"
```
<br>
Definitions are as follows:

| Name                    | Description                                                                                                                                                                                         |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| instance_name           | Your desired instance name                                                                                                                                                                          |
| project_id              | Your GCP Project ID                                                                                                                                                                                 |
| zone                    | The GCP zone to use                                                                                                                                                                                 |
| region                  | The GCP region to use                                                                                                                                                                               |
| machine_type            | The machine type of the vm instance                                                                                                                                                                 |
| sa_email                | The email address of your service account                                                                                                                                                           |

### Initialize and execute Terraform
- To start the process, we need to initialize terraform: `terraform init`
- The next step is to execute `terraform plan`; this checks if the terraform plan is executable and would throw an error if not.
- If the previous step is successful, we can execute `terraform apply -auto-approve`, followed  in order to create the vm instance; this should take less than 30 seconds.
- **Congrats, you have created a vm image that has the tools preinstalled**



