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
  final Color textDark = const Color(0xff01161E);
  final Color buttonFill = const Color(0xff124559);
  final Color buttonText = const Color(0xffEFF6E0);

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

  void submitClaim() {
    if (_proofController.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Claim submitted')));
    Navigator.pop(context);
  }

  void approveClaim() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Claim approved')));

  void rejectClaim() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Claim rejected')));

  void markReturned() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Item marked as returned')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
            // MAIN CARD
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
                  // TITLE
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffEFF6E0),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // META LINE
                  Text(
                    '${item['category']} • ${item['campus']} • ${item['location']}',
                    style: const TextStyle(
                      color: Color(0xffEFF6E0),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // STATUS BADGE
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

                  // IMAGE PLACEHOLDER (NO WHITE)
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: pageBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Image',
                        style: TextStyle(color: textDark.withOpacity(0.7)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // DESCRIPTION (LIGHT TEXT ON CARD)
                  Text(
                    item['description'] ?? 'No description provided',
                    style: const TextStyle(color: Color(0xffEFF6E0)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // NOT OWNER VIEW
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _proofController,
                      maxLines: 4,
                      style: const TextStyle(color: Color(0xffEFF6E0)),
                      decoration: InputDecoration(
                        hintText: 'Describe proof of ownership',
                        hintStyle: const TextStyle(color: Color(0xffEFF6E0)),
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

            // OWNER VIEW
            if (isOwner) ...[
              Text(
                'Claims',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                claim['user'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xffEFF6E0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                claim['proof'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xffEFF6E0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: approveClaim,
                          icon: const Icon(Icons.check),
                          color: buttonText,
                        ),
                        IconButton(
                          onPressed: rejectClaim,
                          icon: const Icon(Icons.close),
                          color: buttonText,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: markReturned,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonFill,
                    foregroundColor: buttonText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Mark as Returned'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
