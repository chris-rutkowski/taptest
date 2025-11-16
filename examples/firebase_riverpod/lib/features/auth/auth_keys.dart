import 'package:flutter/material.dart';

abstract class RegisterKeys {
  static const _prefix = 'Register_';
  static const screen = ValueKey('${_prefix}Screen');
  static const emailField = ValueKey('${_prefix}EmailField');
  static const passwordField = ValueKey('${_prefix}PasswordField');
  static const confirmPasswordField = ValueKey('${_prefix}ConfirmPasswordField');
  static const registerButton = ValueKey('${_prefix}RegisterButton');
  static const loginInsteadTile = ValueKey('${_prefix}LoginInsteadTile');
  static const aboutTile = ValueKey('${_prefix}AboutTile');
  static const errorDialog = ValueKey('${_prefix}ErrorDialog');
  static const errorDialogMessage = ValueKey('${_prefix}ErrorMessage');
  static const errorDialogOKButton = ValueKey('${_prefix}ErrorOKButton');
}

abstract class LoginKeys {
  static const _prefix = 'Login_';
  static const screen = ValueKey('${_prefix}Screen');
  static const emailField = ValueKey('${_prefix}EmailField');
  static const passwordField = ValueKey('${_prefix}PasswordField');
  static const loginButton = ValueKey('${_prefix}LoginButton');
  static const errorDialog = ValueKey('${_prefix}ErrorDialog');
  static const errorDialogMessage = ValueKey('${_prefix}ErrorMessage');
  static const errorDialogOKButton = ValueKey('${_prefix}ErrorOKButton');
}
