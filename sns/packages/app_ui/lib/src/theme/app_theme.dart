import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// App theme.
abstract class AppTheme {
  /// Light theme.
  static ThemeData get theme => FlexThemeData.light(
        scheme: FlexScheme.shark,
      );

  /// Dark theme.
  static ThemeData get darkTheme => FlexThemeData.dark(
        scheme: FlexScheme.shark,
      );
}
