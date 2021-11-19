import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import 'database_connect.dart';

import 'dart:async';

class RCXDController extends StatefulWidget {
  const RCXDController({Key? key}) : super(key: key);

  @override
  _RCXDControllerState createState() => _RCXDControllerState();
}

class _RCXDControllerState extends State<RCXDController> {
  final DatabaseConnect db = DatabaseConnect();
  int speedDirection = 0;
  double throttleLimit = 45.0;
  double engineSensor = 22.0;
  double controllerSensor = 21.0;

  @override
  void initState() {
    updateSensors();
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateSensors());
  }

  void brake(bool wait) {
    if (speedDirection == 1) {
      speedDirection = 0;
      db.updateThrottle(120);
      if (wait) sleep(const Duration(milliseconds: 250));
    } else if (speedDirection == -1) {
      // if (wait) sleep(const Duration(milliseconds: 100));
      db.updateThrottle(70);
      if (wait) sleep(const Duration(milliseconds: 150));
    }
    db.updateThrottle(90);
  }

  void updateSensors() async {
    var engineTemp = await db.getEngineSensor();
    var controllerTemp = await db.getControllerSensor();

    setState(() {
      engineSensor = engineTemp;
      controllerSensor = controllerTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                        "Engine: " + engineSensor.toStringAsFixed(2) + "°C"),
                  ),
                  Image.asset(
                    'assets/images/hot_wheels.png',
                    width: 300,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("Controller: " +
                        controllerSensor.toStringAsFixed(2) +
                        "°C"),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Speed limit:"),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(6),
                          color: throttleLimit >= 70
                              ? Colors.red
                              : (throttleLimit >= 50
                                  ? Colors.orange
                                  : (throttleLimit >= 30
                                      ? Colors.yellow
                                      : Colors.green)),
                        ),
                        child: Text(
                          throttleLimit.toString(),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: -1,
                        child: SizedBox(
                          width: 160,
                          child: Slider(
                            inactiveColor: Colors.blue[600],
                            activeColor: Colors.blue[850],
                            value: throttleLimit,
                            min: 10,
                            max: 90,
                            divisions: 16,
                            onChanged: (double value) {
                              setState(() {
                                throttleLimit = value;
                              });
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        child: Image.asset(
                          'assets/images/brake_pedal.png',
                          width: 100,
                          height: 50,
                          fit: BoxFit.scaleDown,
                        ),
                        onTap: () => {brake(false)},
                      ),
                    ],
                  ),
                  Listener(
                    onPointerUp: (details) {
                      brake(true);
                    },
                    child: Joystick(
                      mode: JoystickMode.vertical,
                      listener: (details) {
                        speedDirection = details.y >= 0 ? -1 : 1;
                        db.updateThrottle(details.y * throttleLimit + 90);
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
