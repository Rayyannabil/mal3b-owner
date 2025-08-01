import 'package:flutter/material.dart';
import 'package:mal3b/helpers/screen_helper.dart';

double getButtonHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 40; // very small phones
  if (ScreenHelper.isSm(context)) return 44; // small phones
  if (ScreenHelper.isMd(context)) return 48; // medium-large phones
  return 56; // large phones / phablets
}

double getFontTitleSize(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 16; // Very small phones
  if (ScreenHelper.isSm(context)) return 18; // Small phones
  if (ScreenHelper.isMd(context)) return 20; // Medium phones
  return 24; // Large phones / phablets
}

double getFontSubTitleSize(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 12; // Very small phones
  if (ScreenHelper.isSm(context)) return 14; // Small phones
  if (ScreenHelper.isMd(context)) return 16; // Medium phones
  return 20; // Large phones / phablets
}

double getIconWidth(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 25; // Very small phones
  if (ScreenHelper.isSm(context)) return 28; // Small phones
  if (ScreenHelper.isMd(context)) return 32; // Medium phones
  return 40; // Large phones / phablets
}

double getImageHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 130; // Very small phones
  if (ScreenHelper.isSm(context)) return 180; // Small phones
  if (ScreenHelper.isMd(context)) return 230; // Medium phones
  return 310; // Large phones / phablets
}

double getProfileImageWidth(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 80; // Very small phones
  if (ScreenHelper.isSm(context)) return 120; // Small phones
  if (ScreenHelper.isMd(context)) return 180; // Medium phones
  return 350; // Large phones / phablets (max width)
}

double getImageLandingHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 240; // Very small phones
  if (ScreenHelper.isSm(context)) return 320; // Small phones
  if (ScreenHelper.isMd(context)) return 420; // Medium phones
  return 540; // Large phones / phablets
}

double getVerticalSpace(BuildContext context, double space) {
  if (ScreenHelper.isXs(context)) return space * 0.5; // Very small phones
  if (ScreenHelper.isSm(context)) return space * 0.75; // Small phones
  if (ScreenHelper.isMd(context)) return space; // Medium phones
  return space * 1.25; // Large phones / phablets
}

double getHorizontalSpace(BuildContext context, double space) {
  if (ScreenHelper.isXs(context)) return space * 0.5; // Very small phones
  if (ScreenHelper.isSm(context)) return space * 0.75; // Small phones
  if (ScreenHelper.isMd(context)) return space; // Medium phones
  return space * 1.25; // Large phones / tablets
}
