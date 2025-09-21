import 'package:flutter/material.dart';

const _prefix = 'Welcome_';

abstract class WelcomeKeys {
  static const screen = ValueKey('${_prefix}screen');
  static const loginButton = ValueKey('${_prefix}loginButton');
  static const registerButton = ValueKey('${_prefix}registerButton');
  static const longButton = ValueKey('${_prefix}longButton');
  static const httpButton = ValueKey('${_prefix}httpButton');
}
