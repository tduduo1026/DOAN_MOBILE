namespace HealthApp.API.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public double Height { get; set; } // Chiều cao (cm)
        public double Weight { get; set; } // Cân nặng (kg)
        public double TargetWater { get; set; } // Mục tiêu uống nước (ml)
        public double TargetCalories { get; set; } // Mục tiêu Calo
    }
}