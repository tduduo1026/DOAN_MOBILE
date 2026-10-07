using HealthApp.API.Models;
using Microsoft.EntityFrameworkCore;

namespace HealthApp.API.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<DailyLog> DailyLogs { get; set; }
    }
}