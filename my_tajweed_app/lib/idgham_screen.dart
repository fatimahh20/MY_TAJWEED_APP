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




class IdghamScreen extends StatefulWidget {
  const IdghamScreen({super.key});

  @override
  State<IdghamScreen> createState() => _IdghamScreenState();
}
class _IdghamScreenState extends State<IdghamScreen> {

  static const Color darkGreen = Color(0xFF4A6858);
  static const Color tileColor = Color(0xFFF2F1E9);
  static const Color textDark = Color(0xFF4A6858);
  static const Color accent = Color(0xFFD88C3A);

  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> words = const [
    {"text": "شَيْءً وَّهُمْ", "audio": "sounds/s2073.mp3"},
    {"text": "وَمِنْ مَّآءٍ", "audio": "sounds/s2071.mp3"},
    {"text": "خَيْرًايَّرَهُ", "audio": "sounds/s2070.mp3"},
    {"text": "غَفُوْرُ رَّحِيْم", "audio": "sounds/s2076.mp3"},
    {"text": "مِنْ لدنْهُ", "audio": "sounds/s2075.mp3"},
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
          "LEARN >> Idgham",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _bullet("ایسا  ‘ن ساکن’  جس کے بعددرجہ ذیل  حروف آ ‎ئیں،        وہاں ادغام کیا جاتا ہے۔ي،ر،م،ل،و،ن"),
            _bullet("ایسا  ‘م  ساکن’  جس کے بعد م متحرک  آۓ ،وہاں بھی   ادغام کیا جاتا ہے۔  "),
            _bullet("ادغام میں دو حروف کو آپس میں ملا کر پڑھا جاتا ہے۔"),
            const SizedBox(height: 10),



              Text(
                " ادغام بل غنّاں   -----     ي،م،و،ن  ",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),

            const SizedBox(height: 10),
               Text(
                "ادغام بلا غنّاں   ----  ل،ر  ",
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontFamily: 'Urdu',
                ),
              ),


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
        width: 90 ,
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
              fontSize: 22,
              color: accent,
              fontFamily: 'Arabic',
            ),
          ),
        ),
      ),
    );
  }
}
