import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiPage extends StatefulWidget {
  const LoginApiPage({super.key});

  @override
  State<LoginApiPage> createState() => _LoginApiPageState();
}

class _LoginApiPageState extends State<LoginApiPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;

// {
//     "email": "eve.holt@reqres.in",
//     "password": "pistol"
// }
  void login(String email, password) async {
    try {
      Response response = await post(Uri.parse('https://reqres.in/api/login'),
          body: {'email': email, 'password': password});

      final SharedPreferences pref = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        Map<String, dynamic> user = {'email': email, 'Password': password};

        pref.setBool('isLogin', true);
        pref.setString('user', json.encode(User.fromJson(user)));

        //
        print('Login successfully');
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!value.contains('@')) {
                    return 'Email address must contain "@" symbol';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: InkWell(
                      onTap: togglePasswordVisibility,
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    login(emailController.text.toString(),
                        passwordController.text.toString());

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text('Login'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  User? user;

  getUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    var data = json.decode(pref.getString('user')!);
    user = User.fromJson(data);

    print("data:::${user!.email}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
    );
  }
}

class User {
  String? email;
  String? password;

  User({this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
