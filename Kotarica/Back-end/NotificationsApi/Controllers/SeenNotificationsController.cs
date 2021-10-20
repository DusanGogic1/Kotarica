using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NotificationsApi.Database;
using NotificationsApi.Models;

namespace NotificationsApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SeenNotificationsController : ControllerBase
    {
        private readonly NotificationsApiDbContext _context;

        public SeenNotificationsController(NotificationsApiDbContext context)
        {
            _context = context;
        }

        // GET: api/SeenNotifications/5
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<SeenNotification>>> GetSeenNotifications(int userId)
        {
            return await _context.SeenNotifications.Where(sn => sn.UserId == userId).ToListAsync();
        }

        // GET: api/SeenNotifications/5/0x850f0645fc70d6e2888e6ed01e671efa9249195c50b08a5206917ffac6066c8a/0
        [HttpGet("{userId}/{transactionHash}/{logIndex}")]
        public async Task<ActionResult<SeenNotification>> GetSeenNotification(int userId, String transactionHash, int logIndex)
        {
            var seenNotification = await _context.SeenNotifications.FindAsync(userId, transactionHash, logIndex);

            if (seenNotification == null)
            {
                return NotFound();
            }

            return seenNotification;
        }

        // PUT: api/SeenNotifications/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        // [HttpPut("{id}")]
        // public async Task<IActionResult> PutSeenNotification(int id, SeenNotification seenNotification)
        // {
        //     if (id != seenNotification.UserId)
        //     {
        //         return BadRequest();
        //     }

        //     _context.Entry(seenNotification).State = EntityState.Modified;

        //     try
        //     {
        //         await _context.SaveChangesAsync();
        //     }
        //     catch (DbUpdateConcurrencyException)
        //     {
        //         if (!SeenNotificationExists(id))
        //         {
        //             return NotFound();
        //         }
        //         else
        //         {
        //             throw;
        //         }
        //     }

        //     return NoContent();
        // }

        // POST: api/SeenNotifications
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<SeenNotification>> PostSeenNotification(SeenNotification seenNotification)
        {
            _context.SeenNotifications.Add(seenNotification);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (!SeenNotificationExists(seenNotification.UserId, seenNotification.TransactionHash, seenNotification.LogIndex))
                {
                    throw;
                }
            }

            return CreatedAtAction(nameof(GetSeenNotification), new { userId = seenNotification.UserId, transactionHash = seenNotification.TransactionHash, logIndex = seenNotification.LogIndex }, seenNotification);
        }

        // DELETE: api/SeenNotifications/5
        // Delete all records of seen notifications for a user
        [HttpDelete("{userId}")]
        public async Task<IActionResult> DeleteSeenNotifications(int userId)
        {
            var seenNotifications = _context.SeenNotifications.Where(n => n.UserId == userId).ToList();
            if (seenNotifications == null)
            {
                return NoContent();
            }

            _context.SeenNotifications.RemoveRange(seenNotifications);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SeenNotificationExists(int userId, string transactionHash, int logIndex)
        {
            return _context.SeenNotifications.Any(e => e.UserId == userId && e.TransactionHash == transactionHash && e.LogIndex == logIndex);
        }
    }
}
