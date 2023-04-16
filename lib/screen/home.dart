import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../sbar/collapsible_sidebar.dart';

class HomePage extends StatefulWidget {

  final List data;
  const HomePage({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List posts = <dynamic>[];
  List users = <dynamic>[];
  int postId = 0;
  int currentIndex = 0;
  List account = <dynamic>[];

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  getUsers() async {
    var url = 'http://test-api-3dsh.onrender.com/users';
    var response = await http.get(Uri.parse(url));

    setState(() {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    });
  }

  getUser() async {
    for (int i = 0; i <= users.length; i++) {
      if (widget.data == users[i]['id']) {
        setState(() {
          currentIndex = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          drawer: NavBar(data: widget.data),
          body: ListView(
            children: [
              Text('${users.length}')
            ],
          )
        )
    );
  }
}
