

##########################################################################
### If statement to ensure a user has provided a Terraform folder path ###
##########################################################################
if(!$args[0])
{
    echo ""
    echo "You have not provided a Terraform path."
    echo "SYNTAX = ./apply.sh <PATH>"
    echo "EXAMPLE = ./apply.sh terraform/instance"
    echo ""
}



if(az account show)
{
    echo ""
    echo "--------------------------------------------------------------------------------------------"
    echo ""
    echo "You have successfully authenticated with Microsoft Azure."
    echo ""
    echo "--------------------------------------------------------------------------------------------"
}
else
{
    echo ""
    echo "--------------------------------------------------------------------------------------------"
    echo ""
    echo "Authentication failure."
    echo "Please run the following command on your command line to authenticate with Microsoft Azure."
    echo ""
    echo "az login"
    echo ""
    echo "--------------------------------------------------------------------------------------------"
    echo ""
    exit

}


############################################################################################################
### The Init command is used to initialize a working directory containing Terraform configuration files. ###
### This is the first command that should be run after writing a new Terraform configuration             ###
############################################################################################################
terraform init $args[0]

############################################################################################
### The Get command is used to download and update modules mentioned in the root module. ###
############################################################################################
terraform get $args[0]

#########################################################################
### The Destroy command is used to tear down Terraform infrastructure ###
#########################################################################
terraform destroy $args[0] #-auto-approve # No auto approve on this one I'm thinking



######################
### And we finish! ###
######################
echo Done!