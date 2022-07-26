import 'dart:async';
import 'dart:convert';

import 'package:bcnemotorsportapp/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PageXalocController extends StatefulWidget {
  PageXalocController();

  @override
  _PageXalocControllerState createState() => _PageXalocControllerState();
}

class _PageXalocControllerState extends State<PageXalocController> {
  double dAngle = 0.0;
  double angle = 0.0;
  double factor = 0.5;

  Timer tSteering, tBuzzers, tLights;

  bool yellowASSIActivated = false;
  bool blueASSIActivated = false;
  bool yellowASSIAntActivated = false;
  bool blueASSIAntActivated = false;

  bool buzzer0Sounding = false;
  bool buzzer1Sounding = false;
  bool buzzer0AntSounding = false;
  bool buzzer1AntSounding = false;

  bool accelerating = false;
  bool braking = false;

  @override
  void initState() {
    super.initState();
    tSteering = Timer.periodic(Duration(milliseconds: 200), (Timer t) => periodicSteeringFunc());
    tBuzzers = Timer.periodic(Duration(milliseconds: 200), (Timer t) => periodicBuzzersFunc());
    tLights = Timer.periodic(Duration(milliseconds: 200), (Timer t) => periodicLightsFunc());
  }

  void periodicSteeringFunc() {
    if (dAngle != 0.0) {
      setState(() {
        angle += dAngle;
        if (angle > 23)
          angle = 23;
        else if (angle < -23) angle = -23;
      });
      try {
        post(
          Uri.parse('http://192.168.140.101:5000/steering'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'token': 'dkckdkdkdkdkdae34d'
          },
          body: jsonEncode({'degrees': angle}),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void periodicBuzzersFunc() {
    if (buzzer0Sounding != buzzer0AntSounding || buzzer1Sounding != buzzer1AntSounding) {
      buzzer0AntSounding = buzzer0Sounding;
      buzzer1AntSounding = buzzer1Sounding;
      try {
        post(
          Uri.parse('http://192.168.140.101:5000/buzzers'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'token': 'dkckdkdkdkdkdae34d'
          },
          body: jsonEncode({
            'buzzerState0': buzzer0Sounding ? "on" : "off",
            'buzzerState1': buzzer1Sounding ? "on" : "off",
          }),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void periodicLightsFunc() {
    if (yellowASSIActivated != yellowASSIAntActivated ||
        blueASSIActivated != blueASSIAntActivated) {
      yellowASSIAntActivated = yellowASSIActivated;
      blueASSIAntActivated = blueASSIActivated;
      try {
        post(
          Uri.parse('http://192.168.140.101:5000/lights'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'token': 'dkckdkdkdkdkdae34d'
          },
          body: jsonEncode({
            'yellowASSI': yellowASSIActivated ? "on" : "off",
            'blueASSI': blueASSIActivated ? "on" : "off",
          }),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void sendThrottle(int throttle) {
    try {
      post(
        Uri.parse('http://192.168.140.101:5000/throttle'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': 'dkckdkdkdkdkdae34d'
        },
        body: jsonEncode({
          'throttle': throttle,
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xaloc Controller"),
        brightness: Brightness.dark,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTapDown: (details) => yellowASSIActivated = true,
                  onTapUp: (details) => yellowASSIActivated = false,
                  child: Icon(Icons.lightbulb_sharp, size: 50, color: Colors.yellow[800]),
                ),
                GestureDetector(
                  onTapDown: (details) => blueASSIActivated = true,
                  onTapUp: (details) => blueASSIActivated = false,
                  child: Icon(Icons.lightbulb_sharp, size: 50, color: Colors.blue),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTapDown: (details) => buzzer0Sounding = true,
                  onTapUp: (details) => buzzer0Sounding = false,
                  child: Icon(Icons.volume_down, size: 50, color: TeamColor.teamColor),
                ),
                GestureDetector(
                  onTapDown: (details) => buzzer1Sounding = true,
                  onTapUp: (details) => buzzer1Sounding = false,
                  child: Icon(Icons.volume_up, size: 50, color: TeamColor.teamColor),
                ),
              ],
            ),
            Column(
              children: [
                Text("Precision: " + factor.toStringAsFixed(1), style: TextStyle(fontSize: 18)),
                Slider(
                  onChanged: (value) {
                    setState(() {
                      factor = value;
                    });
                  },
                  value: factor,
                  max: 5,
                  min: 0.5,
                ),
                SizedBox(height: 25),
                Text("Degrees: " + angle.toStringAsFixed(2), style: TextStyle(fontSize: 18)),
                Slider(
                  inactiveColor: TeamColor.teamColor,
                  activeColor: TeamColor.teamColor,
                  onChanged: (value) {
                    setState(() {
                      dAngle = value;
                    });
                  },
                  onChangeEnd: (value) {
                    setState(() {
                      dAngle = 0.0;
                    });
                  },
                  value: dAngle,
                  max: 1 * factor,
                  min: -1 * factor,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    if (braking) {
                      setState(() {
                        braking = false;
                        sendThrottle(0);
                      });
                    } else if (!accelerating) {
                      setState(() {
                        accelerating = true;
                        sendThrottle(1);
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_circle_up_outlined),
                  iconSize: 65,
                  color: accelerating ? Colors.green : TeamColor.teamColor,
                ),
                IconButton(
                  onPressed: () {
                    if (accelerating) {
                      setState(() {
                        accelerating = false;
                        sendThrottle(0);
                      });
                    } else if (!braking) {
                      setState(() {
                        braking = true;
                        sendThrottle(-1);
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_circle_down_outlined),
                  iconSize: 65,
                  color: braking ? Colors.red : TeamColor.teamColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tSteering.cancel();
    tBuzzers.cancel();
    tLights.cancel();
    super.dispose();
  }
}
