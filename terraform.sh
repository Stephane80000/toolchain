#!/bin/bash
# votre script ici

echo ">>> Downloading Terraform CLI…"
wget -q https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
echo ">>> Installing Terraform CLI…"
mkdir $HOME/terraform
unzip ./terraform_0.11.14_linux_amd64.zip -d $HOME/terraform
rm -rd ./terraform_0.11.14_linux_amd64.zip
export PATH=$PATH:$HOME/terraform
echo ">>> Checking installed version of Terraform CLI…"
terraform version

echo ">>> Downloading Terraform provider IBM…"
wget -q https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v0.17.3/linux_amd64.zip
echo ">>> Installing Terraform provider IBM…"
mkdir -p $HOME/.terraform.d/plugins
unzip ./linux_amd64.zip
rm -rd ./linux_amd64.zip
mv ./terraform-provider-ibm* $HOME/.terraform.d/plugins/
echo ">>> Terraform init…"
terraform init
echo ">>> Terraform plan…"
terraform init
echo ">>> Terraform apply…"
terraform apply -auto-approve
echo ">>> Successfully Deployed Terraform infrastructure"
