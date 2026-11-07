import 'package:flutter/material.dart';

abstract final class ThemeExtensions {
  static T require<T>(ThemeData theme) {
    final value = theme.extension<T>();
    if (value == null) {
      throw StateError('Основная ThemeData не содержит extension $T');
    }
    return value;
  }
}
