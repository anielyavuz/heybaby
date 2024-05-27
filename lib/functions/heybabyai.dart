import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class heyBabyAI {
  Future<String?> istekYap(String _question, String _apiKey, String _model,
      String _systemInstruction) async {
    // final apiKey =
    //     Platform.environment['AIzaSyDRy3oQjUt-kvGHvS0GKxaGQ3Dh8oAEsZo'];
    // if (apiKey == null) {
    //   stderr.writeln(r'No $GOOGLE_API_KEY environment variable');
    //   exit(1);
    // }
    final model = GenerativeModel(
        model: _model,
        apiKey: _apiKey,
        safetySettings: [
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high)
        ],
        generationConfig: GenerationConfig(maxOutputTokens: 200),
        systemInstruction: Content.text(
          _systemInstruction,
        ));

// ////
//  final chat = model.startChat(history: [
//     Content.text('Hello, I have 2 dogs in my house.'),
//     Content.model([TextPart('Great to meet you. What would you like to know?')])
//   ]);
//   var message = 'How many paws are in my house?';
//   print('Message: $message');
//   var content = Content.text(message);
//   var CountTokensResponse(:totalTokens) =
//       await model.countTokens([...chat.history, content]);
//   print('Token count: $totalTokens');
//   var response = await chat.sendMessage(content);
//   print('Response: ${response.text}');

// ////

    // final prompt = 'Hamilelikte 2. hafta belirtileri nelerdir?';
    print('Prompt: $_question');
    final content = [
      Content.text(_question),
    ];
    final tokenCount = await model.countTokens(content);
    print('Token count: ${tokenCount.totalTokens}');

    final response = await model.generateContent(content);
    print('Response: ');
    print(response.text);

    return response.text;
  }
}
