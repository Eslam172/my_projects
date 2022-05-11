import 'package:first_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'jannah',
    primarySwatch: defaultColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: HexColor('#212F3D'),
    ),
    appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          fontFamily: 'jannah',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('#212F3D'),
          statusBarIconBrightness: Brightness.light),
      color: Colors.white,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.black),
      subtitle1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.3),
    ),
    scaffoldBackgroundColor: HexColor('#212F3D'));
ThemeData darkTheme = ThemeData(
  fontFamily: 'Jannah',
  scaffoldBackgroundColor: HexColor('333739'),
  primarySwatch: defaultColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      backgroundColor: HexColor('333739')),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        fontFamily: 'jannah',
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold),
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light),
    color: HexColor('333739'),
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    subtitle1: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3),
  ),
);
