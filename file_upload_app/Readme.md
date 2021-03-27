# Demo file upload #

Final step! If the func is set up correctly it should trigger upon a file upload to the data lake. </br>
All you need to supply is the access key ("storageAccKey") to the datalake in the .env-file and docker-compose up. Shortly you'll find a file in the blob and the AZ-func should fire! </br>

Needless to say: the .env-file is includere here with the variable name and my previous key (I've already long destroyed the infrastructure), but it would never be committed to the repo in a real life scenario.