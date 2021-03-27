using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;

namespace BlobTrigger
{
    public class SynetheticEmail
    {
        private static string _smtpUID;
        private static string _smtpPWD;

        private ILogger _logger;

        static SynetheticEmail()
        {
            _smtpUID = Environment.GetEnvironmentVariable("smtpUID");
            _smtpPWD = Environment.GetEnvironmentVariable("smtpPWD");
        }


        public SynetheticEmail(ILogger log)
        {
            _logger = log;

        }


        public void SendEmail(string subject, string message)
        {
            _logger.LogInformation($"Sending Synthetic email from UID: {_smtpUID}");
            _logger.LogInformation($"Subject: {subject}. Message: {message}");
            return;
        }

    }
}
