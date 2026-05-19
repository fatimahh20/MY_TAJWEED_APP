import 'package:flutter/material.dart';

class MakharijScreen extends StatelessWidget {
  const MakharijScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color bgColor = Color(0xFFECE9D0);

  final List<Map<String, String>> makharijData = const [
    {
      "image": "assets/images/cavity.png",
      "title": "الجوف",
      "subtitle": "Al-Jawf",
      "desc": "Letters originating from empty space in mouth and throat.",
    },
    {
      "image": "assets/images/halaq.png",
      "title": "الحلق",
      "subtitle": "Al-Halq",
      "desc": "Letters pronounced from the throat region.",
    },
    {
      "image": "assets/images/tongue.png",
      "title": "اللسان",
      "subtitle": "Al-Lisan",
      "desc": "Letters originating from various positions of the tongue.",
    },
    {
      "image": "assets/images/lips.png",
      "title": "الشفتان",
      "subtitle": "Al-Shafatan",
      "desc": "Letters pronounced using the lips.",
    },
    {
      "image": "assets/images/nose.png",
      "title": "الخيشوم",
      "subtitle": "Al-Khayshum",
      "desc": "Letters pronounced through the nasal passage.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "MAKHARIJ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [

          // ===== DIAGRAM CARD AT TOP =====
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: darkGreen, width: 1.8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/diagram.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          // ===== MAKHARIJ CARDS =====
          ...List.generate(makharijData.length, (index) {
            return _makharijCard(makharijData[index], index);
          }),
        ],
      ),
    );
  }

  Widget _makharijCard(Map<String, String> item, int index) {
    final bool isEven = index % 2 == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 120,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(1, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isEven
            ? [
          _imageSection(item["image"]!),
          _textSection(item),
        ]
            : [
          _textSection(item),
          _imageSection(item["image"]!),
        ],
      ),
    );
  }
  Widget _imageSection(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: darkGreen, width: 1.8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Transform.scale(
            scale: 1.6,
            child: Image.asset(
              path,
              width: 130,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
  Widget _textSection(Map<String, String> item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item["title"]!,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Arabic",
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item["subtitle"]!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkGreen,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                item["desc"]!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}