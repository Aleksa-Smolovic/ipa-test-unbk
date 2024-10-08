import 'package:unbroken/models/user.dart';

class WorkoutSlot {
  final int id;
  final String timeFrom;
  final String timeTo;
  final Set<User> attendees;

  WorkoutSlot(this.id, this.timeFrom, this.timeTo, this.attendees);

  WorkoutSlot.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        timeFrom = json['timeFrom'] as String,
        timeTo = json['timeTo'] as String,
        attendees =
            json['attendees'].map<User>((user) => User.fromJson(user)).toSet();

  bool isUserAttendee(int userId){
    return attendees.any((s) => s.id == userId);
  }

}
