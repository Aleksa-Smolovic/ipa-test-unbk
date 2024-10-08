import 'package:unbroken/models/workout_type.dart';

class User {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String? image;
  final String? createdAt;
  final String? instagramUrl;
  final WorkoutType workoutType;
  final String? membershipValidFrom;
  final String? membershipValidTo;

  User(
      this.id,
      this.fullName,
      this.phoneNumber,
      this.image,
      this.createdAt,
      this.instagramUrl,
      this.workoutType,
      this.membershipValidFrom,
      this.membershipValidTo);

  User.updateInfo({
    required this.fullName,
    required this.phoneNumber,
    this.instagramUrl,
    required this.workoutType,
  })  : id = null,
        image = null,
        createdAt = null,
        membershipValidFrom = null,
        membershipValidTo = null;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        fullName = json['fullName'] as String,
        phoneNumber = json['phoneNumber'] as String,
        image = json['image'] as String,
        createdAt = json['createdAt'] as String,
        membershipValidFrom = json['membershipValidFrom'] as String?,
        membershipValidTo = json['membershipValidTo'] as String?,
        instagramUrl = json['instagramUrl'] as String?,
        workoutType = WorkoutType.values.firstWhere(
          (e) => e.toString().split('.').last == json['workoutType'],
          orElse: () => throw Exception("Invalid WorkoutType: ${json['type']}"),
        );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'instagramUrl': instagramUrl,
        'workoutType': workoutType.name
      };
}
