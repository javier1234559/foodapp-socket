import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

import '../model/product.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late final IOWebSocketChannel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize the notification plugin
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _configureNotificationSettings();

    channel =
        IOWebSocketChannel.connect('ws://192.168.43.119:3000/orders/create');
    channel.stream.listen((message) {
      // Handle the server's response here
      // Handle the server's response here
      _showNotification(message);

      print('Received: $message');
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void sendWebSocketData(int productId) async {
    await channel.ready;
    Map<String, dynamic> data = {'type': 'Subscribe', 'product_id': productId};
    String jsonData = jsonEncode(data);
    channel.sink.add(jsonData);
  }

  Future<void> _configureNotificationSettings() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('default_notification_channel_id', 'Default',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'New status of the order', message, platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.product.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(widget.product.name),
      subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () {
          sendWebSocketData(widget.product.id);
        },
      ),
    );
  }
}
