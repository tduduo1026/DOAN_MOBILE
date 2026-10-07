namespace HealthApp.API.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;

        // --- CÁC TRƯỜNG MỚI THÊM ---
        public int Age { get; set; }
        public string Gender { get; set; } = string.Empty; // Nam/Nữ
        public string Goal { get; set; } = string.Empty; // VD: Tăng cân, Giảm mỡ

        public double Height { get; set; }
        public double Weight { get; set; }
        public double TargetWater { get; set; }
        public double TargetCalories { get; set; }
    }
}