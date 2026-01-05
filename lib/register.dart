import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedCampus;

  final Color pageBackgroundColor = const Color(0xffEFF6E0);
  final Color bubbleBackgroundColor = const Color(0xff598392);
  final Color fontColor = const Color(0xff01161E);
  final Color buttonColor = const Color(0xff124559);
  final Color buttonTextColor = const Color(0xffEFF6E0);

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('https://reclaim.atwebpages.com/register.php'),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'student_email': emailController.text.trim(),
          'password': passwordController.text,
          'campus': selectedCampus,
        }),
      );

      final result = jsonDecode(response.body);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Login()),
        );
      } else {
        String message = 'Registration failed';

        if (result['message'] == 'email_exists') {
          message = 'Email already exists';
        } else if (result['message'] == 'missing_data') {
          message = 'Please fill all fields';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
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
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: bubbleBackgroundColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: emailController,
                style: TextStyle(color: fontColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: pageBackgroundColor,
                  hintText: 'LIU Email',
                  hintStyle: TextStyle(color: fontColor.withValues(alpha: 0.7)),
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
                style: TextStyle(color: fontColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: pageBackgroundColor,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: fontColor.withValues(alpha: 0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Choose Campus',
                style: TextStyle(
                  color: buttonTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              DropdownMenu<String>(
                width: 304,
                textStyle: TextStyle(color: fontColor),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: pageBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'beirut', label: 'Beirut'),
                  DropdownMenuEntry(
                    value: 'mount_lebanon',
                    label: 'Mount Lebanon',
                  ),
                ],
                onSelected: (value) {
                  setState(() {
                    selectedCampus = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create account'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
