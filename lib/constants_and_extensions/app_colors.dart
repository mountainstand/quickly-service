import 'package:flutter/material.dart';

class AppColors {
  //Shared Instance
  AppColors._sharedInstance() : super();
  static final AppColors _shared = AppColors._sharedInstance();
  factory AppColors() => _shared;

  final primary = Color(0xFF552CFF);

  final blackTwo = Color(0xFF181818);
  final blackThree = Color(0xFF17191E);

  final whiteTwo = Color(0xFFF2F2F2);

  final lighterGray = Color(0xFFF7F7F7);
  final lightGray = Color(0xFFECECEC);
  final gray = Color(0xFF8B8B8B);
  final darkGray = Color(0xFF595959);
  final darkerGrey = Color(0xFF2E3034);

  final borderColor = Color(0xFF323232);

  final orange = Color(0xFFF37A01);
  final darkGreen = Color(0xFF377E36);
  final green = Color(0xFF24C500);
  final lightGreen = Color(0xFFE0F0E4);

  final lightRed = Color(0xFFFEECEB);
  final red = Color(0xFFF15550);
  final darkRed = Color(0xFFC61F43);
  final darkerRed = Color(0xFFB12F30);

  final pink = Color(0xFFC20EF7);
  final darkBlue = Color(0xFF0125F3);

  final yellow = Color(0xFFFFCC18);
}
