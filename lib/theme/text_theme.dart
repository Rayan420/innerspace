// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innerspace/constants/colors.dart';

class TTextTheme {
  TTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: tBlackColor),
    headline2: GoogleFonts.montserrat(
        color: tBlackColor, fontSize: 24, fontWeight: FontWeight.w700),
    headline3: GoogleFonts.poppins(
        color: tBlackColor, fontSize: 24, fontWeight: FontWeight.w700),
    headline4: GoogleFonts.poppins(
        color: tBlackColor, fontSize: 16, fontWeight: FontWeight.w600),
    headline6: GoogleFonts.poppins(
        color: tBlackColor, fontSize: 14, fontWeight: FontWeight.w600),
    bodyText1: GoogleFonts.poppins(
        color: tBlackColor, fontSize: 14, fontWeight: FontWeight.normal),
    bodyText2: GoogleFonts.poppins(
        color: tBlackColor, fontSize: 14, fontWeight: FontWeight.normal),
  );
  static TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline2: GoogleFonts.montserrat(
        color: tWhiteColor, fontSize: 24, fontWeight: FontWeight.w700),
    headline3: GoogleFonts.poppins(
        color: tWhiteColor, fontSize: 24, fontWeight: FontWeight.w700),
    headline4: GoogleFonts.poppins(
        color: tWhiteColor, fontSize: 16, fontWeight: FontWeight.w600),
    headline6: GoogleFonts.poppins(
        color: tWhiteColor, fontSize: 14, fontWeight: FontWeight.w600),
    bodyText1: GoogleFonts.poppins(
        color: tWhiteColor, fontSize: 14, fontWeight: FontWeight.normal),
    bodyText2: GoogleFonts.poppins(
        color: tWhiteColor, fontSize: 14, fontWeight: FontWeight.normal),
  );
}
