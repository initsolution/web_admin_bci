import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_button_theme.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_color_scheme.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_sidebar_theme.dart';

const Color kPrimaryColor = Color(0xFF347BDE);
const Color kSecondaryColor = Color(0xFF6C757D);
const Color kErrorColor = Color(0xFFDC3545);
const Color kSuccessColor = Color(0xFF08A158);
const Color kInfoColor = Color(0xFF17A2B8);
const Color kWarningColor = Color(0xFFFFc107);

const Color kTextColor = Color(0xFF2A2B2D);

const Color kScreenBackgroundColor = Color(0xFFF4F6F9);

const Color kDataTableHeaderColor = Color(0xFFF1F3F9);

class AppThemeData {
  AppThemeData._();

  static final AppThemeData _instance = AppThemeData._();

  static AppThemeData get instance => _instance;

  ThemeData light() {
    final themeData = ThemeData(
      checkboxTheme: const CheckboxThemeData(
        checkColor: MaterialStatePropertyAll(Colors.white),
        fillColor: MaterialStatePropertyAll(Colors.lightBlue)
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: kScreenBackgroundColor,
      drawerTheme: const DrawerThemeData(
          backgroundColor: kPrimaryColor), //sidebar background
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: kPrimaryColor,
        onPrimary: Colors.white,
        secondary: kSecondaryColor,
        onSecondary: Colors.white,
        error: kErrorColor,
        onError: Colors.white,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      cardTheme: const CardTheme(
        margin: EdgeInsets.zero,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(kDataTableHeaderColor),
        headingTextStyle:
            const TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
      ),
    );

    final appColorScheme = AppColorScheme(
      primary: kInfoColor, //setting selected item
      secondary: kSecondaryColor,
      error: kErrorColor,
      success: kSuccessColor,
      info: kInfoColor,
      warning: kWarningColor,
      hyperlink: const Color(0xFF0074CC),
      buttonTextBlack: kTextColor,
      buttonTextDisabled: kTextColor.withOpacity(0.38),
    );

    final appSidebarTheme = AppSidebarTheme(
      backgroundColor: themeData.drawerTheme.backgroundColor!,
      foregroundColor: Colors.white, //default textcolor sidebar
      sidebarWidth: 304.0,
      sidebarLeftPadding: kDefaultPadding,
      sidebarTopPadding: kDefaultPadding,
      sidebarRightPadding: kDefaultPadding,
      sidebarBottomPadding: kDefaultPadding,
      headerUserProfileRadius: 20.0,
      headerUsernameFontSize: 14.0,
      headerTextButtonFontSize: 14.0,
      menuFontSize: 14.0,
      menuBorderRadius: 5.0,
      menuLeftPadding: 0.0,
      menuTopPadding: 2.0,
      menuRightPadding: 0.0,
      menuBottomPadding: 2.0,
      menuHoverColor: Colors.white.withOpacity(0.2),
      menuSelectedFontColor: Colors.yellow, //selected textcolor sidebar
      menuSelectedBackgroundColor: appColorScheme.primary,
      menuExpandedBackgroundColor: Colors.white.withOpacity(0.1),
      menuExpandedHoverColor: Colors.white.withOpacity(0.1),
      menuExpandedChildLeftPadding: 4.0,
      menuExpandedChildTopPadding: 2.0,
      menuExpandedChildRightPadding: 4.0,
      menuExpandedChildBottomPadding: 2.0,
    );

    return themeData.copyWith(
      textTheme: themeData.textTheme.apply(
        bodyColor: kTextColor,
        displayColor: kTextColor,
      ),
      extensions: [
        AppButtonTheme.fromAppColorScheme(appColorScheme),
        appColorScheme,
        AppDataTableTheme.fromTheme(themeData),
        appSidebarTheme,
      ],
    );
  }
}
