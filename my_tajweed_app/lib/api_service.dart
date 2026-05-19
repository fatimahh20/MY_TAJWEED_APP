import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ FIX 1: Use HTTPS to avoid the "301 Moved Permanently" error
  static const String baseUrl = 'https://muteeah-tajweed-backend.hf.space';

  static Future<Map<String, dynamic>> uploadAudio(File recordedFile, String wordId) async {
    try {
      // ✅ Matches your app.py @app.post("/upload-audio") Query parameter
      var uri = Uri.parse('$baseUrl/upload-audio?word_id=$wordId');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', recordedFile.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decodedData = json.decode(responseData);

        // ✅ FIX 2: Map the exact keys from your app.py return statement
        return {
          "success": true,
          "accuracy": decodedData['Accuracy'] ?? "0%",
          "feedback": decodedData['Phonetic Feedback'] ?? "Perfect Pronunciation!",
          "target": decodedData['Target'] ?? "",
          "detected": decodedData['You said'] ?? "",
        };
      } else {
        return {
          "success": false,
          "error": "Server error ${response.statusCode}",
          "details": responseData
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": "Connection failed",
        "details": e.toString()
      };
    }
  }
}