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




class MaddaScreen extends StatefulWidget {
  const MaddaScreen({super.key});

  @override
  State<MaddaScreen> createState() => _MaddaScreenState();
}
class _MaddaScreenState extends State<MaddaScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "اَبَي", "audio": "assets/sounds/abad.mp3"},
    {"text": "ضَاقَتْ", "audio": "zabar/akhaza.mp3"},
    {"text": "دَابِرَ", "audio": "zabar/baas.mp3"},
    {"text": "اَعْطَي", "audio": "zabar/sharaha.mp3"},
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
          "LEARN >> Madda Letters",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _bullet("ایسا                            ‘الف ساکن ’                   جس کے پچھلے  حرف    پر  زبر ہو،                                                                                                                                                                      ایسا                       ‘ی  ساکن ’                     جس کے پچھلے  حرف    پر  زیر ہو        ،                                                                                                                                                                                                                   "
                "  ایسا                        ‘و  ساکن ’                      جس کے پچھلے  حرف    پر  پیش ہو،                                                  "),
            _bullet("  ایسے ‘ا،و،ی’پر مد اصلی کی جاتی ہے، یعنی ایک الف    کے برابر لمبا                                    پڑھا جاتا ہے۔"),
            _bullet("وقف کی صورت میں کوئ فرق نہیں پڑے گا۔"),
            const SizedBox(height: 20),



            const SizedBox(height: 60),

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
          const SizedBox(width: 10),

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
