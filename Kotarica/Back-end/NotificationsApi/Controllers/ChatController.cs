using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using NotificationsApi.Database;
using NotificationsApi.Hubs;
using NotificationsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NotificationsApi.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class ChatController : ControllerBase {
        private readonly NotificationsApiDbContext _context;
        private readonly IHubContext<ChatHub> _chat;

        public ChatController(NotificationsApiDbContext context, IHubContext<ChatHub> chat) {
            _context = context;
            _chat = chat;
        }

        // GET: api/Chat/0
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Chat>>> GetChatsForUser(int userId) {
            List<Chat> myChats = await _context.Chats.Where(c => c.Buyer == userId || c.Seller == userId).ToListAsync();

            // if (myChats != null) return Ok(myChats);
            // else return NotFound("No chats for this user");

            return myChats;
        }

        // GET: api/Chat/0/0/0
        [HttpGet("{productId}/{user1Id}/{user2Id}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessagesForChat(int productId, int user1Id, int user2Id) {
            List<Message> messages = await _context.Messages.Where(
                m => m.productId == productId && (
                    (m.senderId == user1Id && m.receiverId == user2Id)
                    || (m.senderId == user2Id && m.receiverId == user1Id)
                )
            )
            .OrderByDescending(m => m.TimeStamp)
            .ToListAsync();

            // if (my != null) return Ok(my);
            // else return NotFound("Messages for this chat not found");

            return messages;
        }


        // GET: api/Chat/Message/2aab7976-f102-4165-bbe3-6704a8862653
        [HttpGet("Message/{guidString}")]
        public async Task<ActionResult<Message>> GetMessage(String guidString) {
            Guid guid = Guid.Parse(guidString);
            var message = await _context.Messages.FindAsync(guid);

            if (message == null) {
                return NotFound();
            }

            return message;
        }

        [HttpPost]
        public async Task<ActionResult<SeenNotification>> SendMessage(Message message) {
            message.Id = Guid.NewGuid();
            message.TimeStamp = DateTime.Now;

            _context.Messages.Add(message);
            if (!ChatExists(message.productId, message.senderId, message.receiverId)) {
                _context.Chats.Add(new Chat { ProductId = message.productId, Buyer = message.senderId, Seller = message.receiverId });
            }
            await _context.SaveChangesAsync();

            await _chat.Clients.All.SendAsync("ReceiveNewMessage", message.senderId, message.receiverId, message.messageType, message.content, message.TimeStamp);

            return CreatedAtAction(nameof(GetMessage), new { guidString = message.Id.ToString() }, message);
        }

        private bool ChatExists(int productId, int user1Id, int user2Id) {
            return _context.Chats.Any(c
                => c.ProductId == productId && (
                    (c.Buyer == user1Id && c.Seller == user2Id)
                    || (c.Buyer == user2Id && c.Seller == user1Id)
                )
            );
        }
    }
}
