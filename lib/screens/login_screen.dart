import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Iniciar sesión con Google"),
          onPressed: () async {
            final user = await authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
              );
            }
          },
        ),
      ),
    );
  }
}
