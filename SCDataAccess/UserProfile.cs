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
    
    public partial class UserProfile
    {
        public UserProfile()
        {
            this.Tickets = new HashSet<Ticket>();
            this.TicketCommentMappings = new HashSet<TicketCommentMapping>();
        }
    
        public int UserId { get; set; }
        public string PGuid { get; set; }
        public string Legal_First_Name { get; set; }
        public string Legal_last_Name { get; set; }
        public string EmailAddress { get; set; }
        public string Address { get; set; }
        public Nullable<int> PassoutBatch { get; set; }
        public string Dept { get; set; }
        public System.DateTime CreateDatetime { get; set; }
        public System.DateTime UpdateDatetime { get; set; }
    
        public virtual ICollection<Ticket> Tickets { get; set; }
        public virtual ICollection<TicketCommentMapping> TicketCommentMappings { get; set; }
    }
}
