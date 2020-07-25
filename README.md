# My AWS ECS Cluster

This repo contains the infraestruture definitions (as Terraform code) for my ECS Cluster. The goal was to provision multiple apps into a single EC2 instance, and have it all managed by ECS. Additionally, I wanted to define a terraform module API my other projects can follow to be easily deployed to this cluster.

_NOTE: this documentation was written on July 2020. Commands and Versions might have changed since. For the purpose of this document I used:_

- _Docker 19.03.8_
- _AWS CLI 2.0.6_
- _Terraform v0.12.24_

This document assumes you're able to place env vars in your `~/.bash_profile`, or equivalent. I'm assuming you reload your profile after adding new env vars. For example, by running:

```
. ~/.bash_profile
```

## Cluster topology

I want my apps to be reletively simple and not have to worry about common REST endpoint concerns (e.g., encryption, gzip, caching). As such, I decide to offload those concerns to an NGINX reverse-proxy container that links to all my deployed apps, and is public facing.

Therefore, all HTTP requests are sent to NGINX and it decides how best to route them. Further, my app containers don't need to map to Host ports, and their APIs are private to the Docker bridge network where they all reside.

The obvious trade-off is that any new project I want to deploy to this cluster also requires updates to this repo's NGINX configuration. But given the relative rarity of such new deployments I think the benefits still outweigh the cons.

