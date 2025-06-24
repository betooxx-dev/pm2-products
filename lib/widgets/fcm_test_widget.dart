import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/fcm_service.dart';
import '../services/cart_manager.dart';

class FCMTestWidget extends StatefulWidget {
  const FCMTestWidget({super.key});

  @override
  _FCMTestWidgetState createState() => _FCMTestWidgetState();
}

class _FCMTestWidgetState extends State<FCMTestWidget> {
  final FCMService _fcmService = FCMService();
  final CartManager _cartManager = CartManager();
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
  }

  Future<void> _loadFCMToken() async {
    final token = await _fcmService.getToken();
    setState(() {
      _fcmToken = token;
    });
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Token copiado al portapapeles')));
    }
  }

  void _simulateSecurityNotification() {
    // Llamar métodos públicos del FCMService
    _clearSensitiveData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔒 Datos sensibles eliminados por FCM simulado'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {});
  }

  void _simulateClearCart() {
    _cartManager.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛒 Carrito limpiado por FCM simulado'),
        backgroundColor: Colors.orange,
      ),
    );
    setState(() {});
  }

  // Simular eliminación de datos sensibles
  void _clearSensitiveData() {
    print('🔒 Eliminando datos sensibles...');
    _cartManager.clear();
    // Aquí puedes agregar más lógica de limpieza
    print('✅ Datos sensibles eliminados');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FCM Test Panel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Estado del carrito
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del Carrito:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Items: ${_cartManager.itemCount}'),
                  Text('Total: \$${_cartManager.total.toStringAsFixed(2)}'),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Token FCM
            if (_fcmToken != null) ...[
              Row(
                children: [
                  Text(
                    'FCM Token:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.copy, size: 20),
                    onPressed: _copyToken,
                    tooltip: 'Copiar token',
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _fcmToken!.length > 50
                      ? _fcmToken!.substring(0, 50) + '...'
                      : _fcmToken!,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Botones de prueba
            Text(
              'Simular Notificaciones FCM:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _simulateSecurityNotification,
              icon: Icon(Icons.security),
              label: Text('Eliminar Datos Sensibles'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _simulateClearCart,
              icon: Icon(Icons.shopping_cart_outlined),
              label: Text('Limpiar Carrito'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Información
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                border: Border.all(color: Colors.yellow.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payload FCM esperado:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '{"action": "clear_sensitive_data"}',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                  Text(
                    '{"action": "clear_cart"}',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
