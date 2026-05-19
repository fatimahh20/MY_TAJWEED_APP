import 'package:flutter/material.dart';
import 'exercise1_screen.dart';
import 'exercise2_screen.dart';
import 'exercise3_screen.dart';

class PracticeListScreen extends StatelessWidget {
  const PracticeListScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileCream = Color(0xFFECE9D0);
  static const Color textDark = Color(0xFF4A6858);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PRACTICE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _exerciseTile(
            context,
            title: "Exercise-1",
            urdu: "سبق-1",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercise1Screen(),
                ),
              );
            },
          ),
          _exerciseTile(
            context,
            title: "Exercise-2",
            urdu: "سبق-2",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercise2Screen(),
                ),
              );
            },),
          _exerciseTile(
              context,
              title: "Exercise-3",
              urdu: "سبق-3",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Exercise3Screen(),
                ),
              );
            },


          ),
        ],
      ),
    );
  }

  Widget _exerciseTile(BuildContext context,
      {required String title, required String urdu, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border : Border.all(
            color: Colors.black.withAlpha(12),
            width: 1,
          ),
          color: tileCream,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Urdu" ,
                  color: textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              urdu,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Urdu" ,
                color: textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
