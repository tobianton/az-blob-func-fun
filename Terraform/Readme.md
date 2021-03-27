# Terraform #

## Terra-plan, -spawn & -nuke ##
These 3 scrips plan, create and destroys resources declared in the PWD .tf-files. </br>
In addition they load all .env-secrets as environment variables, which terraform then substitutes into the variables.tf-file (given a "TF_VAR_" prefix). </br>
The reason for the "\_\_XXX__" variable naming is to do string substitution in CI/CD-pipelines if one would want to implement those for the tf-environment as well. </br>

I've included the .env-files in this project for as a demo so you see which secret-dependencies the project requires.

PS: hope you're running windows as they are powershell scripts