// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOS = IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final List<MenuItem> menuItems = [
//     MenuItem(name: 'Bún Chả', price: '25,000', quantity: 1),
//     MenuItem(name: 'Phở', price: '30,000', quantity: 1),
//     MenuItem(name: 'Bánh Mì', price: '15,000', quantity: 1),
//   ];
//
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   @override
//   void initState() {
//     super.initState();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ứng dụng Đặt món ăn'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {
//               // Add your menu functionality here
//               // For example, you can display a popup menu
//               // or navigate to a settings page
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(
//               child: Text('Menu'),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//             ),
//             ListTile(
//               title: Text('Phản hồi'),
//               onTap: () {
//                 launch('mailto:foodorder@cntt.io');
//               },
//             ),
//             ListTile(
//               title: Text('Về chúng tôi'),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AboutUsPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: menuItems.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(menuItems[index].name),
//             subtitle: Text('Giá: ${menuItems[index].price} đồng'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove),
//                   onPressed: () {
//                     setState(() {
//                       if (menuItems[index].quantity > 1) {
//                         menuItems[index].quantity--;
//                       }
//                     });
//                   },
//                 ),
//                 Text('${menuItems[index].quantity}'),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     setState(() {
//                       menuItems[index].quantity++;
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     showNotification(index + 1, 'Đang xử lý',
//                         flutterLocalNotificationsPlugin);
//                   },
//                   child: Text('Chọn'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Display the status of the order here
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Trạng thái đơn hàng'),
//                           content: Text('Đang xử lý'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Đóng'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text('Trạng thái'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class MenuItem {
//   final String name;
//   final String price;
//   int quantity;
//
//   MenuItem({required this.name, required this.price, required this.quantity});
// }
//
// class AboutUsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Us'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Thông tin nhóm:'),
//             Text('MSSV: 123456'),
//             Text('Họ và tên: Nguyễn Văn A'),
//             Text('MSSV: 654321'),
//             Text('Họ và tên: Nguyễn Thị B'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<void> showNotification(
//     int orderId, String status, FlutterLocalNotificationsPlugin notifications) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     'channel_description',
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );
//   await notifications.show(
//     orderId,
//     'Đơn hàng $orderId của bạn',
//     'Trạng thái: $status',
//     platformChannelSpecifics,
//   );
// }
