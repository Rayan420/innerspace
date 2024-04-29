// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';

class TTextTheme {
  TTextTheme._();
  static TextTheme lightTextTheme = const TextTheme(
    headline1: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: tBlackColor),
    headline2: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: tBlackColor),
    headline3: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: tBlackColor),
    headline4: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: tBlackColor),
    headline6: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: tBlackColor),
    bodyText1: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: tBlackColor),
    bodyText2: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: tBlackColor),
  );
  static TextTheme darkTextTheme = const TextTheme(
    headline1: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: tWhiteColor),
    headline2: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: tWhiteColor),
    headline3: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: tWhiteColor),
    headline4: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: tWhiteColor),
    headline6: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: tWhiteColor),
    bodyText1: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: tWhiteColor),
    bodyText2: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: tWhiteColor),
  );
}
