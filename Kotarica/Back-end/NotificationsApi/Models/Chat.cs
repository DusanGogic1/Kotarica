using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NotificationsApi.Models
{
    public class Chat
    {
        public int ProductId { get; set; }
        public int Buyer { get; set; }
        public int Seller { get; set; }

        // public ICollection<Message> Messages { get; set; }

        // public Chat()
        // {
        //     Messages = new List<Message>();
        // }
    }
}
