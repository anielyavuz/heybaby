import 'package:http/http.dart' as http;
import 'dart:convert';

class HeyBabyAI {
  final String apiUrl = "https://chatgpt.com/g/g-SKzOU1SsH-heybaby-ai";
  final String apiKey = "KEY";

  Future<String> fetchResponse(String question) async {
    var client = http.Client();
    try {
      var request = http.Request('POST', Uri.parse(apiUrl))
        ..headers.addAll({
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode({'question': question});

      var response = await client.send(request);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody)[
            'answer']; // API'nizin döndüğü yanıt yapısına göre düzenleyin
      } else if (response.statusCode == 307) {
        // Yönlendirme durumunu ele al
        var redirectedUrl = response.headers['location'];
        if (redirectedUrl != null) {
          request = http.Request('POST', Uri.parse(redirectedUrl))
            ..headers.addAll({
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            })
            ..body = jsonEncode({'question': question});

          response = await client.send(request);

          if (response.statusCode == 200) {
            var responseBody = await response.stream.bytesToString();
            return jsonDecode(responseBody)[
                'answer']; // API'nizin döndüğü yanıt yapısına göre düzenleyin
          } else {
            throw Exception('Failed to load redirected response');
          }
        } else {
          throw Exception('Redirected URL not found');
        }
      } else if (response.statusCode == 401) {
        return 'Unauthorized: Invalid API key';
      } else {
        throw Exception('Failed to load response');
      }
    } finally {
      client.close();
    }
  }
}
