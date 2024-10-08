import 'package:unbroken/models/workout_type.dart';

class Workout {
  final int id;
  final String text;
  final WorkoutType type;

  Workout(this.id, this.text, this.type);

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        text = json['text'] as String,
        type = WorkoutType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => throw Exception("Invalid WorkoutType: ${json['type']}"),
        );
}
