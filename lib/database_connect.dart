import 'package:firebase_database/firebase_database.dart';

class DatabaseConnect {
  static const String ref = 'controls_2';

  final databaseReference = FirebaseDatabase.instance.reference();

  void update(obj) {
    databaseReference.child(ref).set(obj);
  }

  void updateSteering(value) {
    databaseReference.child(ref).update({'steering': value});
  }

  void updateThrottle(value) {
    databaseReference.child(ref).update({'throttle': value});
  }
}
