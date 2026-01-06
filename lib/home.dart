import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/item_card.dart';


import 'item_details.dart';
import 'my_items.dart';
import 'my_claims.dart';
import 'post_item.dart';
import 'login.dart';

const String _baseURL = 'reclaim.atwebpages.com';

class Home extends StatefulWidget {
  final int userId;
  const Home({super.key, required this.userId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedStatus = 'All';
  String selectedCategory = 'All';

  bool _loading = false;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color buttonColor = const Color(0xff124559);

  List<Map<String, String>> allItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  void fetchItems() async {
    setState(() {
      _loading = true;
    });

    try {
      final url = Uri.https(_baseURL, 'get_items.php');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      allItems.clear();

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        for (var row in jsonResponse) {
          String status = (row['status'] ?? 'unclaimed').toString();
          status = status[0].toUpperCase() + status.substring(1);

          allItems.add({
            'item_id': row['item_id'].toString(),
            'title': row['title'] ?? '',
            'description': row['description'] ?? '',
            'category': row['category'] ?? '',
            'campus': row['campus'] ?? '',
            'location': row['location'] ?? '',
            'status': status,
          });
        }
      }
    } catch (e) {
      allItems = [];
    }

    setState(() {
      _loading = false;
    });
  }

  List<Map<String, String>> getFilteredItems() => allItems.where((item) {
    final statusMatch =
        selectedStatus == 'All' || item['status'] == selectedStatus;
    final categoryMatch =
        selectedCategory == 'All' ||
        (item['category'] ?? '').toLowerCase() ==
            selectedCategory.toLowerCase();
    return statusMatch && categoryMatch;
  }).toList();

  Color getStatusColor(String? status) {
    switch (status) {
      case 'Unclaimed':
        return const Color(0xff4A4A4A);
      case 'Claimed':
        return const Color(0xff993F3A);
      case 'Returned':
        return const Color(0xffAEC3B0);
      case 'Disposed':
        return const Color(0xff622825);
      default:
        return const Color(0xff4A4A4A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = getFilteredItems();

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Re:Claim'),
        centerTitle: true,
        backgroundColor: cardBg,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyItems()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyClaims()),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: logout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownMenu<String>(
                        initialSelection: selectedStatus,
                        width: 160,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: buttonColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'All', label: 'All'),
                          DropdownMenuEntry(
                            value: 'Unclaimed',
                            label: 'Unclaimed',
                          ),
                          DropdownMenuEntry(value: 'Claimed', label: 'Claimed'),
                          DropdownMenuEntry(
                            value: 'Returned',
                            label: 'Returned',
                          ),
                          DropdownMenuEntry(
                            value: 'Disposed',
                            label: 'Disposed',
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            setState(() => selectedStatus = value);
                          }
                        },
                      ),
                      DropdownMenu<String>(
                        initialSelection: selectedCategory,
                        width: 160,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: buttonColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'All', label: 'All'),
                          DropdownMenuEntry(value: 'Tech', label: 'Tech'),
                          DropdownMenuEntry(
                            value: 'Accessories',
                            label: 'Accessories',
                          ),
                          DropdownMenuEntry(value: 'IDs', label: 'IDs & Cards'),
                          DropdownMenuEntry(value: 'Books', label: 'Books'),
                          DropdownMenuEntry(value: 'Other', label: 'Other'),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            setState(() => selectedCategory = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.05,
                        ),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final statusColor = getStatusColor(item['status']);

                      return ItemCard(
                        title: item['title'] ?? '',
                        description: item['description'] ?? '',
                        location: item['location'] ?? '',
                        campus: item['campus'] ?? '',
                        status: item['status'] ?? '',
                        statusColor: statusColor,
                        imageUrl: item['image_url'],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemDetails(itemId: item['item_id']!),
                          ),
                        ),
                      );

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PostItem()),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: buttonColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Add Lost Item',
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
