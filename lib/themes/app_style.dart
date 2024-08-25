import 'package:flutter/material.dart';

const double kBorder = 12.0;

const double kheigth = 12.0;

const Color kGreen = Color(0xff387038);

final primarySwatch = <int, Color>{
  50: kGreen.withOpacity(.1),
  100: kGreen.withOpacity(.2),
  200: kGreen.withOpacity(.3),
  300: kGreen.withOpacity(.4),
  400: kGreen.withOpacity(.5),
  500: kGreen.withOpacity(.6),
  600: kGreen.withOpacity(.7),
  700: kGreen.withOpacity(.8),
  800: kGreen.withOpacity(.9),
  900: kGreen
};

final mainColor = MaterialColor(0xFF387038, primarySwatch);
const secondaryColor = Color(0xFFE8563B);

const Color kRed = Color(0xffE8563B);

const double kroundebdBorder = 25;

const Color cGreyLight = Color(0xffCACACA);

Color cGrey = Colors.grey.shade500;

//Button style
const textButtonThemeData = TextButtonThemeData(style: ButtonStyle());

// theme text
const  textTheme = TextTheme();

const btnLabelStyle = TextStyle(
  fontSize: 20,
  color: kRed,
  fontWeight: FontWeight.w500,
);

const signStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

const otpStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: kGreen,
);

const commonColor = Color(0xFF9B9B9B);

const qrCodeStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: kGreen,
);

const userNameStyle = TextStyle(
  fontWeight: FontWeight.w500,
);

const moneytyle = TextStyle(
  fontWeight: FontWeight.w800,
  color: kRed,
  fontSize: 15,
);

const drawerTextStyle = TextStyle(
  fontWeight: FontWeight.w800,
  color: Colors.white,
);

const showModaltitleTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 15,
);
