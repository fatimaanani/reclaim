import 'package:flutter/material.dart';

class MyItems extends StatelessWidget {
  const MyItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('My items will appear here'),
      ),
    );
  }
}
