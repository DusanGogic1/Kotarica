using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace NotificationsApi.Models
{
    public class Message
    {
        public Guid Id { get; set; }
        [Required]
        public virtual int productId { get; set; }
        [Required]
        public int senderId { get; set; }
        [Required]
        public int receiverId { get; set; }
        
        [Required]
        [RegularExpression("text|images", ErrorMessage = "Invalid message type")]
        public string messageType { get; set; }
        [Required]
        public string content { get; set; }
        
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        public DateTime TimeStamp { get; set; }

    }
}
