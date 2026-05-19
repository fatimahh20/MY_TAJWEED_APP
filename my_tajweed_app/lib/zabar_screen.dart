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




class ZabarScreen extends StatefulWidget {
  const ZabarScreen({super.key});

  @override
  State<ZabarScreen> createState() => _ZabarScreenState();
}
class _ZabarScreenState extends State<ZabarScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "عَبَدَ", "audio": "sounds/s2003.mp3"},
    {"text": "اَخَذَ", "audio": "sounds/s2002.mp3"},
    {"text": "بَعَثَ", "audio": "sounds/s2001.mp3"},
    {"text": "صَرَفَ", "audio": "sounds/s2004.mp3"},
    {"text": "شَرَحَ", "audio": "sounds/s2005.mp3"},
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
  void initState() {
    super.initState();
    checkAsset();
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
          "LEARN >> Zabar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _bullet("جن حروف کے اوپر زبر آ تی ہے ، ان کو ‘ ا ’ کی آواز کے ساتھ پڑھا جاتا ہے۔"),
            _bullet("حرف  ‘ ر ’ کے اوپر زبر آ ۓ تو اسے موٹا پڑھا جاتا ہے۔"),
            _bullet("وقف کرتے ہوۓ آخری حرف پر زبر ہو تو اسے ساکن پڑھا جاتا ہے۔"),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () => playSound('zabar/baas.mp3'),
              child: const Text(
                "بَعَثَ  -----  بَعَثْ",
                style: TextStyle(
                  color: accent,
                  fontSize: 30,
                  fontFamily: 'Arabic',
                ),
              ),
            ),

            const SizedBox(height: 70),

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
              fontSize: 30,
              color: accent,
              fontFamily: 'Arabic',
            ),
          ),
        ),
      ),
    );
  }
}
