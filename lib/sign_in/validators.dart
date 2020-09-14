abstract class StringValidator {
  bool isValid(String value);
}

class NoneEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NoneEmptyStringValidator();
  final StringValidator displayNameValidator = NoneEmptyStringValidator();
  final StringValidator passwordValidator = NoneEmptyStringValidator();
  final StringValidator confirmPasswordValidator = NoneEmptyStringValidator();
  final String invalidEmailErrorText = 'Email Can\'t be empty';
  final String invalidPasswordErrorText = 'Password Can\'t be empty';
  final String invalidDisplayNameErrorText = 'Display name Can\'t be empty';
  final String invalidConfirmPasswordErrorText = 'Password Can\'t be empty';
  final String passwordDontMatchErrorText = 'Your password doesn\'t match';
}