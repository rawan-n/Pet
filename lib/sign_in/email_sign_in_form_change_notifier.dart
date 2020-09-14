import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pets/services/auth.dart';
import 'package:pets/sign_in/email_sign_in_change_model.dart';
import 'package:pets/widgets/form_submit_button.dart';
import 'package:pets/widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _displayNameFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmPasswordFN = FocusNode();

  FocusNode newFocus;

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailFN.dispose();
    _passwordFN.dispose();
    _displayNameFN.dispose();
    _confirmPasswordFN.dispose();
    _displayNameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    // newFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (Platform.isIOS) {
      } else {
        PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: e,
        ).show(context);
      }
    }
  }

  // void _textFieldEditingComplete() {
  //   newFocus =
  //       model.emailValidator.isValid(model.email) ? _displayNameFN : _emailFN;
  //   if (newFocus == _displayNameFN) {
  //     newFocus = model.displayNameValidator.isValid(model.displayName)
  //         ? _passwordFN
  //         : _displayNameFN;
  //   }
  //   if (newFocus == _passwordFN) {
  //     newFocus = model.displayNameValidator.isValid(model.displayName)
  //         ? _confirmPasswordFN
  //         : _passwordFN;
  //   }
  //   FocusScope.of(context).requestFocus(newFocus);
  // }
  void _displayNameEditingComplete() {
    newFocus = model.displayNameValidator.isValid(model.displayName)
        ? _passwordFN
        : _displayNameFN;

    FocusScope.of(context).requestFocus(newFocus);
    newFocus = null;
  }

  void _passwordEditingComplete() {
    newFocus = model.passwordValidator.isValid(model.password)
        ? _confirmPasswordFN
        : _passwordFN;

    FocusScope.of(context).requestFocus(newFocus);
    newFocus = null;
  }

  void _regEmailEditingComplete() {
    newFocus =
        model.emailValidator.isValid(model.email) ? _displayNameFN : _emailFN;

    FocusScope.of(context).requestFocus(newFocus);
    newFocus = null;
  }

  void _emailEditingComplete() {
    newFocus =
        model.emailValidator.isValid(model.email) ? _passwordFN : _emailFN;

    FocusScope.of(context).requestFocus(newFocus);
    newFocus = null;
  }

  void _toggleFormType() {
    newFocus = null;
    model.toggleFormType();
    _displayNameController.clear();
    _confirmPasswordController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      model.formType.index == 1 ? _buildDisplayNameTextField() : SizedBox(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      model.formType.index == 1 ? _buildConfirmPasswordTextField() : SizedBox(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  // model.formType.index == 1

  TextField _buildDisplayNameTextField() {
    return TextField(
      controller: _displayNameController,
      focusNode: _displayNameFN,
      decoration: InputDecoration(
        labelText: 'Display Name',
        errorText: model.displayNameErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      onChanged: model.updateDisplayName,
      onEditingComplete: () => _displayNameEditingComplete,
    );
  }

  TextField _buildConfirmPasswordTextField() {
    return TextField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFN,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: model.confirmPasswordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updateConfirmPassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
        controller: _passwordController,
        focusNode: _passwordFN,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: model.formType.index == 0
            ? TextInputAction.done
            : TextInputAction.next,
        onChanged: model.updatePassword,
        onEditingComplete: () =>
            model.formType.index == 0 ? _submit() : _passwordEditingComplete());
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFN,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'example@example.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => model.formType.index == 0
          ? _emailEditingComplete()
          : _regEmailEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}