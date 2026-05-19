import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LettersScreen extends StatelessWidget {
  LettersScreen({super.key});

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);

  // Arabic Letters List
  final List<String> letters = const [
    "ث", "ت", "ب", "ا",
    "د", "خ", "ح", "ج",
    "س", "ز", "ر", "ذ",
    "ط", "ض", "ص", "ش",
    "ف", "غ", "ع", "ظ",
    "م", "ل", "ك", "ق",
    "ء", "ه", "و", "ن",
    "ے", "ي"
  ];

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playAudio(String letter) async {
    try {
      await audioPlayer.stop(); // stop any previous audio
      await audioPlayer.play(AssetSource('audio/$letter.mp3'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "LEARN >> Letters",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // ===== GRID OF LETTERS =====
      body: Padding(
        padding: const EdgeInsets.all(45),
        child: GridView.builder(
          itemCount: letters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => playAudio(letters[index]),
              child: Container(
                decoration: BoxDecoration(
                  border : Border.all(
                    color: Colors.black.withAlpha(12),
                    width: 1,
                  ),
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    letters[index],
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Arabic2',
                      fontSize: 35,
                      color: textDark,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
