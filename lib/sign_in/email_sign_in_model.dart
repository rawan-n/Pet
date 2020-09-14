import 'package:pets/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.displayName,
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String displayName;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showPasswordErrorText =
        submitted && !passwordValidator.isValid(password);
    return showPasswordErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showEmailErrorText = submitted && !emailValidator.isValid(email);
    return showEmailErrorText ? invalidEmailErrorText : null;
  }

  EmailSignInModel copyWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool submitted}) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.email,
      formType: formType ?? this.formType,
      submitted: submitted ?? this.submitted,
    );
  }
}