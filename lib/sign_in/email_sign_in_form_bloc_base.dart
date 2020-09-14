import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pets/services/auth.dart';
import 'package:pets/sign_in/email_sign_in_bloc.dart';
import 'package:pets/sign_in/email_sign_in_model.dart';
import 'package:pets/widgets/form_submit_button.dart';
import 'package:pets/widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBase extends StatefulWidget {
  EmailSignInFormBlocBase({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBase(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBaseState createState() =>
      _EmailSignInFormBlocBaseState();
}

class _EmailSignInFormBlocBaseState extends State<EmailSignInFormBlocBase> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();

  @override
  void dispose() {
    _emailFN.dispose();
    _passwordFN.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus =
        model.emailValidator.isValid(model.email) ? _passwordFN : _emailFN;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      focusNode: _passwordFN,
      onChanged: (password) => widget.bloc.updatePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          enabled: model.isLoading == false,
          labelText: 'Password',
          errorText: model.passwordErrorText),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      autocorrect: false,
      focusNode: _emailFN,
      onChanged: (email) => widget.bloc.updateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
      decoration: InputDecoration(
          enabled: model.isLoading == false,
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}