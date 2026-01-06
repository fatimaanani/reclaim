import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String campus;
  final String status;
  final Color statusColor;
  final String? imageUrl;
  final String? proofMessage;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.campus,
    required this.status,
    required this.statusColor,
    this.imageUrl,
    this.proofMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xff598392);
    const Color pageBg = Color(0xffEFF6E0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // img
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: pageBg,
                borderRadius: BorderRadius.circular(14),
                image: imageUrl != null && imageUrl!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Center(
                child: Icon(Icons.image, color: Colors.grey),
              )
                  : null,
            ),


            const SizedBox(height: 6),

            // desc
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            // campus , loc
            Text(
              '$location • $campus',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),

            // claim message proof
            if (proofMessage != null && proofMessage!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: pageBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  proofMessage!,
                  style: const TextStyle(
                    color: Color(0xff01161E),
                    fontSize: 11,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 6),

            // status
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  }
}
