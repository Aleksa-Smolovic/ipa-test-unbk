class ApiEndpoints {
  // static const String baseUrl = "http://192.168.1.71:8080";
  static const String baseUrl = "http://148.100.112.5:8080";
  static const String baseApiUrl = "$baseUrl/api";
  static const String imagesUrl = "$baseUrl/images/";

  // Authentication Endpoints
  static const String login = "$baseApiUrl/users/authenticate";

  // User Endpoints
  static const String changePassword = "$baseApiUrl/users/password";
  static const String account = "$baseApiUrl/users/account";
  static const String updateUserInfo = "$baseApiUrl/users";
  static const String resetPassword = "$baseApiUrl/users/reset-password?email=";

  static const String announcements = "$baseApiUrl/announcements?sort=createdAt,desc";

  static const String workouts = "$baseApiUrl/workouts/by-date?date=";
  static const String workoutSlots = "$baseApiUrl/workout-slots/by-date?date=";
  static const String workoutSlotAttendeeAddOrRemove = "$baseApiUrl/workout-slots/{id}/attendee";
  static const String attendeeWorkoutDates = "$baseApiUrl/workout-slots/attendee/dates?date=";


}