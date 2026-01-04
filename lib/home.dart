import 'package:flutter/material.dart';
import 'item_details.dart';
import 'my_items.dart';
import 'my_claims.dart';
import 'post_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedStatus = 'All';
  String selectedCategory = 'All';

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color buttonColor = const Color(0xff124559);

  final List<Map<String, String>> allItems = [
    {
      'title': 'iPhone 13',
      'category': 'Tech',
      'campus': 'Beirut',
      'status': 'Unclaimed',
      'location': 'Library',
      'description': 'Black iPhone with cracked screen',
    },
    {
      'title': 'Black Wallet',
      'category': 'Accessories',
      'campus': 'Mount Lebanon',
      'status': 'Claimed',
      'location': 'Cafeteria',
      'description': 'Leather wallet with cards',
    },
    {
      'title': 'Student ID',
      'category': 'IDs',
      'campus': 'Beirut',
      'status': 'Returned',
      'location': 'Gate',
      'description': 'LIU student ID',
    },
  ];

  List<Map<String, String>> getFilteredItems() => allItems.where((item) {
    final statusMatch =
        selectedStatus == 'All' || item['status'] == selectedStatus;
    final categoryMatch =
        selectedCategory == 'All' || item['category'] == selectedCategory;
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
        ],
      ),
      body: Column(
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
                    DropdownMenuEntry(value: 'Unclaimed', label: 'Unclaimed'),
                    DropdownMenuEntry(value: 'Claimed', label: 'Claimed'),
                    DropdownMenuEntry(value: 'Returned', label: 'Returned'),
                    DropdownMenuEntry(value: 'Disposed', label: 'Disposed'),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (_, index) {
                final item = items[index];
                final status = item['status'] ?? 'Unclaimed';
                final statusColor = getStatusColor(status);

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemDetails()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: pageBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(child: Text('Image')),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          item['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item['location'] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          item['campus'] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
