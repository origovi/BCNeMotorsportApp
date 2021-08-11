import 'dart:math';

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:bcnemotorsportapp/pages/PageError.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// To be able to call this function with a code error
void errorScreen(BuildContext context, [String errorMessage]) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    return PageError(errorMessage);
  }));
}

class Popup {
  static void loadingPopup(BuildContext context, [bool dismissible = false]) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static void errorPopup(BuildContext context, [String errorMessage = "Unexpected error"]) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Dismiss"),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void warningPopup(BuildContext context,
      {String title = "Warning", String message = "Unexpected error"}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Dismiss"),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> fancyPopup(
      {@required BuildContext context,
      @required List<Widget> children,
      CrossAxisAlignment columnCrossAlignment = CrossAxisAlignment.center,
      bool barrierDismissible = true,
      bool symmetricMargin = false,
      bool symmetricPadding = false}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: symmetricMargin ? 0 : 150),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(top: symmetricPadding ? 7 : 20, left: 20, right: 20, bottom: 7),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: columnCrossAlignment,
                    children: children),
              ),
            ),
          ),
        );
      },
      barrierDismissible: barrierDismissible,
    );
  }

  static void twoOptionsPopup(BuildContext context,
      {String title = "Warning",
      String message = "Unexpected error",
      String text1 = "Yes",
      Color color1,
      String text2 = "Cancel",
      bool barrierDismissible = true,
      @required void Function() onPressed1,
      void Function() onPressed2}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: onPressed1,
            child: Text(text1),
            color: color1,
          ),
          FlatButton(
            onPressed: onPressed2 ?? Navigator.of(context).pop,
            child: Text(text2),
          )
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}

class Functions {
  static int lcs(String x, String y) {
    List<List<int>> table = List<List<int>>.filled(x.length + 1, List<int>.filled(y.length + 1, 0));

    for (int i = 0; i <= x.length; i++) {
      for (int j = 0; j <= y.length; j++) {
        if (i == 0 || j == 0)
          table[i][j] = 0;
        else if (x[i - 1] == y[j - 1])
          table[i][j] = table[i - 1][j - 1] + 1;
        else
          table[i][j] = max(table[i - 1][j], table[i][j - 1]);
      }
    }
    return table[x.length][y.length];
  }

  static num abs(num x) {
    if (x < 0.0) return -x;
    return x;
  }

  static num min(num x, num y) {
    if (x < y) return x;
    return y;
  }

  static num max(num x, num y) {
    if (x > y) return x;
    return y;
  }

  static bool validEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static String randomID(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

Future<void> changeSystemUi(
    {Color navBarColor,
    Color statusBarColor,
    Brightness statusBarBrightness,
    Brightness navBarBrightness,
    int milliDelay = 50}) async {
  await Future.delayed(Duration(milliseconds: milliDelay));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: statusBarBrightness,
    statusBarColor: statusBarColor,
    systemNavigationBarDividerColor: navBarColor,
    systemNavigationBarColor: navBarColor,
    systemNavigationBarIconBrightness: navBarBrightness,
  ));
}

SystemUiOverlayStyle uiStyleByColor(Color navColor) => SystemUiOverlayStyle(
      systemNavigationBarDividerColor: navColor,
      systemNavigationBarColor: navColor,
    );

Future<PickedFile> pickGalleryImage() async {
  try {
    return await ImagePicker().getImage(source: ImageSource.gallery);
  } on PlatformException {
    return null;
  }
}

void snackMessage3Secs(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ),
  );
}

void snackDatabaseUpdated(BuildContext context) {
  snackMessage3Secs(context, "Changes have been updated");
}

// Used when user have to sign in/up at AuthScreen.dart
InputDecoration signInFormDecoration(String hintText) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400], width: 2.0)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
  );
}

// Transform a timestamp to a fancy string
String formatDatePhrase(DateTime d) {
  DateTime now = DateTime.now();
  bool isYesterday(DateTime d2) {
    final DateTime yesterday = now.subtract(Duration(days: 1));
    return yesterday.day == d2.day && yesterday.month == d2.month && yesterday.year == d2.year;
  }

  String s;
  Duration diferencia = now.difference(d);
  if (diferencia.inDays < 1) {
    s = formatTime(d);
    if (diferencia.inMinutes < 5)
      s = "Just now";
    else if (diferencia.inMinutes < 60)
      s = "A while ago";
    else if (isYesterday(d)) s = "Yesterday";
  } else if (isYesterday(d))
    s = "Yesterday";
  else
    s = formatDate(d, yearWhenNecessary: true, short: true);
  return s;
}

String formatEventDates(DateTime t1, DateTime t2, bool allDay) {
  bool showYear = t1.year != t2.year;
  String t1Format = formatDate(t1, year: showYear);
  String t2Format = formatDate(t2, year: showYear);

  String res = t1Format;
  // Intradia
  if (t1Format == t2Format) {
    if (!allDay) {
      res += "  ·  " + formatTime(t1) + "  -  " + formatTime(t2);
    }
  } else {
    if (!allDay) {
      res += "  ·  " +
          formatTime(t1) +
          "  -\n" +
          formatDate(t2, year: showYear) +
          "  ·  " +
          formatTime(t2);
    } else {
      res += "  -  " + formatDate(t2, year: showYear);
    }
  }
  return res;
}

String formatDate(DateTime t, {bool short = false, bool year = true, bool month = true, bool yearWhenNecessary = false}) {
  String res = "";
  if (short) {
    res += Dates.daysShort[t.weekday - 1] + ", ";
    res += t.day.toString();
    if (month) res += " " + Dates.monthsShort[t.month - 1].toLowerCase();
  } else {
    res += Dates.days[t.weekday - 1] + ", ";
    res += t.day.toString();
    if (month) res += " " + Dates.months[t.month - 1].toLowerCase();
  }
  if (yearWhenNecessary) year = DateTime.now().year != t.year;
  if (year) res += ", " + t.year.toString();
  return res;
}

String formatTime(DateTime t) {
  String res = "";
  if (t.hour < 10) res += "0";
  res += t.hour.toString() + ":";
  if (t.minute < 10) res += "0";
  res += t.minute.toString();
  return res;
}

Future<DateTime> pickDate(BuildContext context,
    {DateTime initialDate, DateTime firstDate, DateTime lastDate}) async {
  DateTime aux = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime.now().subtract(Duration(days: 730)),
    lastDate: lastDate ?? DateTime.now().add(Duration(days: 548)),
    locale: const Locale('en', 'GB'),
  );
  if (aux == null) return null;
  else return DateTime(aux.year, aux.month, aux.day, initialDate.hour, initialDate.minute);
}

Future<DateTime> pickTime(BuildContext context, DateTime initialDate) async {
  TimeOfDay aux = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );
  if (aux == null) return initialDate;
  return DateTime(initialDate.year, initialDate.month, initialDate.day, aux.hour, aux.minute);
}

class Pair<T, Y> {
  T first;
  Y second;
  Pair(this.first, this.second);
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40.0;
    Path p = Path();
    p.moveTo(0, radius);
    p.quadraticBezierTo(0, 0, radius, 0);
    p.lineTo(size.width - radius, 0);
    p.quadraticBezierTo(size.width, 0, size.width, radius);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class NoGlowEffect extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
