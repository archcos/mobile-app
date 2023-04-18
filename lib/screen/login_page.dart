import 'package:flutter/material.dart';
import 'package:mobileint/screen/OTPscreen.dart';
import 'package:provider/provider.dart';
import 'package:themed/themed.dart';
import '../auth/Auth_services.dart';
import 'home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = '';
    _passwordController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
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
                    controller: _emailController,
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
                      controller: _passwordController,
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
                        Map creds = {
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'device_name': 'mobile',
                        };
                        if (_formKey.currentState!.validate()) {
                          Provider.of<Auth>(context, listen: false).login(creds: creds);
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => HomeScreen()));
                        }
                      },
                      child: const Text("Sign In", style: TextStyle(color: Colors.black, fontSize: 17))
                  ),
                  TextButton(
                      onPressed: (){
                        RegisterPage();
                      },
                      child: const Text("Create Account")
                  )
                ]
            )
        )
    );
  }

  void RegisterPage() async {
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
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Full Name"),
                    validator: (value){
                      return (value == '')? "Input Full Name" : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
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
                    controller: _emailController,
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
              onPressed: () async {
                Map creds = {
                  'name' : _nameController.text,
                  'email': _emailController.text,
                  'password': _passwordController.text,
                  'device_name': 'mobile',
                };
                if (_formKey.currentState!.validate()) {
                  String token = await Provider.of<Auth>(context, listen: false).register(creds: creds);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OTPscreen(email: _emailController.text, token: token),
                    ),
                  );
                }
              },
              child: const Center(
                child: Text("Sign Up"),
              ),
            ),
          ],
        );
      },
    );
  }

}