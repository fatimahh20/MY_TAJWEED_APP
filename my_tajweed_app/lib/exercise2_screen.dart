import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart'; // ✅ Switched to record package
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class Exercise2Screen extends StatefulWidget {
  const Exercise2Screen({super.key});

  @override
  State<Exercise2Screen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<Exercise2Screen> {
  int currentIndex = 0;
  bool isRecording = false;
  bool isProcessing = false;
  String feedbackText = "Press 'Record' and recite  clearly.";

  // ✅ Use AudioRecorder instead of FlutterSoundRecorder
  final Record recorder = Record();
  final AudioPlayer player = AudioPlayer();
  File? recordedFile;

  final List<Map<String, String>> words = [
    {"text": "اَنْفُسُهُمْ", "id": "s2062", "audio": "sounds/s2062.mp3"},
    {"text": "وَكُنْتُمْ", "id": "s2065", "audio": "sounds/s2065.mp3"},
    {"text": "مِنْ حَيْثُ", "id": "s2066", "audio": "sounds/s2066.mp3"},
    {"text": "مَنْ هَاجَرَ", "id": "s2069", "audio": "sounds/s2069.mp3"},
    {"text": "وَمِنْ مَّآءٍ", "id": "s2071", "audio": "sounds/s2071.mp3"},
    {"text": "مِنْ لَّدُنْهُ", "id": "s2075", "audio": "sounds/s2075.mp3"},
    {"text": "مِنْ بَقْلِهَا", "id": "s2077", "audio": "sounds/s2077.mp3"},
    {"text": "اَنْبَتَتْ", "id": "s2079", "audio": "sounds/s2079.mp3"},
    {"text": "عَنْ بَيِّنَةٍ", "id": "s2080", "audio": "sounds/s2080.mp3"},
    {"text": "عَلَيْهِ ", "id": "s2048", "audio": "sounds/s2048.mp3"},
  ];


  @override
  void dispose() {
    recorder.dispose(); // ✅ AudioRecorder uses dispose()
    player.dispose();
    super.dispose();
  }

  // ================= API CALL LOGIC =================
  Future<void> _sendToBackend() async {
    if (recordedFile == null || !await recordedFile!.exists()) {
      setState(() => feedbackText = "❌ Recording failed. Please try again.");
      return;
    }

    setState(() {
      isProcessing = true;
      feedbackText = "Analyzing your recitation...";
    });

    try {
      // Use your local IP for real device testing!
      final String wordId = words[currentIndex]["id"]!;
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://muteeah-tajweed-backend.hf.space/upload-audio?word_id=$wordId') // ✅ word_id is now in the URL
      );
      request.files.add(await http.MultipartFile.fromPath('file', recordedFile!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = json.decode(responseData);
        setState(() {
          var report = data['tajweed_report'] ?? {};
          String accuracy = report['accuracy'] ?? "0%";

          var feedbackObj = report['feedback'] ?? {};
          List phoneticFeedbackList = feedbackObj['phonetic_feedback'] ?? [];
          List tajweedFeedbackList = feedbackObj['tajweed_feedback'] ?? [];

          String phoneticText = phoneticFeedbackList.isEmpty
              ? "Perfect Pronunciation."
              : phoneticFeedbackList.map((e) => "• ${e['detail']}").join("\n");

          String tajweedText = tajweedFeedbackList.isEmpty
              ? "No Rule Mistake found."
              : tajweedFeedbackList.map((e) => "• ${e['detail']}").join("\n");

          feedbackText =
          "Accuracy: $accuracy\n\n"
              "Phonetic Feedback:\n$phoneticText\n\n"
              "Tajweed Feedback:\n$tajweedText";
        });
      }  else {
        setState(() => feedbackText = "Server Error (${response.statusCode}): $responseData");
      }
    } catch (e) {
      setState(() => feedbackText = "Connection Failed. Check if Python API is running.");
      setState(() => feedbackText = "❌ Error: ${e.toString()}");
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // ================= RECORDING LOGIC (CONVERTED) =================
  // Ensure your variable is declared as: final Record recorder = Record();
  Future<void> _toggleRecording() async {
    try {
      if (!isRecording) {
        // 1. Request Microphone Permission
        if (await recorder.hasPermission()) {
          // 2. Define a stable path in Application Documents
          final dir = await getApplicationDocumentsDirectory();
          final String path = "${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav";

          // 3. Start Recording (4.4.4 Syntax)
          await recorder.start(
            path: path,
            encoder: AudioEncoder.wav, // WAV format for ML models
            bitRate: 128000,
            samplingRate: 16000, // 16kHz Mono as required
            numChannels: 1,
          );

          setState(() {
            isRecording = true;
            recordedFile = File(path);
            feedbackText = "Recording... Speak now.";
          });
        } else {
          setState(() => feedbackText = "❌ Microphone permission denied.");
        }
      } else {
        // 4. Stop Recording
        await recorder.stop();

        setState(() {
          isRecording = false;
          isProcessing = true;
        });

        // 5. CRITICAL: Wait for the OS to finalize the file write
        // This is the primary fix for the 44-byte header-only issue.
        await Future.delayed(const Duration(milliseconds: 800));

        if (recordedFile != null && await recordedFile!.exists()) {
          int fileSize = await recordedFile!.length();
          print("📊 Final File Size: $fileSize bytes");

          // Valid audio should be > 10KB. 44 bytes = empty header.
          if (fileSize > 500) {
            await _sendToBackend();
          } else {
            setState(() {
              isProcessing = false;
              feedbackText = "❌ Capture failed (Size: $fileSize). Speak louder or use a real device.";
            });
          }
        }
      }
    } catch (e) {
      print("Recording Error: $e");
      setState(() {
        isRecording = false;
        isProcessing = false;
        feedbackText = "❌ An error occurred while recording.";
      });
    }
  }
  // ================= UI COMPONENTS (STAYING THE SAME) =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A6858),
        title: const Text("Practice>>Exercise-2", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Text("${currentIndex + 1} / ${words.length}",
              style: const TextStyle(fontFamily:"English" ,fontSize: 18, fontWeight: FontWeight.normal, color: Color(0xFF4A6858))),
          const SizedBox(height: 20),
          _wordCard(words[currentIndex]),
          const SizedBox(height: 40),
          _controls(),
          const Spacer(),
          _feedbackCard(),
        ],
      ),
    );
  }

  Widget _wordCard(Map<String, String> word) {
    return GestureDetector(
      onTap: () async {
        await player.play(AssetSource(word["audio"]!));
      },
      child: Container(
        width: 160,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F1E9),
          borderRadius: BorderRadius.circular(20),
          border : Border.all(
            color: Colors.black.withAlpha(12),
            width: 1,
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(3, 4), blurRadius: 5)],
        ),
        child: Text(
          textAlign: TextAlign.center,
          word["text"]!,
          style: const TextStyle(fontSize: 60, fontFamily: "Arabic2", color: Color(0xFF4A6858)),
        ),
      ),
    );
  }


  Widget _controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          icon: isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
          label: isRecording ? "Stop" : "Record",
          onPressed: isProcessing ? null : _toggleRecording,
          isRecord: true,
        ),

        const SizedBox(width: 15),
        _controlButton(
          icon: Icons.skip_previous,
          label: "Previous",
          onPressed: currentIndex > 0 && !isProcessing
              ? () => setState(() => currentIndex--)
              : null,
        ),

        const SizedBox(width: 15),
        _controlButton(
          icon: Icons.skip_next,
          label: "Next",
          onPressed: currentIndex < words.length - 1 && !isProcessing
              ? () => setState(() => currentIndex++)
              : null,
        ),
      ],
    );
  }
  Widget _controlButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isRecord = false,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(4, 4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecord
                  ? (isRecording ? Colors.redAccent : const Color(0xFF4A6858))
                  : const Color(0xFF4A6858),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            onPressed: onPressed,
            child: Icon(icon, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
  Widget _feedbackCard() {
    bool hasError = feedbackText.contains("❌") ||
        feedbackText.contains("Error") ||
        feedbackText.contains("Failed") ||
        feedbackText.contains("Broken") ||
        feedbackText.contains("denied");

    Color cardColor = hasError ? Color(0xFF4A6858) : const Color(0xFF4A6858);

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Feedback:",
                style: TextStyle(
                    color: Color(0xFFE1B17D),
                    fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 15),
            if (isProcessing)
              const Center(child: CircularProgressIndicator(color: Colors.white)),
            if (!isProcessing)
              Text(feedbackText,
                  style: const TextStyle(color: Color(0xFFF2F1E9), fontSize: 17, height: 1.6)),
          ],
        ),
      ),
    );
  }
}