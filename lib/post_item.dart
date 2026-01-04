import 'package:flutter/material.dart';

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

  void submitItem() {
    if (!formKey.currentState!.validate() ||
        selectedCategory == null ||
        selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item submitted')));
      Navigator.of(context).pop();
    });
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
                      child: Text(
                        'No Image',
                        style: TextStyle(color: fontColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Upload Image'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: titleController,
                    style: TextStyle(color: fontColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Item title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    style: TextStyle(color: fontColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 10),

                  DropdownMenu<String>(
                    hintText: 'Choose category',
                    width: 324,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: pageBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'tech', label: 'Tech'),
                      DropdownMenuEntry(
                        value: 'accessories',
                        label: 'Accessories',
                      ),
                      DropdownMenuEntry(value: 'ids', label: 'IDs & Cards'),
                      DropdownMenuEntry(value: 'books', label: 'Books'),
                      DropdownMenuEntry(value: 'other', label: 'Other'),
                    ],
                    onSelected: (value) =>
                        setState(() => selectedCategory = value),
                  ),

                  const SizedBox(height: 10),

                  DropdownMenu<String>(
                    hintText: 'Choose campus',
                    width: 324,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: pageBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'beirut', label: 'Beirut'),
                      DropdownMenuEntry(
                        value: 'mount_lebanon',
                        label: 'Mount Lebanon',
                      ),
                    ],
                    onSelected: (value) =>
                        setState(() => selectedCampus = value),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: locationController,
                    style: TextStyle(color: fontColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: pageBg,
                      hintText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (loading) const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
