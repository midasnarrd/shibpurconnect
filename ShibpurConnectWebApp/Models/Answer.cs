﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ShibpurConnectWebApp.Models
{
    public class Answer
    {
        public string AnsweredBy { get; set; }

        public string DetailText { get; set; }

        public bool Accepted { get; set; }

        public int Reputation { get; set; }

        public DateTime DatePosted { get; set; }
    }
}