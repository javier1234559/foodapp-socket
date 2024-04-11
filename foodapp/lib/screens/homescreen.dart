import 'package:flutter/material.dart';
import 'package:foodapp/service/apiservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quick_actions/quick_actions.dart';
import '../model/product.dart';
import '../widgets/product_item.dart';
import 'aboutscreen.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product>? products; // Declare as nullable
  QuickActions quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_help', localizedTitle: 'Về Chúng tôi', icon: 'icon_help')
    ]);
    quickActions.initialize((shortcutType) {
      print(shortcutType);
      if (shortcutType == 'action_help') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
      }
    });

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    products = await ApiService.fetchProducts();

    // Simulating a delay of 2 seconds to mimic network latency
    // await Future.delayed(Duration(seconds: 2));
    //
    // // Generate mock data
    // products = List.generate(
    //   10,
    //   (index) => Product(
    //     id: 'id_$index',
    //     name: 'Product ${index + 1}',
    //     imageUrl: 'https://via.placeholder.com/150',
    //     // Placeholder image URL
    //     price: (index + 1) * 10.0, // Incrementing price for each product
    //   ),
    // );

    // Ensure to call setState() after updating products
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producte List'),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () async {
              Navigator.pop(context); // Close the drawer
              // Launch email app to contact
              final Uri emailLaunchUri =
                  Uri(scheme: 'mailto', path: 'foodorder@cntt.io');
              launchUrl(emailLaunchUri);
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
        ],
      )),
      body: Center(
          child: products == null
              ? CircularProgressIndicator()
              : products!.isEmpty
                  ? Text('No products available')
                  : ListView.builder(
                      itemCount: products?.length,
                      itemBuilder: (context, index) {
                        final product = products![index];
                        return ProductItem(product: product);
                      },
                    )),
    );
  }
}