If you want to read more about how I confiured NGINX, please check [here](https://github.com/rjmarques/my-ecs-cluster/blob/master/nginx/).

## Minimal requirements to build and run

### Terraform

As stated above, I used Terraform to provision my full ECS infrastructure. If you want to try this out for yourself you must first decide what kind backend should Terraform use. [This page](https://www.terraform.io/docs/backends/index.html) goes into much more details about what backends are. The short version is that it's where Terraform will store your infrastructure state. The latter is used to know actions must be taken given your terraform definitions.

I had a free Heroku Postgres (that I was using for a different project) so I used that as the Terraform Backend. However, if you just want to play around you can use a local backend by removing the following from `main.tf`:

```
terraform {
  backend "pg" {
  }
}
```

Terraform modules often have variables the need user input to be initilized. A perhaps simpler way of achieving the same goal is to set them in `~/.bash_profile` as environment variables. All env variables you define starting with _TF_VAR_ are used to initilize Terraform variables if they match module variables, as defined in:

[./variables.tf](https://github.com/rjmarques/my-ecs-cluster/blob/master/variables.tf)

Later in the document I suggest doing just that for some configurable options.

### AWS

Although the AWS provisioning is almost fully automatic, you still need to specify enough information about where and how that provisioning will take place.

First thing we will need is a new IAM User that has enough permissions to create a whole ECS environment on the AWS account. For the sake of simplicity, I ran my user as admin. Albeit, in a real environment the permissions should be more locked down.

Once the IAM user is created set the access key id and secret access key into `~/.aws/credentials`, as you would to enable access to AWS via the aws cli.

We then need to find your AWS account id:

```
aws sts get-caller-identity
```

And add it to the `~/.bash_profile` as:

```
export TF_VAR_account_id=the-id-obtained-from-the-last-command
```

You must also add a keypair to AWS, or use a pre-existing one, that will allow you to SSH into the EC2 instance that belongs to the cluster. Add the name of the keypair to your `~/.bash_profile` as:

```
export TF_VAR_ecs_key_pair_name=my-aws-ssh-keypair
```

Optionally, you may wish to override the defaults I picked for `region` and `availability_zone`. If so, you can do it directly on [./variables.tf](https://github.com/rjmarques/my-ecs-cluster/blob/master/variables.tf) or add the following to `~/.bash_profile`:

```
export TF_VAR_region=my-preferred-region
export TF_VAR_availability-zone=my-preferred-az
```

## Terraform provisioning

### Modules

The current Terraform file structure has one [./main.tf](https://github.com/rjmarques/my-ecs-cluster/blob/master/main.tf) module at the root of this repository. Two other smaller modules: [./global/](https://github.com/rjmarques/my-ecs-cluster/blob/master/global/) and [./nginx/aws/](https://github.com/rjmarques/my-ecs-cluster/blob/master/nginx/) are part of the main setup. The first defines most of AWS resources needed to have a functioning ECS cluster, while the second specifies resources for the NGINX reverse proxy that sits in front of my other apps. More detail about the two local modules can be found in their respective directories.

All the modules besides `./global/` follow a specific API that outputs a set of expected values. Any module that follows this output API can then be used to provision an ECS container within the main (and only) ECS Task. Note, the main Task has 1 NGINX publicly accessible container and N local containers, from other repos.

The ouput API is:

- `ecr_repository_url` - The URL for the ECR repository where the container's images will be stored
- `container_definition` - The JSON container definition (as string) that describes the container
- `secrets_arns` - An array of ARNs for AWS secrets that need to be accessible by the containers

### Provisioning

✋ Halt! Before we continue...

The [./main.tf](https://github.com/rjmarques/my-ecs-cluster/blob/master/main.tf) module is loading some terraform modules, from my other apps, and passing some of their values to the `global` module, such as container definitions and secrets. These external app modules are being imported via git repo.

Moreover, [./output.tf](https://github.com/rjmarques/my-ecs-cluster/blob/master/output.tf) is exporting ECR repository URLs from those same modules. When using it on your own, you should change these files and remove any references to my external modules.

Make sure all your changes to the `~/.bash_profile` are available from the terminal you're trying to run terraform.

Ok, good to go! 👍

To intialize Terraform we first need to fetch its providers and set up the backend.

```
terraform init
```

If you're using the PG backend terraform will ask you for the PG connection URL. I also faced a strange issue where Terraform was complaining that it couldn't find a workspace. If you face the same issue, [this](https://github.com/hashicorp/terraform/issues/23121#issuecomment-651839845) solved it for me.

We're almost ready to provision our environment! But first let's check to see if there are no errors in the Terraform plan, before executing it:

```
terraform plan
```

This command will show us what changes will be made on the remote providers. It's useful as a safety check before trying to change something. To actually provision the environment run:

```
terraform apply
```

If everything went well, your new ECS cluster is now up and provisioned! 🎉

The command should also have outputted at least these values:

- _ecs_cluster_
- _nginx_ecr_repository_url_

## Docker

Ensure you have docker running:

```
docker version
```

If no errors are visible on both client and server/deamon, we can continue!

We need to link docker with the AWS ECR that was created by Terraform, and whose URL was outputed when we ran `terraform apply`. The _nginx_ecr_repository_url_ follows the following format:

`aws_account_id.dkr.ecr.region_name.amazonaws.com/repository_name`

The domain part of the URL identifies your account and region, on AWS's ECR service. While the repository name identifies which repository to where we'll push our docker images.

During deployment we'll need the full URL and also the URL without the repository name. As such we add the following lines to the `~/.bash_profile`:

```
export ECR=<the domain part of the ecr_repository_url> # without the /repo_name
export ECR_NGINX_REPO=$ECR/nginx
```

If you then run `echo $ECR_NGINX_REPO` the output should be equal to _nginx_ecr_repository_url_.

I also added the following values to `~/.bash_profile` to make deployment easier:

```
export AWS_REGION=your_aws_region
export ECS_CLUSTER=hobby-cluster      # name of the cluster that Terraform creates
export ECS_SERVICE=hobby-ecs-service  # name of the ECS service that Terraform creates
```

You may want to change these to something that makes sense to you. All of the above will be used in the next section when deploying.

## Deploying NGINX

TL;DR:

- To build and deploy run: `make`

If you inspect the _Makefile_ you can see the steps that each of the previous commands is running. I'll quickly go over each one.

### make

Builds the NGINX docker image and deploys it to ECR. The resulting docker image, available as _rjmarques/nginx_.

The first time `make` is run it can take a while to finish, as new images are pulled from the internet.

### make deploy

Once `make build` has been run, directly or otherwise, and _rjmarques/nginx_ is created, we can push the image to the ECR repository and consequently update the ECS service that's using it.

To push to ECR we first tag the image with the ECR URL, represented by _ECR_NGINX_REPO_. Afterwards we force update _ECS_SERVICE_ running on the _ECS_CLUSTER_. After ECS updates the service (which should take a few seconds), the new image should be in use and the NGINX updated.
