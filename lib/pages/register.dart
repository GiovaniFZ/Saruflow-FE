import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_button.dart';
import 'package:flutter_app/components/custom_input.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/common/show_message.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> createUser() async {
    final url = Uri.parse('http://localhost:3000/user');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (!mounted) return;
      if (response.statusCode == 201) {
        showSuccessMessage('Registration successful!', context);
        Navigator.pushNamed(context, '/login');
      } else {
        showErrorMessage(
          'Registration failed: ${response.statusCode}',
          context,
        );
      }
    } catch (e) {
      showErrorMessage('An error occurred. Please try again.', context);
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
          AppBar(
            backgroundColor: Color(0xFF03378F),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create new Account',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'Already Registered? Log in here.',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                CustomInput(
                  label: 'NAME',
                  controller: _nameController,
                  type: TextInputType.text,
                ),
                CustomInput(
                  label: 'EMAIL',
                  type: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                CustomInput(
                  label: 'PASSWORD',
                  obscureText: true,
                  controller: _passwordController,
                ),
                CustomInput(
                  label: 'DATE OF BIRTH',
                  type: TextInputType.datetime,
                ),
                CustomButton(onPressed: createUser, text: 'Sign up'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
