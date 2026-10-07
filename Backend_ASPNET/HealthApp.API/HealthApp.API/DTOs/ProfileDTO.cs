namespace HealthApp.API.DTOs
{
    public class UserProfileDTO
    {
        public string FullName { get; set; } = string.Empty;
        public double Height { get; set; }
        public double Weight { get; set; }
        public double TargetWater { get; set; }
        public double TargetCalories { get; set; }
    }
}