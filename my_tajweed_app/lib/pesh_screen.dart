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




class PeshScreen extends StatefulWidget {
  const PeshScreen({super.key});

  @override
  State<PeshScreen> createState() => _PeshScreenState();
}
class _PeshScreenState extends State<PeshScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "رُسُلُ", "audio": "sounds/s2019.mp3"},
    {"text": "خُمُسَهُ", "audio": "sounds/s2018.mp3"},
    {"text": "خَبُثَ", "audio": "sounds/s2017.mp3"},
    {"text": "غَنَمُ", "audio": "sounds/s2021.mp3"},
    {"text": "كُبِتَ", "audio": "sounds/s2020.mp3"},
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
          "LEARN >> Pesh",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _bullet("جن حروف کے  اوپر پیش آ تی ہے ، ان کو ‘  او ’  کی آواز      کے ساتھ پڑھا جاتا ہے۔"),
            _bullet("حرف  ‘  ر’ کےاوپر پیش    آ ‎‎ۓ تو    اسے  موٹا    پڑھا جاتا ہے۔     "),
            _bullet("وقف کرتے ہوۓ آخری حرف پر پیش  ہو تو  اسے ساکن   پڑھا جاتا ہے۔  "),

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
