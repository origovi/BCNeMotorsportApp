import 'package:bcnemotorsportapp/screens/ScreenWithLogo.dart';
import 'package:flutter/material.dart';

class PageError extends StatelessWidget {
  final String _errorMessage;
  const PageError([this._errorMessage]);

  @override
  Widget build(BuildContext context) {
    return ScreenWithLogo(Text(
      this._errorMessage,
      style: TextStyle(color: Colors.white),
    ));
  }
}
