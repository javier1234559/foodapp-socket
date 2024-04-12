import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/service/apiservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quick_actions/quick_actions.dart';
import '../model/product.dart';
import '../widgets/product_item.dart';
import 'aboutscreen.dart';
import 'package:uni_links/uni_links.dart';

bool _initialURILinkHandled = false;

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  StreamSubscription? _streamSubscription;

  List<Product>? products; // Declare as nullable
  QuickActions quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();

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

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
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
              color: Colors.teal,
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
