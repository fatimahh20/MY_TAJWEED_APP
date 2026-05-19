import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TanwinScreen extends StatefulWidget {
  const TanwinScreen({super.key});

  @override
  State<TanwinScreen> createState() => _TanwinScreenState();
}

class _TanwinScreenState extends State<TanwinScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = [
    {"text": "اَحَدًا", "audio": "sounds/s2008.mp3"},
    {"text": "صَالحاً", "audio": "sounds/s2007.mp3"},
    {"text": "ثَلَاثَةً", "audio": "sounds/s2006.mp3"},
    {"text": "رِجْزٍ", "audio": "sounds/s2016.mp3"},
    {"text": "خَوْفٍ", "audio": "sounds/s2015.mp3"},
    {"text": "لَهَبٍ", "audio": "sounds/s2014.mp3"},
    {"text": "سَمِيْعٌ", "audio": "sounds/s2027.mp3"},
    {"text": "عَزِيْزٌ", "audio": "sounds/s2026.mp3"},
    {"text": "مُؤصَدَةٌ", "audio": "sounds/s2025.mp3"},
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "LEARN >> Tanwin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // ===== BODY (SCROLLABLE) =====
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
           const SizedBox(height: 30),
            Center(
              child: Text(
                "زبر کی تنوین",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),
            ),
            const SizedBox(height:20),
            _bullet(
                "جن حروف کے  اوپر    زبر تنوین آ تی ہے ، ان کو ‘  اَن’         کی آواز کے ساتھ پڑھا جاتا ہے۔"
            ),

            _bullet(
                "وقف کرتے ہوۓ آخری حرف پر     زبر تنوین   ہو تو  اسے     ایک زبر ساکن کر کےپڑھا جاتا ہے۔  "
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "زیر کی تنوین",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),
            ),

            const SizedBox(height: 20),
            _bullet(
                "جن حروف کے  نیچے     زیر تنوین آ تی ہے ، ان کو ‘  اِن’        کی آواز کے ساتھ پڑھا جاتا ہے۔"
            ),

            _bullet(
                "وقف کرتے ہوۓ آخری حرف پر     زیر تنوین   ہو تو  اسے    ساکن پڑھا جاتا ہے۔  "
            ),



            const SizedBox(height: 20),

            Center(
              child: Text(
                " پیش کی تنوین ",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),
            ),

            const SizedBox(height: 20),
            _bullet(
                "جن حروف کے  اوپر     پیش تنوین آ تی ہے ، ان کو ‘  اُن’        کی آواز کے ساتھ پڑھا جاتا ہے۔"
            ),

            _bullet(
                "وقف کرتے ہوۓ آخری حرف پر     پیش تنوین   ہو تو  اسے    ساکن پڑھا جاتا ہے۔  "
            ),
            const SizedBox(height: 80),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              alignment: WrapAlignment.center,
              children: words.map((item) {
                return _wordTile(
                  text: item["text"]!,
                  onTap: () => _playAudio(item["audio"]!),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  // ===== BULLET POINT =====
  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•",
            style: TextStyle(fontSize: 28, color: darkGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: "Urdu",
                color: darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== WORD TILE =====
  Widget _wordTile({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 4), // bottom-right shadow
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 26,
              fontFamily: 'Arabic',
              color: accent,
            ),
          ),
        ),
      ),
    );
  }
}
