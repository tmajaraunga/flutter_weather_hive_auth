import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;

  Future<void> signInAnonymouslyIfNeeded() async {
    // If there is already a user, do nothing.
    if (_auth.currentUser != null) {
      return;
    }
    // If there is no user, sign in anonymously.
    try {
      await _auth.signInAnonymously();
      notifyListeners(); // Notify listeners that the user state has changed
    } catch (e) {
      // Handle any potential errors during anonymous sign-in
      print('Failed to sign in anonymously: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }


  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }


  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}