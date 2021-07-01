import 'package:flutter/material.dart';

class TeamColor {
  static const Color teamColor = Color.fromARGB(255, 0x04, 0x34, 0x64);
  static final MaterialColor materialTeamColor = MaterialColor(_colorARGB, _color);
  static const int _colorARGB = 0xFF043464;
  static final Map<int, Color> _color = {
    50: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.1),
    100: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.2),
    200: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.3),
    300: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.4),
    400: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.5),
    500: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.6),
    600: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.7),
    700: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.8),
    800: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 0.9),
    900: Color.fromRGBO(teamColor.red, teamColor.green, teamColor.blue, 1.0)
  };
}

class Phrases {
  static const String intruderTitle = "Oops...";
  static const String intruderMessage =
      "You do not have access to this application. If you think this is an error, please contact your friendliest TL. If you are from another team we wish you the best to the competitions.";
}
