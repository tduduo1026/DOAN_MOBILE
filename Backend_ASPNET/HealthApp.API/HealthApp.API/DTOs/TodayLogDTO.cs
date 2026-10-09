namespace HealthApp.API.DTOs
{
    public class TodayLogDTO
    {
        public string Date { get; set; }
        public double WaterIntake { get; set; }
        public double CaloriesConsumed { get; set; }
        public double CaloriesBurned { get; set; }
        public double SleepHours { get; set; }
        public int Steps { get; set; }
        public string WorkoutNote { get; set; }
        public string DietNote { get; set; }
    }
}
