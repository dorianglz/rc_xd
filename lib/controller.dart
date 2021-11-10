import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import 'database_connect.dart';

class RCXDController extends StatefulWidget {
  const RCXDController({Key? key}) : super(key: key);

  @override
  _RCXDControllerState createState() => _RCXDControllerState();
}

class _RCXDControllerState extends State<RCXDController> {
  final DatabaseConnect db = DatabaseConnect();
  bool isIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/hot_wheels.png',
                width: 300,
                height: 150,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Listener(
                    onPointerUp: (details) {
                      db.updateSteering(90);
                    },
                    child: Joystick(
                      mode: JoystickMode.horizontal,
                      listener: (details) {
                        db.updateSteering(details.x * 90 + 90);
                      },
                    ),
                  ),
                  Listener(
                    onPointerUp: (details) {
                      db.updateThrottle(90);
                    },
                    child: Joystick(
                      mode: JoystickMode.vertical,
                      listener: (details) {
                        db.updateThrottle(details.y * -1 * 90 + 90);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
