using HealthApp.API.Data;
using HealthApp.API.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace HealthApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ProfileController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ProfileController(AppDbContext context) => _context = context;

        // Hàm rút gọn lấy ID từ Token
        private int GetUserId() => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        [HttpGet]
        public async Task<IActionResult> GetProfile()
        {
            var user = await _context.Users.FindAsync(GetUserId());
            if (user == null) return NotFound();

            var todayLog = await _context.DailyLogs
                .FirstOrDefaultAsync(l => l.UserId == user.Id && l.Date.Date == DateTime.Today);

            var profile = new UserProfileDTO
            {
                FullName = user.FullName,
                Age = user.Age,
                Gender = user.Gender,
                Height = user.Height,
                Weight = user.Weight,
                TargetWater = user.TargetWater,
                TargetCalories = user.TargetCalories,
                Goal = user.Goal,
                TodayLog = todayLog == null ? null : new DailyLogDTO
                {
                    Date = todayLog.Date,
                    WaterIntake = todayLog.WaterIntake,
                    CaloriesConsumed = todayLog.CaloriesConsumed,
                    CaloriesBurned = todayLog.CaloriesBurned,
                    SleepHours = todayLog.SleepHours,
                    Steps = todayLog.Steps,
                    WorkoutNote = todayLog.WorkoutNote,
                    DietNote = todayLog.DietNote
                }
            };
            return Ok(profile);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProfile(UserProfileDTO request)
        {
            var user = await _context.Users.FindAsync(GetUserId());
            if (user == null) return NotFound();

            user.FullName = request.FullName;
            user.Age = request.Age;
            user.Gender = request.Gender;
            user.Height = request.Height;
            user.Weight = request.Weight;
            user.TargetWater = request.TargetWater;
            user.TargetCalories = request.TargetCalories;
            user.Goal = request.Goal;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Cập nhật hồ sơ thành công!" });
        }
    }
}