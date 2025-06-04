import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA26EeLqN3IJg8pK9PkNEOyLFk9It2cKOo",
      appId: "1:197086191664:android:2a7af6c2f7e51fb5338df5",
      messagingSenderId: "197086191664",
      projectId: "momolongo-81518",
      storageBucket: "momolongo-81518.firebasestorage.app",
    ),
  );
  final user = FirebaseAuth.instance.currentUser;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginScreen() : HomeScreen(user: user),
    ),
  );
}