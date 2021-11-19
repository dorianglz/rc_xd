import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';

class DatabaseConnect {
  static const String refControls = 'controls';
  static const String refSensors = 'sensors';

  final databaseReference = FirebaseDatabase.instance.reference();

  void update(obj) {
    databaseReference.child(refControls).set(obj);
  }

  void updateSteering(value) {
    databaseReference.child(refControls).update({'steering': value});
  }

  void updateThrottle(value) {
    databaseReference.child(refControls).update({'throttle': value});
  }

  Future<double> getEngineSensor() async {
    var temperature = 0.0;
    await databaseReference
        .child(refSensors + "/first")
        .get()
        .then((value) => temperature = value.value);
    return temperature.toDouble();
  }

  Future<double> getControllerSensor() async {
    var temperature = 0.0;
    await databaseReference
        .child(refSensors + "/second")
        .get()
        .then((value) => temperature = value.value);
    return temperature.toDouble();
  }
}
