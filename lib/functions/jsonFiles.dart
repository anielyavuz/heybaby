import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future readJson() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/babyImageData.json');
      final jsonList = json.decode(jsonString);
      return jsonList;
    } catch (e) {
      print('JSON dosyası okunurken bir hata oluştu: $e');
      return []; // Hata durumunda boş bir liste döndürülebilir veya null da döndürebilirsiniz
    }
  }
}
