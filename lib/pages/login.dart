import 'package:flutter/material.dart';
import 'package:flutter_app/components/avatar.dart';
import 'package:flutter_app/components/button_text.dart';
import 'package:flutter_app/components/custom_button.dart';
import 'package:flutter_app/components/custom_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:3000/session');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.pushNamed(context, '/dashboard');
      }
    } catch (e) {
      print('Error during request: $e');
    }
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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                CustomInput(
                  label: 'EMAIL',
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                ),
                CustomInput(
                  label: 'PASSWORD',
                  controller: _passwordController,
                  obscureText: true,
                ),
                CustomButton(onPressed: fetchData, text: 'Log in'),
                ButtonText(text: 'Forgot Password?', onPressed: () {}),
                ButtonText(
                  text: 'Sign Up!',
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
