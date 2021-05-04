import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PageError extends StatelessWidget {
  final String _errorMessage;

  PageError([this._errorMessage = "Unexpected error"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(
        child: Text("Error: $_errorMessage"),
      ),
    );
  }
}

// To be able to call this function with a code error
void errorScreen(BuildContext context, [String errorMessage]) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    return PageError(errorMessage);
  }));
}

class Popup {
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

  static void fancyPopup(
      {@required BuildContext context,
      @required List<Widget> children,
      bool barrierDismissible = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: 200),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: children),
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
      String text2 = "Cancel",
      @required void Function() onPressed1,
      @required void Function() onPressed2}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: onPressed1,
            child: Text(text1),
          ),
          FlatButton(
            onPressed: onPressed2,
            child: Text(text2),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}

Future<PickedFile> pickGalleryImage() async {
  return await ImagePicker().getImage(source: ImageSource.gallery);
}

void snackMessage3Secs(BuildContext context, String message) {
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
String formatDateTime(DateTime d) {
  bool isYesterday(DateTime d2) {
    final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == d2.day && yesterday.month == d2.month && yesterday.year == d2.year;
  }

  String formatHour(DateTime d) {
    String s = "";
    if (d.hour < 10) s += '0';
    s += d.hour.toString();
    s += ':';
    if (d.minute < 10) s += '0';
    s += d.minute.toString();
    return s;
  }

  String s;
  Duration diferencia = DateTime.now().difference(d);
  if (diferencia.inDays < 1) {
    s = formatHour(d);
    if (diferencia.inMinutes < 5)
      s = "just now";
    else if (diferencia.inMinutes < 15)
      s = "a while ago";
    else if (isYesterday(d)) s = "yesterday";
  } else if (isYesterday(d))
    s = "yesterday";
  else
    s = "${d.month}-${d.day}-${d.year}";
  return s;
}

double absDouble(double x) {
  if (x < 0.0) return -x;
  return x;
}

int absInt(int x) {
  if (x < 0.0) return -x;
  return x;
}

class Pair {
  dynamic first, second;
  Pair(this.first, this.second);
}

bool validEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String randomID(int length) {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
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
