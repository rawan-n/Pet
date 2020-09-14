import 'package:flutter/material.dart';
import 'package:pets/widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16.0),
          ),
          color: color,
          borderRadius: 16.0,
          onPressed: onPressed,
        );
}