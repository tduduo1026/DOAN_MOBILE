namespace HealthApp.API.DTOs
{
    public class DashboardDTO
    {
        public string RecordDate { get; set; }
        public int WaterIntakeMl { get; set; }
        public string DrinksInfo { get; set; } // VD: "Nước cam pha loãng"

        public NutritionDTO Nutrition { get; set; }
        public WorkoutDTO Workout { get; set; }
    }

    public class NutritionDTO
    {
        public double ConsumedCalories { get; set; }
        public List<string> Meals { get; set; } // Hứng mảng ['Cơm trắng', 'Đùi gà', 'Trứng vịt']
    }

    public class WorkoutDTO
    {
        public string ActivityType { get; set; }
        public string MuscleGroup { get; set; }
        public int DurationMinutes { get; set; }
    }
}
