import 'package:flutter/material.dart';

const _productScreenPrefix = 'ProductScreen_';

abstract class ProductScreenKeys {
  static const screen = ValueKey('${_productScreenPrefix}screen');
  static ValueKey<String> tile(int index) => ValueKey('${_productScreenPrefix}tile:$index');
}
