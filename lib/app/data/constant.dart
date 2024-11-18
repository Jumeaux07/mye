import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';

const baseUrl = "https://mye.franckprod.com/api";
const registerUrl = "/user/register/step1";
const verifyOtpCodeUrl = "/user/otp_verify";
const loginUrl = "/login";

const getSecteurUrl = "/get-all-secteurs";

const focusedBorderColor = Color(0xFFCBA948);
const fillColor = Color.fromRGBO(243, 246, 249, 0);
const borderColor = Color(0xFFCBA948);
const orColor = Color(0xFFCBA948);

GetStorage box = GetStorage();

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
    fontSize: 22,
    color: Color.fromRGBO(30, 60, 87, 1),
  ),
  decoration: BoxDecoration(
    border: Border.all(color: borderColor),
  ),
);

const mapsToken = "pk.22cea6c61d7cd26bad1424434572ed85";
