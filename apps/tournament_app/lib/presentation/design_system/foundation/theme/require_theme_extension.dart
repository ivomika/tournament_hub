import 'package:flutter/material.dart';

T requireThemeExtension<T>(ThemeData theme) {
  final value = theme.extension<T>();
  if (value == null) {
    throw StateError('Основная ThemeData не содержит extension $T');
  }
  return value;
}
