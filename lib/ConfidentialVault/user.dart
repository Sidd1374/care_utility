import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;

  User({required this.uid, required this.email});

  factory User.fromFirebaseUser(User user) {
    return User(uid: user.uid, email: user.email ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
