#### STEPS
# Before creating git repo add some files to the .gitignore files. Check .gitignore files to see which files. 

1) Git init, craete .gitignore file
2) Create RG, run terraform init. 
3) Create SA store your state in remote location

### Information

main.tf                                 >>>  Main configuration files
vars.tf                                 >>>  Variable declaring here
terraform.tfvars or *.auto.tfvars       >>>  Terraform can populate variables using values from a file. Terraform automatically loads them from these files to populate variables




### Functions 

lookup          >>> This introduces a built-in function call. The lookup function does a dynamic lookup in a map for a key


### Useful commands


Terraform must authenticate to Azure to create infrastructure.
In your terminal, use the Azure CLI tool to setup your account permissions locally.

$ az login

Your browser window will open and you will be prompted to enter your Azure login credentials. After successful authentication, your terminal will display your subscription information. You do not need to save this output as it is saved in your system for Terraform to use



To review the information in your state file, use the state command. If you have a long state file, you can see a list of the resources you created with Terraform by using the list subcommand.
$ terraform state list

