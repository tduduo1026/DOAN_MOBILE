namespace HealthApp.API.DTOs
{
    public class HealthRecordDTO
    {
        public DateTime Date { get; set; }
        public double HeightCm { get; set; }
        public double WeightKg { get; set; }
        public int HeartRateBpm { get; set; }
    }
}
