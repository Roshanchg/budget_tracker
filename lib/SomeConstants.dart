import 'dart:ui';

import 'package:flutter/material.dart';

const String APPNAME = "Serene Finance";
const Color PRIMARYCOLOR = Color(0xff6750A4);
const Color APPBAR_BACKGROUNDCOLOR = Color(0xffF7F7F7);

const Color GREENFOREGROUND = Color(0xff15803D);
const Color GREENBACKGROUND = Color(0xffDCFCE7);

const Color REDFOREGROUND = Color(0xffBA1A1A);
const Color REDBACKGROUND = Color(0xffFFDAD6);

const Color YELLOWFOREGROUND = Color(0xff765B00);
const Color YELLOWBACKGROUND = Color(0x7CFFDF93);

const Color PURPLEFOREGROUND = PRIMARYCOLOR;
const Color PURPLEBACKGROUND = Color(0xffE1D4FD);

const Color PINKFOREGROUND = Color(0xffBE185D);
const Color PINKBACKGROUND = Color(0xffFCE7F3);

const Color BLUEFOREGROUND = Color(0xff1E40AF);
const Color BLUEBACKGROUND = Color(0xffDBEAFE);

const Color ORANGEFOREGROUND = Color(0xffC2410C);
const Color ORANGEBACKGROUND = Color(0xffFFEDD5);

const Color GREYFOREGROUND = Color(0xff4B5563);
const Color GREYBACKGROUND = Color(0xffF3F4F6);

const Color BOTTOMBAR_UNSELECTEDCOLOR = Color(0xff9CA3AF);

extension ScreenSize on BuildContext {
  double widthPercentage(double percentage) {
    return MediaQuery.of(this).size.width * (percentage / 100);
  }
}
