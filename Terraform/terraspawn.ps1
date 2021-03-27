

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


##############################################################################
### Load environment variables from project directory .env-file (if exist) ###
##############################################################################

$PathVar = $args[0] + "/.env"

if (!(Test-Path $PathVar)) 
{
    echo "No .env file"
}
else
{
    $content = Get-Content $PathVar -ErrorAction Stop
    echo "Parsed .env file"
    foreach ($line in $content) 
    {
        ### Checking for empty line
        if([string]::IsNullOrWhiteSpace($line))
        {
            echo "Skipping empty line"
            continue
        }
        ### ignore comments ###
        if($line.StartsWith("#"))
        {
            echo "Skipping comment: $line"
            continue
        }

        ### Get the Key Value Pair ###
        $kvp = $line -split "=",2            
        $key = $kvp[0].Trim()
        $value = $kvp[1].Trim()

        echo "Key: $key value: $value"


        ### Set the environment variables ###
        [Environment]::SetEnvironmentVariable($key, $value, "Process") | Out-Null
    }
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

##########################################################################
### The Apply command is used to create and execute the execution plan ###
##########################################################################
terraform apply -auto-approve $args[0]




######################################################################
### Remove previously loaded environment variables if any were set ###
######################################################################
if (Test-Path $PathVar)
{
    $content = Get-Content $PathVar -ErrorAction Stop
    foreach ($line in $content) 
    {
        ### Checking for empty line
        if([string]::IsNullOrWhiteSpace($line))
        {
            echo "Skipping empty line"
            continue
        }
        ### ignore comments ###
        if($line.StartsWith("#"))
        {
            echo "Skipping comment: $line"
            continue
        }

        ### Get the Key Value Pair ###
        $kvp = $line -split "=",2            
        $key = $kvp[0].Trim()
        $value = $kvp[1].Trim()

        echo "Removing environment variable $key"

        ### Set the environment variables ###
        remove-item Env:\$key | Out-Null
    }
}

######################
### And we finish! ###
######################
echo Done!