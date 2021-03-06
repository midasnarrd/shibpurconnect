﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShibpurConnectWebApp.Models
{
    public class TokenApi
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
        public string userName { get; set; }
    }

    public class ModelState
    {
        public List<string> __invalid_name__ { get; set; }
    }

    public class RegisterAPI
    {
        public string Message { get; set; }
        public ModelState ModelState { get; set; }
    }
}