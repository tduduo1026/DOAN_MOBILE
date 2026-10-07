namespace HealthApp.API.DTOs
{
    public class UpdateWaterDTO
    {
        public double WaterAmount { get; set; } // Lượng nước vừa uống thêm
    }

    public class UpdateCaloriesDTO
    {
        public double CaloriesAmount { get; set; } // Lượng calo
        public bool IsBurned { get; set; } // true: Tiêu hao (tập gym/chạy bộ), false: Nạp vào (ăn uống)
    }
    public class UpdateDailyMetricsDTO
    {
        public double SleepHours { get; set; }
        public int Steps { get; set; }
        public string WorkoutNote { get; set; } = string.Empty;
        public string DietNote { get; set; } = string.Empty;
    }
}