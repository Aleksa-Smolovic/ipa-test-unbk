class ErrorMessages {
  static const Map<String, String> _messages = {
    'unauthorized': 'Invalid username and password!',
    'invalid-params': 'The parameters provided are invalid!',
    'membership-expired': 'Action not allowed, your membership has expired!',
    'incorrect-old-password': 'Incorrect old password!',
  };

  static String getMessage(String errorCode) {
    return _messages[errorCode] ?? defaultMessage;
  }

  static const String defaultMessage = 'There was an error, try again later.';
}
