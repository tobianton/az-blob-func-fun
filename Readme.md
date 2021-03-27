# Blob Trigger #

So since we had a nice chat about a lot of different stuff I though it could be nice to back it up with some code. </br>
Though you did not ask for it I figure if we are to date permanently atleast I'd like to test drive the car prior to purchasing it (metaforically speaking). </br>
Below you'll find the steps you need to complete to build a datalake and a func-app (Terraform), listen to the blob/ADL for new files (Az-func with blob-trigger) and a program to upload a beautiful poem that I wrote (written in python, dockerized and executed through docker-compose). You wanted to send an email -> I'm not doing the full SMTP-solution but I supplied a mock SendEmail-function and secrets are injected etc.</br>
Obviously one of many ways to do this -> I'll be doing some reading into event grid for sure :) </br>

## Secrets ##
So normally I'd never include neither .env files nor local.settings.json (C#)-files to a repo. </br>
None of these secrets are secret though, so I'm including the files so you know which secrets go where in case you want to do a local debug. </br>




## Steps ##
How to run this mother: </br>

1) CD into Terraform and do a "./terraplan ./" (feeding "./" as an argument for the path to the .env dir). That should validate and be followed up with a "./terraspawn ./" (apply). </br>
voilà -> your environment should be in place. PS: You might have to run it twice as you can get at 403 when you try to create the secrets (Access Policies might take a few min to register).</br>
</br>
</br>
2) CD into the FunkyBlob dir and upload the AZ-func to the newly created az-func (demo-funky-app) through Visual Studi. In a production environment I'd build and release the app through DevOps, but for this simple proof of concept I'm allowing myself some leniency and just uploading it through vs-code AZ-func extension. In advance: Sorry (but I can provide you some build yamls should you crave any!) :)</br>
To publish you right click the project and select Publish (target=Azure & Az func app (windows)). Find the func-app we just Terraformed (demo-funky-app) in your subscription and upload the func!
The secrets needed to run this mother should already be injected into the runtime environment through the func appsetting-block with @Microsoft.KeyVault references. RBAC gives the func-app access to the KV.</br>
</br>
</br>
3) Monitor the Func app from the AZ-portal -> as I'm not actually sending an email all you'll see is a logging entry of from the SendEmail-func.</br>
</br>
</br>
4) Run the file_upload_app with "docker-compose up" from the ./file_upload_app directory. This uploads my beautiful poem to the blob (which should trigger the AZ-func and "send" a synthetic email).
Prior to running the app you need to update the storageAccKey .env-variable in the ./file_upload_app/.env-file. From the keyfault.tf you have access to the vault, so I could have made a get_secret func and piggybacked off your credentials, but since it's docker-compose I prefered to do a .env-injection because why not?</br>
</br>
</br>
5) Hopefully all of the above worked out just fine. If that is the case then from the .Terraform dir a ./terranuke ./ remains and we can enjoy the rest of our weekend!

![Alt text](img/success.JPG?raw=true)
</br>
</br>
</br>
Speak soon!</br>
</br>
-T