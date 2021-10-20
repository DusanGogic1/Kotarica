using Microsoft.EntityFrameworkCore;
using NotificationsApi.Models;

namespace NotificationsApi.Database
{
    public class NotificationsApiDbContext: DbContext
    {
        public NotificationsApiDbContext(DbContextOptions<NotificationsApiDbContext> options) : base(options) {}

        //notifikacije
        public DbSet<SeenNotification> SeenNotifications { get; set; }

        //chat
        public DbSet<Chat> Chats { get; set; }
        public DbSet<Message> Messages { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<SeenNotification>().HasKey(n => new
            {
                n.UserId,
                n.TransactionHash,
                n.LogIndex,
            });

            modelBuilder.Entity<Chat>().HasKey(n => new
            {
                n.ProductId,
                n.Buyer,
                n.Seller
            });
        }
    }
}