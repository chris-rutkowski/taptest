import 'package:flutter/material.dart';

const _prefix = 'Http_';

abstract class HttpKeys {
  static const screen = ValueKey('${_prefix}screen');
  static const list = ValueKey('${_prefix}list');
  static ValueKey<String> cell(int index) => ValueKey('${_prefix}cell:$index');
  static const cellTitle = ValueKey('${_prefix}cellTitle');
}
