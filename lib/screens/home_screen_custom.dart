import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'product_list_screen.dart';

class HomeScreenCustom extends StatelessWidget {
  final String userId;
  final String userRole;
  final String token;
  final AuthService authService = AuthService();

  HomeScreenCustom({
    super.key,
    required this.userId,
    required this.userRole,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${userRole.toUpperCase()}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ProductListScreen(),
    );
  }
}
