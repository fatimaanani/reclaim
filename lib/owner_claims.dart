import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class OwnerClaims extends StatefulWidget {
  const OwnerClaims({super.key});

  @override
  State<OwnerClaims> createState() => _OwnerClaimsState();
}

class _OwnerClaimsState extends State<OwnerClaims> {
  bool loading = true;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color textDark = const Color(0xff01161E);
  final Color buttonFill = const Color(0xff124559);
  final Color buttonText = const Color(0xffEFF6E0);

  List<Map<String, String>> ownerClaims = [];

  @override
  void initState() {
    super.initState();
    fetchOwnerClaims();
  }

  String capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }

  Color getClaimStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xffAEC3B0);
      case 'Rejected':
        return const Color(0xff993F3A);
      case 'Pending':
        return const Color(0xffE0E1DD);
      default:
        return const Color(0xffE0E1DD);
    }
  }

  Future<void> fetchOwnerClaims() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? ownerId = prefs.getInt('user_id');

      if (ownerId == null) {
        setState(() {
          ownerClaims = [];
          loading = false;
        });
        return;
      }

      final url = Uri.parse(
        'https://reclaim.atwebpages.com/get_claims_on_my_items.php?owner_id=$ownerId',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        List<Map<String, String>> loaded = [];

        for (var row in jsonResponse) {
          loaded.add({
            'claim_id': row['claim_id'].toString(),
            'item_id': row['item_id'].toString(),
            'title': row['title'] ?? '',
            'location': row['location'] ?? '',
            'campus': row['campus'] ?? '',
            'claim_status': capitalize(row['claim_status']),
            'proof_message': row['proof_message'] ?? '',
          });
        }

        setState(() {
          ownerClaims = loaded;
          loading = false;
        });
      } else {
        setState(() {
          ownerClaims = [];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        ownerClaims = [];
        loading = false;
      });
    }
  }

  Future<void> updateClaimStatus({
    required String claimId,
    required String itemId,
    required String action,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? ownerId = prefs.getInt('user_id');

      if (ownerId == null) return;

      final response = await http.post(
        Uri.parse('https://reclaim.atwebpages.com/update_claim_status.php'),
        headers: const {'Content-Type': 'application/json; charset=UTF-8'},
        body: convert.jsonEncode({
          'claim_id': claimId,
          'item_id': itemId,
          'owner_id': ownerId,
          'action': action,
        }),
      );

      final result = convert.jsonDecode(response.body);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              action == 'approve' ? 'Claim approved' : 'Claim rejected',
            ),
          ),
        );
        fetchOwnerClaims();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Action failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error')),
      );
    }
  }
  void markReturned({required String itemId}) async {
    final prefs = await SharedPreferences.getInstance();
    final int? ownerId = prefs.getInt('user_id');

    if (ownerId == null) return;

    final response = await http.post(
      Uri.parse('https://reclaim.atwebpages.com/mark_returned.php'),
      headers: const {'Content-Type': 'application/json'},
      body: convert.jsonEncode({
        'item_id': itemId,
        'owner_id': ownerId,
      }),
    );

    final result = convert.jsonDecode(response.body);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item marked as returned')),
      );
      fetchOwnerClaims(); // refresh
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Claims on My Items'),
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
              'Claim requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ownerClaims.isEmpty
                  ? const Center(child: Text('No claims yet'))
                  : ListView.builder(
                itemCount: ownerClaims.length,
                itemBuilder: (_, index) {
                  final claim = ownerClaims[index];

                  final String claimStatus =
                      claim['claim_status'] ?? 'Pending';

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          claim['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${claim['location']} • ${claim['campus']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getClaimStatusColor(claimStatus),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            claimStatus,
                            style: const TextStyle(
                              color: Color(0xff01161E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if ((claim['proof_message'] ?? '').isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: pageBg,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Text(
                              claim['proof_message'] ?? '',
                              style: const TextStyle(
                                color: Color(0xff01161E),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: claimStatus == 'Approved'
                                    ? null
                                    : () => updateClaimStatus(
                                  claimId:
                                  claim['claim_id']!,
                                  itemId: claim['item_id']!,
                                  action: 'approve',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonFill,
                                  foregroundColor: buttonText,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Approve'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: claimStatus == 'Rejected'
                                    ? null
                                    : () => updateClaimStatus(
                                  claimId:
                                  claim['claim_id']!,
                                  itemId: claim['item_id']!,
                                  action: 'reject',
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: buttonText,
                                    width: 2,
                                  ),
                                  foregroundColor: buttonText,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Reject'),
                              ),
                            ),
                          ],
                        ),
                        if (claimStatus == 'Approved') ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => markReturned(
                                itemId: claim['item_id']!,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffAEC3B0),
                                foregroundColor: const Color(0xff01161E),
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
