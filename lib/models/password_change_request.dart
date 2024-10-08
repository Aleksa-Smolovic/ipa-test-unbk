class PasswordChangeRequest {
  final String oldPassword;
  final String newPassword;

  PasswordChangeRequest(this.oldPassword, this.newPassword);

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}
