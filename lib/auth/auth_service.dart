import 'package:firebase_auth/firebase_auth.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get user => _auth.currentUser;
  static Future<bool> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user != null;
  }

  static Future<bool> signUp(String email, String password, String createdAt,
      String subscriptionPlan, subscriptionDate) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        createdAt: createdAt,
        subscriptionPlan: subscriptionPlan,
        subscriptionDate: subscriptionDate);
    await DatabaseHelper.insertUserData(userModel);
    return credential.user != null;
  }

  static Future<void> logout() => _auth.signOut();
}
