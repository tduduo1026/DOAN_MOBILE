using System.ComponentModel.DataAnnotations.Schema;

namespace HealthApp.API.Models
{
    public class DailyLog
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public DateTime Date { get; set; }
        public double WaterIntake { get; set; }
        public double CaloriesConsumed { get; set; }
        public double CaloriesBurned { get; set; }

        // --- CÁC TRƯỜNG MỚI THÊM ---
        public double SleepHours { get; set; } // Giờ ngủ
        public int Steps { get; set; } // Số bước chân
        public string WorkoutNote { get; set; } = string.Empty; // Ghi chú tập luyện
        public string DietNote { get; set; } = string.Empty; // Thực đơn trong ngày

        [ForeignKey("UserId")]
        public User? User { get; set; }
    }
}