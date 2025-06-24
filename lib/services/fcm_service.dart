import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'cart_manager.dart';
import 'auth_service.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final CartManager _cartManager = CartManager();
  final AuthService _authService = AuthService();

  // Inicializar FCM
  Future<void> initialize() async {
    // Solicitar permisos
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Permisos otorgados: ${settings.authorizationStatus}');

    // Configurar notificaciones locales
    await _initializeLocalNotifications();

    // Obtener token FCM
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Configurar handlers
    _configureMessageHandlers();
  }

  // Configurar notificaciones locales
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(initializationSettings);
  }

  // Configurar handlers de mensajes
  void _configureMessageHandlers() {
    // Mensaje cuando la app está en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido en foreground: ${message.data}');
      _handleMessage(message);
      _showLocalNotification(message);
    });

    // Mensaje cuando la app está en background pero abierta
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje abierto desde background: ${message.data}');
      _handleMessage(message);
    });

    // Mensaje cuando la app está completamente cerrada
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Mensaje recibido cuando app estaba cerrada: ${message.data}');
        _handleMessage(message);
      }
    });
  }

  // Manejar el mensaje recibido
  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final action = data['action'];

    switch (action) {
      case 'clear_sensitive_data':
        _clearSensitiveData();
        break;
      case 'clear_cart':
        _clearCart();
        break;
      case 'logout_user':
        _logoutUser();
        break;
      default:
        print('Acción no reconocida: $action');
    }
  }

  // Eliminar datos sensibles (simulado)
  void _clearSensitiveData() {
    print('🔒 Eliminando datos sensibles...');

    // Limpiar carrito
    _cartManager.clear();

    // Aquí podrías eliminar otros datos sensibles como:
    // - Tokens de autenticación
    // - Datos de usuario almacenados localmente
    // - Caché de información personal

    print('✅ Datos sensibles eliminados por FCM');
  }

  // Limpiar carrito específicamente
  void _clearCart() {
    print('🛒 Limpiando carrito por FCM...');
    _cartManager.clear();
    print('✅ Carrito limpiado');
  }

  // Cerrar sesión del usuario
  void _logoutUser() async {
    print('🚪 Cerrando sesión por FCM...');
    await _authService.signOut();
    _cartManager.clear();
    print('✅ Sesión cerrada');
  }

  // Mostrar notificación local
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'security_channel',
          'Seguridad',
          channelDescription: 'Notificaciones de seguridad',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'Acción de Seguridad',
      message.notification?.body ?? 'Se han eliminado datos sensibles',
      platformChannelSpecifics,
    );
  }

  // Obtener token FCM actual
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Suscribirse a un tópico
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Suscrito al tópico: $topic');
  }

  // Desuscribirse de un tópico
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Desuscrito del tópico: $topic');
  }
}

// Handler para mensajes en background (debe ser función top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensaje en background: ${message.data}');

  // Aquí puedes manejar acciones críticas incluso cuando la app está cerrada
  final action = message.data['action'];
  if (action == 'clear_sensitive_data') {
    // Lógica para limpiar datos incluso en background
    print('Limpiando datos sensibles en background');
  }
}
