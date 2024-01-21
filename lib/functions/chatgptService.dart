import 'dart:async';
import 'dart:convert'; // jsonEncode ve jsonDecode için
import 'package:http/http.dart' as http; // http paketini import et

class ChatGPTService {
  // ChatGPT için simüle edilmiş API uç noktası
  static const String _apiEndpoint =
      'https://api.openai.com/v1/chat/completions';

  // Bir soru gönderip cevap almayı simüle eden metod
  static Future<String> sendQuestion(String question) async {
    try {
      var response = await http.post(
        Uri.parse(_apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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',
        },
        body: jsonEncode({
          'prompt': question,
          'model': "chatgpt-3.5-turbo",
        }),
      );
      print(response.body);
      // HTTP cevabının başarı durumunu kontrol et
      if (response.statusCode == 200) {
        print("200 " + jsonDecode(response.body)['choices'][0]['text']);
        return jsonDecode(response.body)['choices'][0]['text'];
      } else {
        // Hata durumunda uygun bir şey yapabilirsiniz.
        print('HTTP Hatası: ${response.statusCode}');
        return 'Cevap alınamadı';
      }
    } catch (e) {
      // Hata durumunda uygun bir şey yapabilirsiniz.
      print('Hata: $e');
      return 'Cevap alınamadı';
    }
  }
}
