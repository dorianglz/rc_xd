import 'package:firebase_database/firebase_database.dart';

class DatabaseConnect {
  final databaseReference = FirebaseDatabase.instance.reference();

  void update(obj) {
    databaseReference.child('controls_2').set(obj);
  }

  void updateSteering(value) {
    databaseReference.child('controls_2').update({'steering': value});
  }

  void updateThrottle(value) {
    databaseReference.child('controls_2').update({'throttle': value});
  }
}
