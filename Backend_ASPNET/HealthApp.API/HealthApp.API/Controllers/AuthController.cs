using HealthApp.API.Data;
using HealthApp.API.DTOs;
using HealthApp.API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace HealthApp.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;

        // Tiêm (Inject) DbContext và Cấu hình (để lấy JWT Key)
        public AuthController(AppDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterDTO request)
        {
            // Kiểm tra xem tên đăng nhập đã tồn tại chưa
            if (await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                return BadRequest("Tên đăng nhập đã tồn tại.");
            }

            // Tạo user mới (Để thực tế và bảo mật hơn, sau này bạn nên mã hóa Password trước khi lưu)
            var user = new User
            {
                Username = request.Username,
                PasswordHash = request.Password,
                FullName = request.FullName
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Đăng ký thành công!" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDTO request)
        {
            // Tìm user trong Database
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

            // So sánh mật khẩu
            if (user == null || user.PasswordHash != request.Password)
            {
                return BadRequest("Tên đăng nhập hoặc mật khẩu không đúng.");
            }

            // Tạo Token JWT nếu đăng nhập thành công
            string token = CreateToken(user);

            return Ok(new { token = token, message = "Đăng nhập thành công!" });
        }

        private string CreateToken(User user)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddDays(7), // Token có hạn trong 7 ngày
                signingCredentials: creds
            );

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);
            return jwt;
        }
    }
}