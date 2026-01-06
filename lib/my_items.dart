import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/item_card.dart';


const String _baseURL = 'reclaim.atwebpages.com';

class MyItems extends StatefulWidget {
  const MyItems({super.key});

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  bool loading = true;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color textDark = const Color(0xff01161E);
  final Color buttonText = const Color(0xffEFF6E0);

  List<Map<String, String>> items = [];

  @override
  void initState() {
    super.initState();
    fetchMyItems();
  }

  void fetchMyItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          items = [];
          loading = false;
        });
        return;
      }

      final url = Uri.parse(
        'https://reclaim.atwebpages.com/get_my_items.php?user_id=$userId',
      );

      final response = await http.get(url);

      final jsonResponse = convert.jsonDecode(response.body);

      List<Map<String, String>> loadedItems = [];

      for (var row in jsonResponse) {
        String status = (row['status'] ?? '').toString();

        if (status.isNotEmpty) {
          status = status[0].toUpperCase() + status.substring(1);
        }

        loadedItems.add({
          'title': row['title'] ?? '',
          'campus': row['campus'] ?? '',
          'location': row['location'] ?? '',
          'status': status,
        });
      }

      setState(() {
        items = loadedItems;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

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

            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (items.isEmpty)
              const Center(child: Text('No items found'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];

                    return ItemCard(
                      title: item['title'] ?? '',
                      description: '',
                      location: item['location'] ?? '',
                      campus: item['campus'] ?? '',
                      status: item['status'] ?? '',
                      statusColor: getStatusColor(item['status'] ?? ''),
                      imageUrl: null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
