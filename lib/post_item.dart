import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'reclaim.atwebpages.com';

class PostItem extends StatefulWidget {
  const PostItem({super.key});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectedCategory;
  String? selectedCampus;

  bool loading = false;

  final Color pageBg = const Color(0xffEFF6E0);
  final Color bubbleBg = const Color(0xff598392);
  final Color fontColor = const Color(0xff01161E);
  final Color buttonColor = const Color(0xff124559);
  final Color buttonText = const Color(0xffEFF6E0);

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void submitItem() async {
    if (!formKey.currentState!.validate() ||
        selectedCategory == null ||
        selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final url = Uri.https(_baseURL, 'add_item.php');

      final response = await http
          .post(
        url,
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({
          'user_id': '1',
          'title': titleController.text.toString(),
          'description': descriptionController.text.toString(),
          'category': selectedCategory.toString(),
          'campus': selectedCampus.toString(),
          'location': locationController.text.toString(),
        }),
      )
          .timeout(const Duration(seconds: 5));

      final result = convert.jsonDecode(response.body);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item submitted successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submission failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error')),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pageBg,
    appBar: AppBar(
      title: const Text('Post Item'),
      centerTitle: true,
      backgroundColor: bubbleBg,
      foregroundColor: buttonText,
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bubbleBg,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Item',
                    style: TextStyle(
                      color: buttonText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: pageBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text('No Image',
                          style: TextStyle(color: fontColor)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Item title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 10),

                  DropdownMenu<String>(
                    hintText: 'Choose category',
                    width: 324,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'tech', label: 'Tech'),
                      DropdownMenuEntry(
                          value: 'accessories', label: 'Accessories'),
                      DropdownMenuEntry(
                          value: 'ids', label: 'IDs & Cards'),
                      DropdownMenuEntry(value: 'books', label: 'Books'),
                      DropdownMenuEntry(value: 'other', label: 'Other'),
                    ],
                    onSelected: (v) =>
                        setState(() => selectedCategory = v),
                  ),

                  const SizedBox(height: 10),

                  DropdownMenu<String>(
                    hintText: 'Choose campus',
                    width: 324,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'beirut', label: 'Beirut'),
                      DropdownMenuEntry(
                          value: 'mount_lebanon',
                          label: 'Mount Lebanon'),
                    ],
                    onSelected: (v) =>
                        setState(() => selectedCampus = v),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: loading ? null : submitItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonText,
                      ),
                      child: const Text('Submit'),
                    ),
                  ),

                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child:
                      Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
