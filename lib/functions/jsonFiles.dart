import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future readJson(String Language) async {
    if (Language == "Türkçe") {
      try {
        final jsonString =
            await rootBundle.loadString('assets/babyImageData.json');
        final jsonList = json.decode(jsonString);
        return jsonList;
      } catch (e) {
        print('JSON dosyası okunurken bir hata oluştu: $e');
        return []; // Hata durumunda boş bir liste döndürülebilir veya null da döndürebilirsiniz
      }
    } else {
      try {
        final jsonString =
            await rootBundle.loadString('assets/babyImageData_en.json');
        final jsonList = json.decode(jsonString);
        return jsonList;
      } catch (e) {
        print('JSON dosyası okunurken bir hata oluştu: $e');
        return []; // Hata durumunda boş bir liste döndürülebilir veya null da döndürebilirsiniz
      }
    }
  }
}
