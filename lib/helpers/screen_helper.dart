// screen_helper.dart

import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ScreenHelper {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isXs(BuildContext context) => width(context) <= Breakpoints.xs;

  static bool isSm(BuildContext context) =>
      width(context) > Breakpoints.xs && width(context) <= Breakpoints.sm;

  static bool isMd(BuildContext context) =>
      width(context) > Breakpoints.sm && width(context) <= Breakpoints.md;

  static bool isLg(BuildContext context) =>
      width(context) > Breakpoints.md && width(context) <= Breakpoints.lg;

  static bool isXl(BuildContext context) => width(context) > Breakpoints.lg;
}
