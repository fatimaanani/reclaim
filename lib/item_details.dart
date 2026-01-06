import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';


const String _baseURL = 'reclaim.atwebpages.com';

class ItemDetails extends StatefulWidget {
  final String itemId;

  const ItemDetails({super.key, required this.itemId});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final bool isOwner = false;

  final TextEditingController proofController = TextEditingController();

  bool loading = true;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color textDark = const Color(0xff01161E);
  final Color buttonFill = const Color(0xff124559);
  final Color buttonText = const Color(0xffEFF6E0);

  Map<String, String> item = {};

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  void fetchItem() async {
    try {
      final url = Uri.https(
        _baseURL,
        'get_item_details.php',
        {'item_id': widget.itemId},
      );

      final response =
      await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);

        setState(() {
          item = {
            'title': data['title'] ?? '',
            'category': data['category'] ?? '',
            'campus': data['campus'] ?? '',
            'location': data['location'] ?? '',
            'status': capitalize(data['status']),
            'description': data['description'] ?? '',
          };
          loading = false;
        });
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  String capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }

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
  void dispose() {
    proofController.dispose();
    super.dispose();
  }

  void submitClaim() async {
    if (proofController.text.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login again')),
        );
        return;
      }

      final response = await http.post(
        Uri.https(_baseURL, 'submit_claim.php'),
        headers: const {'Content-Type': 'application/json; charset=UTF-8'},
        body: convert.jsonEncode({
          'item_id': widget.itemId,
          'claimer_id': userId,
          'proof_message': proofController.text.trim(),
        }),
      );

      final result = convert.jsonDecode(response.body);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim submitted')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit claim')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final statusColor = getStatusColor(item['status']);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Item Details'),
        centerTitle: true,
        backgroundColor: cardBg,
        foregroundColor: buttonText,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffEFF6E0),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item['category']} • ${item['campus']} • ${item['location']}',
                    style: const TextStyle(color: Color(0xffEFF6E0)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item['status'] ?? '',
                      style: const TextStyle(
                        color: Color(0xffEFF6E0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: pageBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item['description'] ?? '',
                    style: const TextStyle(color: Color(0xffEFF6E0)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!isOwner) ...[
              Text(
                'Claim this item',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: proofController,
                      maxLines: 4,
                      style: const TextStyle(color: Color(0xffEFF6E0)),
                      decoration: InputDecoration(
                        hintText: 'Describe proof of ownership',
                        hintStyle:
                        const TextStyle(color: Color(0xffEFF6E0)),
                        filled: true,
                        fillColor: buttonFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitClaim,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonFill,
                          foregroundColor: buttonText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('This item is mine'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
