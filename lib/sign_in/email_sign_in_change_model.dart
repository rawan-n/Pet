import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pets/services/auth.dart';
import 'package:pets/sign_in/email_sign_in_model.dart';
import 'package:pets/sign_in/validators.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.displayName = '',
      this.confirmPassword = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final AuthBase auth;
  String email;
  String password;
  String displayName;
  String confirmPassword;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            this.email, this.password, this.displayName);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

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
        displayNameValidator.isValid(displayName) &&
        passwordValidator.isValid(password) &&
        confirmPasswordValidator.isValid(confirmPassword) &&
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

  String get displayNameErrorText {
    bool showDisplayNameErrorText =
        submitted && !displayNameValidator.isValid(displayName);
    return showDisplayNameErrorText ? invalidDisplayNameErrorText : null;
  }

  String get confirmPasswordErrorText {
    if (!(password.isEmpty || confirmPassword.isEmpty)) {
      bool confirmPasswordErrorText =
          submitted && !displayNameValidator.isValid(confirmPassword);
      if (password != confirmPassword) {
        return passwordDontMatchErrorText;
      }
      return confirmPasswordErrorText ? invalidConfirmPasswordErrorText : null;
    }
    return null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        submitted: false,
        isLoading: false,
        formType: formType);
  }

  void updateEmail(String email) => updateWith(email: email);

  void updateDisplayName(String displayName) =>
      updateWith(displayName: displayName);

  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    String displayName,
    String confirmPassword,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.displayName = displayName ?? this.displayName;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}