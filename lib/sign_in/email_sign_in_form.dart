// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pets/services/auth.dart';
// import 'package:pets/sign_in/email_sign_in_model.dart';
// import 'package:pets/sign_in/validators.dart';
// import 'package:pets/widgets/form_submit_button.dart';
// import 'package:pets/widgets/platform_exception_alert_dialog.dart';
// import 'package:provider/provider.dart';
//
// class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
//   @override
//   _EmailSignInFormState createState() => _EmailSignInFormState();
// }
//
// class _EmailSignInFormState extends State<EmailSignInForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _emailFN = FocusNode();
//   final FocusNode _passwordFN = FocusNode();
//
//   String get _email => _emailController.text.trim();
//   String get _password => _passwordController.text.trim();
//
//   EmailSignInFormType _formType = EmailSignInFormType.signIn;
//   bool _submitted = false;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _emailFN.dispose();
//     _passwordFN.dispose();
//     _passwordController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit() async {
//     setState(() {
//       _submitted = true;
//       _isLoading = true;
//     });
//     try {
//       final auth = Provider.of<AuthBase>(context, listen: false);
//       if (_formType == EmailSignInFormType.signIn) {
//         await auth.signInWithEmailAndPassword(_email, _password);
//       } else {
//         await auth.createUserWithEmailAndPassword(_email, _password);
//       }
//       Navigator.of(context).pop();
//     } on PlatformException catch (e) {
//       if (Platform.isIOS) {
//       } else {
//         PlatformExceptionAlertDialog(
//           title: 'Sign in failed',
//           exception: e,
//         ).show(context);
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _emailEditingComplete() {
//     final newFocus =
//         widget.emailValidator.isValid(_email) ? _passwordFN : _emailFN;
//     FocusScope.of(context).requestFocus(_passwordFN);
//   }
//
//   void _toggleFormType() {
//     setState(() {
//       _formType = _formType == EmailSignInFormType.signIn
//           ? EmailSignInFormType.register
//           : EmailSignInFormType.signIn;
//       _submitted = false;
//     });
//     _emailController.clear();
//     _passwordController.clear();
//   }
//
//   List<Widget> _buildChildren() {
//     final primaryText = _formType == EmailSignInFormType.signIn
//         ? 'Sign in'
//         : 'Create an account';
//     final secondaryText = _formType == EmailSignInFormType.signIn
//         ? 'Need an account? Register'
//         : 'Have an account? Sign in';
//
//     bool submitEnabled = widget.emailValidator.isValid(_email) &&
//         widget.passwordValidator.isValid(_password) &&
//         !_isLoading;
//
//     return [
//       _buildEmailTextField(),
//       SizedBox(
//         height: 8.0,
//       ),
//       _buildPasswordTextField(),
//       SizedBox(
//         height: 8.0,
//       ),
//       FormSubmitButton(
//         text: primaryText,
//         onPressed: submitEnabled ? _submit : null,
//       ),
//       SizedBox(
//         height: 8.0,
//       ),
//       FlatButton(
//         child: Text(secondaryText),
//         onPressed: !_isLoading ? _toggleFormType : null,
//       )
//     ];
//   }
//
//   TextField _buildPasswordTextField() {
//     bool showPasswordErrorText =
//         _submitted && !widget.passwordValidator.isValid(_password);
//     return TextField(
//       controller: _passwordController,
//       obscureText: true,
//       focusNode: _passwordFN,
//       onChanged: (password) => _updateState(),
//       textInputAction: TextInputAction.done,
//       decoration: InputDecoration(
//           enabled: _isLoading == false,
//           labelText: 'Password',
//           errorText:
//               showPasswordErrorText ? widget.invalidPasswordErrorText : null),
//       onEditingComplete: _submit,
//     );
//   }
//
//   TextField _buildEmailTextField() {
//     bool showEmailErrorText =
//         _submitted && !widget.emailValidator.isValid(_email);
//     return TextField(
//       controller: _emailController,
//       autocorrect: false,
//       focusNode: _emailFN,
//       onChanged: (email) => _updateState(),
//       keyboardType: TextInputType.emailAddress,
//       textInputAction: TextInputAction.next,
//       onEditingComplete: _emailEditingComplete,
//       decoration: InputDecoration(
//           enabled: _isLoading == false,
//           labelText: 'Email',
//           hintText: 'test@test.com',
//           errorText: showEmailErrorText ? widget.invalidEmailErrorText : null),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: _buildChildren(),
//       ),
//     );
//   }
//
//   void _updateState() {
//     setState(() {});
//   }
// }