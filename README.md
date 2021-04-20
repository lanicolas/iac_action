# Creating Azure Marketplace Virtual Machine Images [DRAFT]

This is a demo of how to create a virtual machine image to publish it in the Azure Marketplace, or in your [Image Gallery][image-gallery]. It demonstrates how to automate the creation of your image as a GitHub Workflow using GitHub Actions, and uses the [Azure Image Builder][image-builder] service to make the image creation easier.

## Preparation steps

Before running the [Workflow][workflow] we need to do some preparation:

* Create a [service principal][service-principal] for our workflow
* Prepare the Azure Subscription for Image Builder, it requires a [managed identity with specific permissions][image-builder-permissions] to create the VM images.

I have created these two scripts that you need to run inside an cli with the az tool installed. The easiest way of running it is through the cloud shell, just clone this repo and run the two scripts found in the [scripts][scripts] folder.

* The script [01-run-in-az-cli-github-credentials.sh][script-01] will run the first requirement and provide you with a secret that you will use in GitHub
* The second one, [02-run-in-az-prepare-environment.sh][script-02], it will generate the resource group, identity and assign the needed roles to the identity, and will provide you with the name of the created identity.

It is recommended to create an [environment][github-environments] in GitHub for storing these secrets.

//TODO: step by step and screenshots

## Run the Workflow

The provided [workflow][workflow] will create a very simple machine that serves a web page from an Nginx containerized image. The installation script that will be run by the Image Builder service can be found in [this same repo in the vmcode folder][vm-script]. And executes something like this:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose 
docker-compose up -d
```
...








[github-environments]: https://docs.github.com/actions/reference/environments
[image-builder]: https://docs.microsoft.com/en-us/azure/virtual-machines/image-builder-overview "Image Builder"
[image-builder-permissions]: https://docs.microsoft.com/azure/virtual-machines/linux/image-builder-permissions-cli
[image-gallery]: https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries "Shared Image Galleries"
[service-principal]: https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md "Azure secrets for workflows"
[scripts]: scripts "Provided scripts"
[script-01]: scripts/01-run-in-az-cli-github-credentials.sh
[script-02]: scripts/02-run-in-az-prepare-environment.sh
[vm-script]: vmcode/install.sh
[workflow]: .github/workflows/image-builder.yml "GitHub Workflow definition"
