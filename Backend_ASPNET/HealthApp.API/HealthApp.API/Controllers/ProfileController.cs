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
    [Authorize] // Bắt buộc phải có Token JWT mới gọi được API này
    public class ProfileController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProfileController(AppDbContext context)
        {
            _context = context;
        }

        // Lấy thông tin hồ sơ của user đang đăng nhập
        [HttpGet]
        public async Task<IActionResult> GetProfile()
        {
            // Trích xuất ID của user từ Token
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userIdClaim == null) return Unauthorized();

            int userId = int.Parse(userIdClaim);

            var user = await _context.Users.FindAsync(userId);
            if (user == null) return NotFound("Không tìm thấy người dùng.");

            var profile = new UserProfileDTO
            {
                FullName = user.FullName,
                Height = user.Height,
                Weight = user.Weight,
                TargetWater = user.TargetWater,
                TargetCalories = user.TargetCalories
            };

            return Ok(profile);
        }

        // Cập nhật thông tin (Chiều cao, Cân nặng, Mục tiêu)
        [HttpPut]
        public async Task<IActionResult> UpdateProfile(UserProfileDTO request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userIdClaim == null) return Unauthorized();

            int userId = int.Parse(userIdClaim);

            var user = await _context.Users.FindAsync(userId);
            if (user == null) return NotFound("Không tìm thấy người dùng.");

            // Cập nhật dữ liệu mới vào DB
            user.FullName = request.FullName;
            user.Height = request.Height;
            user.Weight = request.Weight;
            user.TargetWater = request.TargetWater;
            user.TargetCalories = request.TargetCalories;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Cập nhật hồ sơ thành công!" });
        }
    }
}