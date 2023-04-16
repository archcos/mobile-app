import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:themed/themed.dart';
import '../../util/data_model.dart';
import '../home.dart';

Future<DataModel> postAccount(int? id, String fullname, String password, String email) async {
  final response = await http.post(
    Uri.parse("https://test-api-3dsh.onrender.com/users"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      'id': id,
      'fullname': fullname,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 201) {
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Account');
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List accounts = <dynamic>[];
  List account = <dynamic>[];
  var formKey = GlobalKey<FormState>();
  List<DataModel> data = [];
  late int currentIndex;
  String? displayUser;


  @override
  void initState() {
    getUsers();
    super.initState();
  }


  getUsers() async {
    var url = 'https://test-api-3dsh.onrender.com/users';
    var response = await http.get(Uri.parse(url));

    setState(() {
      accounts = convert.jsonDecode(response.body) as List<dynamic>;

    });
  }

  Future loginData() async {
    var email = emailController.text;
    var password = passwordController.text;
    print("length ${accounts.length}");
    for (var i = 0; i <= accounts.length; i++) {
      if (email == accounts[i]['email'] &&
          password == accounts[i]['password']) {
        _showMsg('Login Success');
        print(accounts.length);
        account.add(accounts[i]);
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(data: account))
        );
        break;
      }
    }

  }
  _showMsg(msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  ChangeColors(
                      brightness: 0.2,
                      saturation: 0.1,
                      child: Image.asset("assets/logo.png",
                          width: 200,
                          height: 200)
                  ),
                  const SizedBox(height: 20),
                  const Text("Air Quality Detection System", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 25),
                  Text("Welcome!", style: const TextStyle(fontSize: 15, color: Colors.white, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Email",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                    validator: (value){
                      return (value == '')? "Input Email" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      )
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        loginData();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(data: account)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                      ),
                      child: const Text("Sign In", style: TextStyle(color: Colors.black, fontSize: 17))
                  ),
                  TextButton(
                      onPressed: (){
                        showMyDialogue();
                      },
                      child: const Text("Create Account")
                  )
                ]
            )
        )
    );
  }

  void showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Create Account'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Full Name"),
                      validator: (value){
                        return (value == '')? "Input Full Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password"),
                      validator: (value){
                        return (value == '')? "Input Password" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email Address"),
                      validator: (value){
                        return (value == '')? "Input Email Address" : null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    currentIndex = accounts.indexOf('id', 0);
                    setState(() {
                      postAccount(
                          currentIndex,
                          fullNameController.text,
                          passwordController.text,
                          emailController.text
                      );
                    });
                    fullNameController.clear();
                    passwordController.clear();
                    emailController.clear();
                  }
                },
                child: const Center(
                  child: Text("Sign Up"),
                ),
              ),
            ],
          );
        }
    );
  }
}