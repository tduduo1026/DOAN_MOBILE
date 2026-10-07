using System.ComponentModel.DataAnnotations.Schema;

namespace HealthApp.API.Models
{
    public class DailyLog
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public DateTime Date { get; set; }
        public double WaterIntake { get; set; } // Lượng nước đã uống (ml)
        public double CaloriesConsumed { get; set; } // Calo nạp vào
        public double CaloriesBurned { get; set; } // Calo tiêu hao (Tập luyện)

        [ForeignKey("UserId")]
        public User? User { get; set; }
    }
}