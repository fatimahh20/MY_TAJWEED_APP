import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class Exercise3Screen extends StatefulWidget {
  const Exercise3Screen({super.key});

  @override
  State<Exercise3Screen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<Exercise3Screen> {
  int currentIndex = 0;
  bool isRecording = false;
  bool isProcessing = false;
  bool hasError = false;
  String feedbackText = "Press 'Record' and recite the word clearly.";

  final Record recorder = Record();
  final AudioPlayer player = AudioPlayer();
  File? recordedFile;

  final List<Map<String, String>> words = [
    {"text": "يَدْخُلُوْنَ", "id": "s2030", "audio": "sounds/s2030.mp3"},
    {"text": "اَذِنَ", "id": "s2011", "audio": "sounds/s2011.mp3"},
    {"text": "يَتَّبِعُ", "id": "s2033", "audio": "sounds/s2033.mp3"},
    {"text": "نَطْمِسُ", "id": "s2028", "audio": "sounds/s2028.mp3"},
    {"text": "اَلْبَیْتِ", "id": "s2046", "audio": "sounds/s2046.mp3"},
    {"text": "ثُمَّ", "id": "s2040", "audio": "sounds/s2040.mp3"},
    {"text": "خُمُسَهُ", "id": "s2018", "audio": "sounds/s2018.mp3"},
    {"text": "عَزِیْزٌ", "id": "s2026", "audio": "sounds/s2026.mp3"},
    {"text": "فَاِنَّمَا", "id": "s2038", "audio": "sounds/s2038.mp3"},
    {"text": "اَخَذَ", "id": "s2002", "audio": "sounds/s2002.mp3"},
  ];

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  // ================= API CALL LOGIC =================
  Future<void> _sendToBackend() async {
    if (recordedFile == null || !await recordedFile!.exists()) {
      setState(() {
        hasError = true;
        feedbackText = "❌ Recording failed. Please try again.";
      });
      return;
    }

    setState(() {
      isProcessing = true;
      feedbackText = "Analyzing your recitation...";
    });

    try {
      final String wordId = words[currentIndex]["id"]!;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://muteeah-tajweed-backend.hf.space/upload-audio?word_id=$wordId'),
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

          hasError = phoneticFeedbackList.isNotEmpty || tajweedFeedbackList.isNotEmpty;

          feedbackText =
          "Accuracy: $accuracy\n\n"
              "Phonetic Feedback:\n$phoneticText\n\n"
              "Tajweed Feedback:\n$tajweedText";
        });
      } else {
        setState(() {
          hasError = true;
          feedbackText = "Server Error (${response.statusCode}): $responseData";
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        feedbackText = "❌ Error: ${e.toString()}";
      });
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // ================= RECORDING LOGIC =================
  Future<void> _toggleRecording() async {
    try {
      if (!isRecording) {
        if (await recorder.hasPermission()) {
          final dir = await getApplicationDocumentsDirectory();
          final String path = "${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav";

          await recorder.start(
            path: path,
            encoder: AudioEncoder.wav,
            bitRate: 128000,
            samplingRate: 16000,
            numChannels: 1,
          );

          setState(() {
            isRecording = true;
            hasError = false;
            recordedFile = File(path);
            feedbackText = "Recording... Speak now.";
          });
        } else {
          setState(() {
            hasError = true;
            feedbackText = "❌ Microphone permission denied.";
          });
        }
      } else {
        await recorder.stop();

        setState(() {
          isRecording = false;
          isProcessing = true;
        });

        await Future.delayed(const Duration(milliseconds: 800));

        if (recordedFile != null && await recordedFile!.exists()) {
          int fileSize = await recordedFile!.length();
          print("📊 Final File Size: $fileSize bytes");

          if (fileSize > 500) {
            await _sendToBackend();
          } else {
            setState(() {
              isProcessing = false;
              hasError = true;
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
        hasError = true;
        feedbackText = "❌ An error occurred while recording.";
      });
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A6858),
        title: const Text("Practice>>Exercise-3", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            "${currentIndex + 1} / ${words.length}",
            style: const TextStyle(
              fontFamily: "English",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Color(0xFF4A6858),
            ),
          ),
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
          border: Border.all(
            color: Colors.black.withAlpha(12),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(3, 4), blurRadius: 5),
          ],
        ),
        child: Text(
          textAlign: TextAlign.center,
          word["text"]!,
          style: const TextStyle(fontSize: 63, fontFamily: "Arabic2", color: Color(0xFF4A6858)),
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
    Color cardColor = hasError ? Color(0xFF4A6858) : const Color(0xFF4A6858);

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Feedback:",
              style: TextStyle(
                color: Color(0xFFE1B17D),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            if (isProcessing)
              const Center(child: CircularProgressIndicator(color: Colors.white)),
            if (!isProcessing)
              Text(
                feedbackText,
                style: const TextStyle(color: Color(0xFFF2F1E9), fontSize: 17, height: 1.6),
              ),
          ],
        ),
      ),
    );
  }
}