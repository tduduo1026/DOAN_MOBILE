class UserProfileModel {
  final String fullName;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double targetWater;
  final double targetCalories;
  final String goal;
  final TodayLogModel? todayLog;

  UserProfileModel({
    required this.fullName,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.targetWater,
    required this.targetCalories,
    required this.goal,
    this.todayLog,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      targetWater: (json['targetWater'] ?? 0).toDouble(),
      targetCalories: (json['targetCalories'] ?? 0).toDouble(),
      goal: json['goal'] ?? '',
      todayLog: json['todayLog'] != null ? TodayLogModel.fromJson(json['todayLog']) : null,
    );
  }
}

class TodayLogModel {
  final String date;
  final double waterIntake;
  final double caloriesConsumed;
  final double caloriesBurned;
  final double sleepHours;
  final int steps;
  final String workoutNote;
  final String dietNote;

  TodayLogModel({
    required this.date,
    required this.waterIntake,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.sleepHours,
    required this.steps,
    required this.workoutNote,
    required this.dietNote,
  });

  factory TodayLogModel.fromJson(Map<String, dynamic> json) {
    return TodayLogModel(
      date: json['date'] ?? '',
      waterIntake: (json['waterIntake'] ?? 0).toDouble(),
      caloriesConsumed: (json['caloriesConsumed'] ?? 0).toDouble(),
      caloriesBurned: (json['caloriesBurned'] ?? 0).toDouble(),
      sleepHours: (json['sleepHours'] ?? 0).toDouble(),
      steps: json['steps'] ?? 0,
      workoutNote: json['workoutNote'] ?? '',
      dietNote: json['dietNote'] ?? '',
    );
  }
}