namespace HealthApp.API.DTOs
{
    public class UserProfileDTO
    {
        public string FullName { get; set; } = string.Empty;
        public int Age { get; set; }
        public string Gender { get; set; } = string.Empty;
        public double Height { get; set; }
        public double Weight { get; set; }
        public double TargetWater { get; set; }
        public double TargetCalories { get; set; }
        public string Goal { get; set; } = string.Empty;

        // Lồng thêm dữ liệu của ngày hôm nay vào chung Profile
        public DailyLogDTO? TodayLog { get; set; }
    }

    public class DailyLogDTO
    {
        public DateTime Date { get; set; }
        public double WaterIntake { get; set; }
        public double CaloriesConsumed { get; set; }
        public double CaloriesBurned { get; set; }
        public double SleepHours { get; set; }
        public int Steps { get; set; }
        public string WorkoutNote { get; set; } = string.Empty;
        public string DietNote { get; set; } = string.Empty;
    }
}