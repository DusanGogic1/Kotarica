namespace NotificationsApi.Models
{
    public class SeenNotification
    {
        public int UserId { get; set; }
        public string TransactionHash { get; set; }
        public int LogIndex { get; set; }
    }
}