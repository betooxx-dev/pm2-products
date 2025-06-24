import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/fcm_service.dart';

// Handler para mensajes en background (debe estar aquí)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Mensaje en background: ${message.data}');

  final action = message.data['action'];
  if (action == 'clear_sensitive_data') {
    print('🔒 Limpiando datos sensibles en background');
    // Aquí puedes ejecutar lógica crítica incluso con app cerrada
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA26EeLqN3IJg8pK9PkNEOyLFk9It2cKOo",
      appId: "1:197086191664:android:2a7af6c2f7e51fb5338df5",
      messagingSenderId: "197086191664",
      projectId: "momolongo-81518",
      storageBucket: "momolongo-81518.firebasestorage.app",
    ),
  );

  // Configurar handler para mensajes en background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inicializar FCM Service
  await FCMService().initialize();

  final user = FirebaseAuth.instance.currentUser;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginScreen() : HomeScreen(user: user),
    ),
  );
}
