class Workout {
  final String id;
  String exerciseType;
  int duration;
  int caloriesBurned;
  int steps;
  DateTime date;

  Workout({
    required this.id,
    required this.exerciseType,
    required this.duration,
    required this.caloriesBurned,
    required this.steps,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_type': exerciseType,
      'duration': duration,
      'calories_burned': caloriesBurned,
      'steps': steps,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      exerciseType: json['exercise_type'],
      duration: json['duration'],
      caloriesBurned: json['calories_burned'],
      steps: json['steps'],
      date: DateTime.parse(json['date']),
    );
  }

  Workout copyWith({
    String? exerciseType,
    int? duration,
    int? caloriesBurned,
    int? steps,
  }) {
    return Workout(
      id: id,
      exerciseType: exerciseType ?? this.exerciseType,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      date: date,
    );
  }

  String get durationInMinutes => '$duration min';
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}