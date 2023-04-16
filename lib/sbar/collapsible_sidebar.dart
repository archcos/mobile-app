import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../screen/auth/login_page.dart';
import '../screen/home.dart';
import 'contact_us.dart';
import 'settings.dart';

class NavBar extends StatefulWidget {

  final List data;
  const NavBar({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  List users = <dynamic>[];
  late String username;
  List user = <dynamic>[];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    getUsers();
  }


  getUsers() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("${widget.data[0]['username']}"),
              accountEmail: Text('${widget.data[0]['email']}'),
              currentAccountPicture: CircleAvatar(
                  child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: ClipOval(
                            child: SizedBox(
                              width: 150.0,
                              height: 100.0,
                              child: Image.network(
                                "${widget.data[0]['avatar']}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ]
                  )
              ),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/000/582/800/small_2x/RR-v-mar-2019-52.jpg')
                ),
              )
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text ('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(data: widget.data))
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              userId = int.parse(widget.data[0]['id']);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings(data: userId))
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUs())
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.logout_sharp),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
          ),
        ],
      ),
    );
  }
}
