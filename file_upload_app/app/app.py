import os
from azure.storage.filedatalake import DataLakeServiceClient


if __name__ == "__main__":
    ### Create a service client ###
    service_client = DataLakeServiceClient(account_url="https://demodatalakecake.dfs.core.windows.net", credential=os.environ["storageAccKey"])
    ### Get the current filesystem and a directory (get or create) ###
    file_system_client = service_client.get_file_system_client(file_system="demolake")
    directory_client = file_system_client.get_directory_client("/test")
    
    ### Create the file in target, read in source and upload ###
    file_client = directory_client.create_file("poem.txt")
    local_file = open("./poem.txt","r")
    file_contents = local_file.read()

    ### Append and then commit data ###
    file_client.append_data(data=file_contents, offset=0, length=len(file_contents))
    file_client.flush_data(len(file_contents))

    print("Ta-done!")