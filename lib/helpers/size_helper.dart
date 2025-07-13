import 'package:flutter/material.dart';
import 'package:mal3b/helpers/screen_helper.dart';

double getButtonHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 40; // very small phones
  if (ScreenHelper.isSm(context)) return 44; // small phones
  if (ScreenHelper.isMd(context)) return 48; // medium-large phones
  return 56; // large phones / phablets
}

double getFontTitleSize(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 14; // Very small phones
  if (ScreenHelper.isSm(context)) return 16; // Small phones
  if (ScreenHelper.isMd(context)) return 18; // Medium phones
  return 20; // Large phones / phablets
}

double getFontSubTitleSize(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 10; // Very small phones
  if (ScreenHelper.isSm(context)) return 12; // Small phones
  if (ScreenHelper.isMd(context)) return 14; // Medium phones
  return 18; // Large phones / phablets
}

double getLogoWidth(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 140; // Very small phones
  if (ScreenHelper.isSm(context)) return 160; // Small phones
  if (ScreenHelper.isMd(context)) return 190; // Medium phones
  return 220; // Large phones / phablets
}

double getLogoHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 110; // Very small phones
  if (ScreenHelper.isSm(context)) return 130; // Small phones
  if (ScreenHelper.isMd(context)) return 150; // Medium phones
  return 180; // Large phones / phablets
}

double getImageHeight(BuildContext context) {
  if (ScreenHelper.isXs(context)) return 250; // Very small phones
  if (ScreenHelper.isSm(context)) return 300; // Small phones
  if (ScreenHelper.isMd(context)) return 350; // Medium phones
  return 420; // Large phones / phablets
}

double getVerticalSpace(BuildContext context, double space) {
  if (ScreenHelper.isXs(context)) return space * 0.5; // Very small phones
  if (ScreenHelper.isSm(context)) return space * 0.75; // Small phones
  if (ScreenHelper.isMd(context)) return space; // Medium phones
  return space * 1.25; // Large phones / phablets
}
