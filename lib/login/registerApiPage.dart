import 'dart:convert';

import 'package:api_demo/login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegisterApiPage extends StatefulWidget {
  const RegisterApiPage({super.key});

  @override
  State<RegisterApiPage> createState() => _RegisterApiPageState();
}

class _RegisterApiPageState extends State<RegisterApiPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;

// {
//     "email": "eve.holt@reqres.in",
//     "password": "pistol"
// }
  void register(String email, password) async {
    try {
      Response response = await post(
          Uri.parse('https://reqres.in/api/register'),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print(data['token']);
        print('Register successfully');
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
        title: const Text('Register Api Page'),
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
                    register(emailController.text.toString(),
                        passwordController.text.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginApiPage()));
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text('Register'),
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
