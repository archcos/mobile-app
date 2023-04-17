import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../auth/Auth_services.dart';
import 'login_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality Detection System'),
      ),
      body: Center(
        child: Text('Home Sceen'),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                children: [
                  DrawerHeader(
                    child: Text('Please login'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ],
              );
            } else {
              return ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: auth.user.avatar != null &&
                              Uri.parse(auth.user.avatar).isAbsolute
                              ? NetworkImage(auth.user.avatar)
                              : null,
                          radius: 30,
                        ),
                        SizedBox(height: 10),
                        Text(
                          auth.user.name,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          auth.user.email,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {Provider.of<Auth>(context, listen: false).logout();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
