import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  final Color pageBackgroundColor = const Color(0xffEFF6E0);
  final Color bubbleBackgroundColor = const Color(0xff598392);
  final Color fontColor = const Color(0xff01161E);
  final Color buttonColor = const Color(0xff124559);
  final Color buttonTextColor = const Color(0xffEFF6E0);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse('https://reclaim.atwebpages.com/login.php'),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'student_email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final int userId = int.parse(result['user_id'].toString());

        await prefs.setInt('user_id', userId);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Home(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error')),
      );
    }

    setState(() => loading = false);
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pageBackgroundColor,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 340,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: bubbleBackgroundColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: buttonTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBackgroundColor,
                      hintText: 'LIU Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBackgroundColor,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                        onPressed: loading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Register()),
                );
              },
              child: Text(
                'Create account',
                style: TextStyle(color: fontColor),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
