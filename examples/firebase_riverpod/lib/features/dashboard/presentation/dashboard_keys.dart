import 'package:flutter/material.dart';

abstract class DashboardKeys {
  static const _prefix = 'Dashboard_';
  static const screen = ValueKey('${_prefix}Screen');
  static const email = ValueKey('${_prefix}Email');
  static const logoutButton = ValueKey('${_prefix}LogoutButton');
  static const newMemoField = ValueKey('${_prefix}NewMemoField');
  static const noMemosTile = ValueKey('${_prefix}NoMemosTile');
  static Key memoTile(int index) => ValueKey('${_prefix}MemoTile_$index');
  static const memoText = ValueKey('${_prefix}MemoText');
  static const deleteMemoButton = ValueKey('${_prefix}DeleteMemoButton');
}
