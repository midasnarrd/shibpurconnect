//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SCDataAccess
{
    using System;
    using System.Collections.Generic;
    
    public partial class TicketCommentMapping
    {
        public int TicketUserId { get; set; }
        public string Comment { get; set; }
        public System.DateTime CreateDatetime { get; set; }
        public System.DateTime UpdateDatetime { get; set; }
    
        public virtual Ticket Ticket { get; set; }
        public virtual UserProfile UserProfile { get; set; }
    }
}
