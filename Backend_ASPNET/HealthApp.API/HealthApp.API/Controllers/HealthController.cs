using HealthApp.API.Data;
using HealthApp.API.DTOs;
using HealthApp.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace HealthApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class HealthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public HealthController(AppDbContext context)
        {
            _context = context;
        }

        // Hàm hỗ trợ lấy/tạo nhật ký của ngày hôm nay
        private async Task<DailyLog> GetOrCreateTodayLog(int userId)
        {
            var today = DateTime.Today;
            var log = await _context.DailyLogs
                .FirstOrDefaultAsync(l => l.UserId == userId && l.Date.Date == today);

            if (log == null)
            {
                log = new DailyLog { UserId = userId, Date = today };
                _context.DailyLogs.Add(log);
                await _context.SaveChangesAsync();
            }
            return log;
        }

        // Lấy toàn bộ dữ liệu ngày hôm nay để hiển thị ra Dashboard
        [HttpGet("today")]
        public async Task<IActionResult> GetTodayLog()
        {
            int userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var log = await GetOrCreateTodayLog(userId);
            return Ok(log);
        }

        // API thêm lượng nước
        [HttpPost("water")]
        public async Task<IActionResult> AddWater(UpdateWaterDTO request)
        {
            int userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var log = await GetOrCreateTodayLog(userId);

            log.WaterIntake += request.WaterAmount; // Cộng dồn nước
            await _context.SaveChangesAsync();

            return Ok(new { message = "Cập nhật nước thành công!", currentWater = log.WaterIntake });
        }

        // API thêm Calo (Ăn vào hoặc Tập luyện)
        [HttpPost("calories")]
        public async Task<IActionResult> AddCalories(UpdateCaloriesDTO request)
        {
            int userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var log = await GetOrCreateTodayLog(userId);

            if (request.IsBurned)
                log.CaloriesBurned += request.CaloriesAmount;
            else
                log.CaloriesConsumed += request.CaloriesAmount;

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Cập nhật calo thành công!",
                consumed = log.CaloriesConsumed,
                burned = log.CaloriesBurned
            });
        }
        [HttpPut("metrics")]
        public async Task<IActionResult> UpdateDailyMetrics(UpdateDailyMetricsDTO request)
        {
            int userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var log = await GetOrCreateTodayLog(userId);

            log.SleepHours = request.SleepHours;
            log.Steps = request.Steps;
            log.WorkoutNote = request.WorkoutNote;
            log.DietNote = request.DietNote;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Cập nhật chỉ số hôm nay thành công!" });
        }
    }
}