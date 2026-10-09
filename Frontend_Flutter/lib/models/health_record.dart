/// Dữ liệu đo sức khỏe mẫu dùng chung cho màn hình nhật ký và thống kê.
class HealthRecord {
  final DateTime date;
  final double heightCm;
  final double weightKg;
  final int heartRateBpm;

  const HealthRecord({
    required this.date,
    required this.heightCm,
    required this.weightKg,
    required this.heartRateBpm,
  });

  double get bmi {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
}

class HealthRecordStore {
  HealthRecordStore._();

  /// Giữ cấu trúc JSON mẫu đang được dùng trong màn hình tổng quan.
  static const Map<String, dynamic> dailyJson = {
    'recordDate': '2026-10-02',
    'waterIntakeMl': 1500,
    'drinksInfo': 'Nước cam pha loãng',
    'nutrition': {
      'consumedCalories': 1200,
      'meals': ['Cơm trắng', 'Đùi gà', 'Trứng vịt'],
    },
    'workout': {
      'activityType': 'Gym - Tập tạ',
      'muscleGroup': 'Tay và Bụng',
      'durationMinutes': 60,
    },
  };

  static double get sampleCalories {
    final nutrition = dailyJson['nutrition'] as Map<String, dynamic>;
    return (nutrition['consumedCalories'] as num).toDouble();
  }

  /// Dữ liệu thực tế sẽ được lấy từ API khi backend được tích hợp.
  static final List<HealthRecord> records = [
    HealthRecord(
      date: DateTime(2026, 10, 9),
      heightCm: 175,
      weightKg: 67.5,
      heartRateBpm: 72,
    ),
    HealthRecord(
      date: DateTime(2026, 10, 2),
      heightCm: 175,
      weightKg: 67.9,
      heartRateBpm: 75,
    ),
    HealthRecord(
      date: DateTime(2026, 9, 25),
      heightCm: 175,
      weightKg: 68.2,
      heartRateBpm: 70,
    ),
    HealthRecord(
      date: DateTime(2026, 9, 18),
      heightCm: 175,
      weightKg: 68.5,
      heartRateBpm: 74,
    ),
    HealthRecord(
      date: DateTime(2026, 9, 11),
      heightCm: 175,
      weightKg: 68.8,
      heartRateBpm: 72,
    ),
    HealthRecord(
      date: DateTime(2026, 9, 4),
      heightCm: 175,
      weightKg: 69.3,
      heartRateBpm: 73,
    ),
    HealthRecord(
      date: DateTime(2026, 8, 28),
      heightCm: 175,
      weightKg: 69.8,
      heartRateBpm: 71,
    ),
  ];

  static void save(HealthRecord record) {
    records.removeWhere((item) =>
        item.date.year == record.date.year &&
        item.date.month == record.date.month &&
        item.date.day == record.date.day);
    records.add(record);
    records.sort((a, b) => b.date.compareTo(a.date));
  }
}
