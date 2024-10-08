class AuthenticateRequest{

  final String email;
  final String password;

  AuthenticateRequest(this.email, this.password);

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };

}