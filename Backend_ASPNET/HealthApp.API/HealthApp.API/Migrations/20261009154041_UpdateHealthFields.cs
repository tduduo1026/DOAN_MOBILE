using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HealthApp.API.Migrations
{
    /// <inheritdoc />
    public partial class UpdateHealthFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ActivityType",
                table: "DailyLogs",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "DurationMinutes",
                table: "DailyLogs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "HeartRateBpm",
                table: "DailyLogs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "MuscleGroup",
                table: "DailyLogs",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ActivityType",
                table: "DailyLogs");

            migrationBuilder.DropColumn(
                name: "DurationMinutes",
                table: "DailyLogs");

            migrationBuilder.DropColumn(
                name: "HeartRateBpm",
                table: "DailyLogs");

            migrationBuilder.DropColumn(
                name: "MuscleGroup",
                table: "DailyLogs");
        }
    }
}
