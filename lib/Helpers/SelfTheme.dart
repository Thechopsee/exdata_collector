import 'package:flutter/material.dart';

class SelfTheme {
  static const Color ORANGE = Color.fromARGB(255, 255, 80, 0);
  static const Color YELLOW = Color.fromARGB(255, 255, 221, 0);
  static const Color GREEN = Color.fromARGB(255, 0, 175, 63);
  static const Color TURQUISE = Color.fromARGB(255, 0, 211, 186);
  static const Color BLUE = Color.fromARGB(255, 0, 80, 255);
  static const Color VIOLET = Color.fromARGB(255, 199, 36, 177);
  static const Color GRAY = Color.fromARGB(255, 51, 49, 50);
  static const Color BEIGE = Color.fromARGB(255, 176, 160, 152);
  static const Color DARK_GRAY = Color.fromARGB(255, 40, 40, 40);

  static ThemeData from({
    required ColorScheme colorScheme,
    TextTheme? textTheme,
  }) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    colorScheme = ColorScheme.fromSeed(seedColor: BLUE, brightness: colorScheme.brightness).copyWith(
      background: isDark ? DARK_GRAY : Colors.white,
      error: Color.fromARGB(255, 150, 0, 0),
    );

    final Color onPrimarySurfaceColor = isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    return ThemeData(
      brightness: colorScheme.brightness, // isDark ? Brightness.dark : Brightness.light,
      primaryColor: BLUE, //colorScheme.primary,
      primaryColorLight: BLUE.withOpacity(0.1),
      scaffoldBackgroundColor: isDark ? Color.fromARGB(255, 40, 40, 40) : Colors.white,
      dividerColor: isDark ? Colors.white54 : Colors.black54,
      dialogBackgroundColor: isDark ? DARK_GRAY : Colors.white,
      canvasColor: isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.white,

      dialogTheme: DialogThemeData(
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 16,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
        ),
      ),
      //errorColor: Color.fromARGB(255, 150, 0, 0),
      indicatorColor: onPrimarySurfaceColor,
      colorScheme: colorScheme,
      unselectedWidgetColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        color: isDark ? Color.fromARGB(255, 25, 25, 25) : Colors.white,
        elevation: 6,
        iconTheme: IconThemeData(
          color: BLUE,
        ),
        titleTextStyle: TextStyle(color: BLUE, fontSize: 20, fontWeight: FontWeight.w500),
        foregroundColor: BLUE,
      ),
      disabledColor: isDark ? Colors.white54 : Colors.black45,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: isDark ? Colors.white : Colors.black), // místo bodyText1
        bodyMedium: TextStyle(color: isDark ? Colors.white : Colors.black), // místo bodyText2
        bodySmall: TextStyle(color: isDark ? Colors.white : Colors.black), // místo caption
        labelLarge: TextStyle(color: isDark ? Colors.white : Colors.black), // místo button
        displayMedium: TextStyle(color: isDark ? Colors.white : Colors.black), // místo headline4
        displayLarge: TextStyle(color: isDark ? Colors.white : Colors.black), // místo headline3
        displaySmall: TextStyle(color: isDark ? Colors.white : Colors.black),
        headlineSmall: TextStyle(color: isDark ? Colors.white : Colors.black), // místo headline5
        headlineMedium: TextStyle(color: isDark ? Colors.white : Colors.black), // místo headline2
        headlineLarge: TextStyle(color: isDark ? Colors.white : Colors.black), // místo headline1
        titleMedium: TextStyle(color: isDark ? Colors.white : Colors.black), // místo subtitle1
        titleSmall: TextStyle(color: isDark ? Colors.white : Colors.black), // místo subtitle2
        titleLarge: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 28.0), // místo headline6
        labelSmall: TextStyle(color: isDark ? Colors.white : Colors.black), // místo overline
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 18.0),
        errorStyle: TextStyle(color: isDark ? Colors.red : Color.fromARGB(255, 150, 0, 0)),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.black54, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.red : Color.fromARGB(255, 150, 0, 0), width: 1.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.black54, width: 1.0),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: isDark ? Colors.white : Colors.black,
        unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
        indicator: ShapeDecoration(
          shape: Border(
            bottom: BorderSide(color: BLUE, width: 4.0),
          ),
        ),
      ),
      // buttons
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.disabled)
              ? isDark
              ? Colors.white38
              : Colors.grey.shade200
              : states.contains(MaterialState.selected)
              ? BLUE
              : isDark
              ? Colors.white70
              : Colors.black38,
        ),
        trackColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.disabled)
            ? isDark
            ? Colors.white24
            : Colors.grey.shade100
            : colorScheme.secondaryContainer),
      ),
      sliderTheme: SliderThemeData(
        thumbColor: BLUE,
        activeTrackColor: BLUE,
        inactiveTrackColor: colorScheme.secondaryContainer,
      ),

      iconTheme: IconThemeData(color: isDark ? Colors.white : colorScheme.secondary),

      buttonTheme: ButtonThemeData(
        disabledColor: isDark ? Colors.white70 : Colors.black38,
        minWidth: 60,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(BLUE),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(colorScheme.secondary)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle()),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: BLUE,
        foregroundColor: Colors.white,
      ),
      useMaterial3: false,
    );
  }
}

extension HexColor on Color {
  String toHexColorString() =>
      "#${this.red.toRadixString(16).padLeft(2, "0")}${this.green.toRadixString(16).padLeft(2, "0")}${this.blue.toRadixString(16).padLeft(2, "0")}";
}