using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BlobTrigger
{
    public static class BlobFunc
    {
        [FunctionName("BlobFunc")]
        public static void Run([BlobTrigger("demolake/test/{name}", Connection = "blobConnectionString")]Stream myBlob, string name, ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");

            /*Lazy interpretaion -> I'm not actually sending email but logging to console. Injecting UID and PWD from environment in a static constuctor.*/
            var EmailSender = new SynetheticEmail(log);

            EmailSender.SendEmail("TestSubject", "TestMessage");


        }
    }
}
