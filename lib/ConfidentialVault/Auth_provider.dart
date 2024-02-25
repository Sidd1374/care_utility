import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user.dart' as coUser;
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      _user = user;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save UID to shared preferences for persistence
      await prefs.setString('uid', user!.uid);

      notifyListeners();
    } catch (e) {
      // Handle specific error cases if needed
      print('Sign-in error: $e');
      // Show a snackbar or dialog to the user
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if uid is stored in shared preferences
    final uid = await prefs.getString('uid');
    return uid != null;
  }
}
