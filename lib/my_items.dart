import 'package:flutter/material.dart';

class MyItems extends StatelessWidget {
  const MyItems({super.key});

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color textDark = const Color(0xff01161E);
  final Color buttonFill = const Color(0xff124559);
  final Color buttonText = const Color(0xffEFF6E0);

  Color getStatusColor(String status) {
    switch (status) {
      case 'Unclaimed':
        return const Color(0xffE0E1DD);
      case 'Claimed':
        return const Color(0xff993F3A);
      case 'Returned':
        return const Color(0xffAEC3B0);
      case 'Disposed':
        return const Color(0xff622825);
      default:
        return const Color(0xffE0E1DD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('My Items'),
        centerTitle: true,
        backgroundColor: cardBg,
        foregroundColor: buttonText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items you reported',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Student ID',
                          style: TextStyle(
                            color: Color(0xffEFF6E0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gate • Beirut',
                          style: TextStyle(
                            color: Color(0xffEFF6E0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor('Unclaimed'),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Unclaimed',
                              style: TextStyle(
                                color: Color(0xff01161E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Black Wallet',
                          style: TextStyle(
                            color: Color(0xffEFF6E0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Cafeteria • Mount Lebanon',
                          style: TextStyle(
                            color: Color(0xffEFF6E0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor('Returned'),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Returned',
                              style: TextStyle(
                                color: Color(0xff01161E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
