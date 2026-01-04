import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final bool isOwner = false;

  final TextEditingController _proofController = TextEditingController();

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color buttonColor = const Color(0xff124559);

  final Map<String, String> item = {
    'title': 'iPhone 13',
    'category': 'Tech',
    'campus': 'Beirut',
    'location': 'Library',
    'status': 'Unclaimed',
    'description':
    'Black iPhone with cracked screen. Found near the library entrance.',
  };

  final List<Map<String, String>> claims = [
    {
      'user': 'student1@liu.edu',
      'proof': 'Has same wallpaper and IMEI box',
    },
    {
      'user': 'student2@liu.edu',
      'proof': 'Phone was locked with my passcode',
    },
  ];

  @override
  void dispose() {
    _proofController.dispose();
    super.dispose();
  }

  void submitClaim() {
    if (_proofController.text.isEmpty) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Claim submitted')));
    Navigator.of(context).pop();
  }

  void approveClaim() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Claim approved')));
  }

  void rejectClaim() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Claim rejected')));
  }

  void markReturned() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Item marked as returned')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pageBg,
    appBar: AppBar(
      title: const Text('Item Details'),
      centerTitle: true,
      backgroundColor: cardBg,
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: pageBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(child: Text('Image')),
          ),

          const SizedBox(height: 14),

          // TITLE
          Text(
            item['title']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '${item['category']} • ${item['campus']} • ${item['location']}',
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          // STATUS BADGE
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xff4A4A4A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item['status']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // DESCRIPTION CARD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              item['description'] ?? 'No description provided',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          // NOT OWNER VIEW
          if (!isOwner) ...[
            const Text(
              'Claim this item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _proofController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: pageBg,
                hintText: 'Describe proof of ownership',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: pageBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('This item is mine'),
              ),
            ),
          ],

          // OWNER VIEW
          if (isOwner) ...[
            const Text(
              'Claims',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: claims.length,
              itemBuilder: (_, index) {
                final claim = claims[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              claim['user']!,
                              style:
                              const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              claim['proof']!,
                              style: const TextStyle(
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check,
                                color: Colors.green),
                            onPressed: approveClaim,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red),
                            onPressed: rejectClaim,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: markReturned,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: buttonColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Mark as Returned',
                  style: TextStyle(
                    color: buttonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
