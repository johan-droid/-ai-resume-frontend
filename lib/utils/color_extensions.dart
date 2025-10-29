import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Compat helper to replace deprecated `withOpacity` calls.
  ///
  /// Converts opacity (0.0 - 1.0) to an ARGB color using integer alpha
  /// to avoid the analyzer deprecation for `withOpacity` while preserving
  /// the same visual result.
  Color withOpacityCompat(double opacity) {
    final int a = (opacity * 255).round().clamp(0, 255);
    return withAlpha(a);
  }
}
