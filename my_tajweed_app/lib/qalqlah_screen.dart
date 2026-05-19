import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

Future<void> checkAsset() async {
  try {
    await rootBundle.load('assets/zabar/baas.mp3');
    print("Asset found!");
  } catch (e) {
    print("Asset NOT found: $e");
  }
}




class QalqlahScreen extends StatefulWidget {
  const QalqlahScreen({super.key});

  @override
  State<QalqlahScreen> createState() => _QalqlahScreenState();
}
class _QalqlahScreenState extends State<QalqlahScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "يَدْخُلُوْنَ", "audio": "assets/sounds/abad.mp3"},
    {"text": "اَلَمْ يَجْعَلْ", "audio": "zabar/akhaza.mp3"},
    {"text": "نَطْمِسُ", "audio": "zabar/baas.mp3"},
    {"text": "صَبْرَهُ", "audio": "zabar/sarafa.mp3"},
    {"text": "تَقْرِضُهُمْ", "audio": "zabar/sharaha.mp3"},
  ];
  AudioCache player = AudioCache();
  Future<void> playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
    await _player.setVolume(1.0);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "LEARN >> Qalqlah",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _bullet("  درجہ ذیل حروف پر قلقلہ  کریں گے         "
                "ق ، ط،ب،ج،د۔"),
            _bullet(" قلقلہ  کے حروف پر جزم /سکون ہو تو  ان کی آوازٹکرا    "   ),
            _bullet(" قلقلہ  صرف جزم /سکون کی حالت میں کیا جا‏‎ۓ گا۔    "),
            const SizedBox(height: 20),



            const SizedBox(height: 90),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              alignment: WrapAlignment.center,
              children: words.map((item) {
                return _wordTile(
                  text: item["text"]!,
                  audio: item["audio"]!,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•",
            style: TextStyle(fontSize: 30, color: darkGreen),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Urdu",
                color: darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wordTile({required String text, required String audio}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => playSound(audio),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 4),
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 28,
              color: accent,
              fontFamily: 'Arabic',
            ),
          ),
        ),
      ),
    );
  }
}
