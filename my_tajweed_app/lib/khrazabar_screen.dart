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




class KhraZabarScreen extends StatefulWidget {
  const KhraZabarScreen({super.key});

  @override
  State<KhraZabarScreen> createState() => _KhraZabarScreenState();
}
class _KhraZabarScreenState extends State<KhraZabarScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "رِسٰلٰتِ", "audio": "assets/sounds/abad.mp3"},
    {"text": "غٰوِيۡنَ", "audio": "zabar/akhaza.mp3"},
    {"text": "كِتٰبُ", "audio": "zabar/baas.mp3"},
    {"text": "وَجۡهِهٖ", "audio": "zabar/sarafa.mp3"},
    {"text": "الفِ", "audio": "zabar/sharaha.mp3"},
    {"text": "بِهٖ", "audio": "zabar/akhaza.mp3"},
    {"text": "يَلۡوٗنَ", "audio": "zabar/baas.mp3"},
    {"text": "جُنُوۡدُهٗ", "audio": "zabar/sarafa.mp3"},
    {"text": "دَاوٗدَ", "audio": "zabar/sharaha.mp3"}
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
          "LEARN >> Khra Zabar,Zair,Pesh",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                " کھڑا  زبر ، کھڑا  زیر،                 الٹا         پیش ",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),
            ),
            const SizedBox(height: 10),
            _bullet("جن حروف  پر کھڑا  زبر  ، کھڑا  زیر، الٹا پیش آ تا ہے ،     ان کو ایک الف کےبرابر لمبا  پڑھا جا             تا ہے۔   "),
            _bullet("وقف کرتے ہوۓ آخری حرف پر  درج بالا    ہو تو  اسے  ساکن پڑھا جاتا ہے۔   "),

            const SizedBox(height: 25),



            const SizedBox(height: 40),

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
              fontSize: 40,
              color: accent,
              fontFamily: 'Arabic2',
            ),
          ),
        ),
      ),
    );
  }
}
