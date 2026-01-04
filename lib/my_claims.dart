import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyClaims extends StatefulWidget {
  const MyClaims({super.key});

  @override
  State<MyClaims> createState() => _MyClaimsState();
}

class _MyClaimsState extends State<MyClaims> {
  bool loading = true;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color cardBg = const Color(0xff598392);
  final Color textDark = const Color(0xff01161E);
  final Color buttonText = const Color(0xffEFF6E0);

  List<Map<String, String>> claims = [];

  @override
  void initState() {
    super.initState();
    fetchMyClaims();
  }

  void fetchMyClaims() async {
    try {
      final url = Uri.parse(
        'https://reclaim.atwebpages.com/get_my_claims.php?user_id=1',
      );

      final response =
      await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);

        List<Map<String, String>> loadedClaims = [];

        for (var row in jsonResponse) {
          String status =
          (row['claim_status'] ?? 'pending').toString();
          status = status[0].toUpperCase() + status.substring(1);

          loadedClaims.add({
            'title': row['title'] ?? '',
            'location': row['location'] ?? '',
            'campus': row['campus'] ?? '',
            'status': status,
          });
        }

        setState(() {
          claims = loadedClaims;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        claims = [];
        loading = false;
      });
    }
  }

  Color getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('My Claims'),
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
              'Claims you have submitted',
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
                  : ListView.builder(
                itemCount: claims.length,
                itemBuilder: (_, index) {
                  final claim = claims[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
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
                            color: Color(0xffEFF6E0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${claim['location']} • ${claim['campus']}',
                          style: const TextStyle(
                            color: Color(0xffEFF6E0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                                claim['status'] ?? ''),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            claim['status'] ?? '',
                            style: const TextStyle(
                              color: Color(0xff01161E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
