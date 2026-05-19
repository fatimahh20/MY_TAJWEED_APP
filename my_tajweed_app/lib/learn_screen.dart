import 'package:flutter/material.dart';
import 'letters_screen.dart';
import 'zabar_screen.dart';
import 'zair_screen.dart';
import 'pesh_screen.dart';
import 'tanwin_screen.dart';
import 'tashdid_screen.dart';
import 'ghunna_screen.dart';
import 'halqi_screen.dart';
import 'qalqlah_screen.dart';
import 'madda_screen.dart';
import 'leen_screen.dart';
import 'khrazabar_screen.dart';
import 'ikhfa_screen.dart';
import 'izhaar_screen.dart';
import 'idgham_screen.dart';
import 'iqlab_screen.dart';




void main() {
  runApp(const AlMakharijApp());
}

class AlMakharijApp extends StatelessWidget {
  const AlMakharijApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LearnAllLessonsScreen(),
    );
  }
}

class LearnAllLessonsScreen extends StatelessWidget {
  const LearnAllLessonsScreen({super.key});


  // === COLORS (MATCHING FIGMA) ===
  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileCream = Color(0xFFF2F1E9);
  static const Color tileWhite = Color(0xFFECE9D0);
  static const Color textDark = Color(0xFF4A6858);

  // === ALL LESSONS (BOTH SLIDES COMBINED) ===
  final List<Map<String, String>> lessons = const [
    {"en": "Letters", "ur": "حروف", "no": "1"},
    {"en": "Zabar", "ur": "زبر", "no": "2"},
    {"en": "Zair", "ur": "زیر", "no": "3"},
    {"en": "Pesh", "ur": "پیش", "no": "4"},
    {"en": "Tanwin", "ur": "تنوین", "no": "5"},
    {"en": "Tashdid", "ur": "تشدید", "no": "6"},
    {"en": "Ghunna", "ur": "غناں", "no": "7"},
    {"en": "Makhraj Halqi", "ur": "مخرج حلقی", "no": "8"},
    {"en": "Qalqalah", "ur": "قلقلہ", "no": "9"},
    {"en": "Madda Letters", "ur": "حروف مدا", "no": "10"},
    {"en": "Leen Letters", "ur": "حروف لین", "no": "11"},
    {"en": "-", "ur": "کھڑا زبر,کھڑی زیر,ا‌لٹا پیش", "no": "12"},
    {"en": "Ikhfa", "ur": "اخفا", "no": "13"},
    {"en": "Izhaar", "ur": "اظہار", "no": "14"},
    {"en": "Idgham", "ur": "ادغام", "no": "15"},
    {"en": "Iqlab", "ur": "اقلاب", "no": "16"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 👈 GO BACK TO MODE SCREEN
          },
        ),
        title: const Text(
          "LESSONS",
          style: TextStyle(
            fontFamily: "English",
            fontWeight: FontWeight.normal,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),


      // ===== SCROLLABLE LIST =====
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final item = lessons[index];
            final bool isCream = index.isEven;

            return LessonTile(
              english: item["en"]!,
              urdu: item["ur"]!,
              number: item["no"]!,
              backgroundColor: isCream ? tileCream : tileWhite,
            );
          },
        ),
      ),
    );
  }
}

// ===== LESSON TILE WIDGET =====
class LessonTile extends StatelessWidget {
  final String english;
  final String urdu;
  final String number;
  final Color backgroundColor;

  const LessonTile({
    super.key,
    required this.english,
    required this.urdu,
    required this.number,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: () {
        Widget? targetScreen;

        switch (number) {
          case "1":
            targetScreen =  LettersScreen();
            break;
          case "2":
            targetScreen = const ZabarScreen();
            break;
          case "3":
            targetScreen = const ZairScreen();
            break;
          case "4":
            targetScreen = const PeshScreen();
            break;
          case "5":
            targetScreen = const TanwinScreen();
            break;
          case "6":
            targetScreen = const TashdidScreen();
            break;
          case "7":
            targetScreen = const GhunnaScreen();
            break;
          case "8":
            targetScreen = const HalqiScreen();
            break;
          case "9":
            targetScreen = const QalqlahScreen();
            break;
          case "10":
            targetScreen = const MaddaScreen();
            break;
          case "11":
            targetScreen = const LeenScreen();
            break;
          case "12":
            targetScreen = const KhraZabarScreen();
            break;
          case "13":
            targetScreen = const IkhfaScreen();
            break;
          case "14":
            targetScreen = const IzhaarScreen();
            break;
          case "15":
            targetScreen = const IdghamScreen();
            break;
          case "16":
            targetScreen = const IqlabScreen();
            break;
        }

        if (targetScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen!),
          );
        }
      },



      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border : Border.all(
            color: Colors.black.withAlpha(12),
            width: 1,
          ),
          color: backgroundColor,
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
            // ENGLISH TEXT
            Expanded(
              child: Text(
                english,
                style: const TextStyle(
                  fontFamily: 'Urdu',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: LearnAllLessonsScreen.textDark,
                ),
              ),
            ),

            // URDU TEXT
            Text(
              urdu,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'Urdu',
                fontSize: 18,
                color: LearnAllLessonsScreen.textDark,
              ),
            ),

            const SizedBox(width: 12),

            // NUMBER
            Text(
              number,
              style: const TextStyle(
                fontFamily: 'English',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: LearnAllLessonsScreen.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
