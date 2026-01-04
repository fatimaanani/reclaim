import 'package:flutter/material.dart';

class MyClaims extends StatelessWidget {
  const MyClaims({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Claims'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('My claims will appear here'),
      ),
    );
  }
}
