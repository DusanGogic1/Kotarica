using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace NotificationsApi.Migrations
{
    public partial class initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Chats",
                columns: table => new
                {
                    ProductId = table.Column<int>(type: "INTEGER", nullable: false),
                    Buyer = table.Column<int>(type: "INTEGER", nullable: false),
                    Seller = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Chats", x => new { x.ProductId, x.Buyer, x.Seller });
                });

            migrationBuilder.CreateTable(
                name: "Messages",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
                    productId = table.Column<int>(type: "INTEGER", nullable: false),
                    senderId = table.Column<int>(type: "INTEGER", nullable: false),
                    receiverId = table.Column<int>(type: "INTEGER", nullable: false),
                    messageType = table.Column<string>(type: "TEXT", nullable: false),
                    content = table.Column<string>(type: "TEXT", nullable: false),
                    TimeStamp = table.Column<DateTime>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Messages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SeenNotifications",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "INTEGER", nullable: false),
                    TransactionHash = table.Column<string>(type: "TEXT", nullable: false),
                    LogIndex = table.Column<int>(type: "INTEGER", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SeenNotifications", x => new { x.UserId, x.TransactionHash, x.LogIndex });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Chats");

            migrationBuilder.DropTable(
                name: "Messages");

            migrationBuilder.DropTable(
                name: "SeenNotifications");
        }
    }
}
