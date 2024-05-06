import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';

class StoryPaylasPage extends StatefulWidget {
  @override
  _StoryPaylasPageState createState() => _StoryPaylasPageState();
}

class _StoryPaylasPageState extends State<StoryPaylasPage> {
  TextEditingController _storyBaslikController = TextEditingController();
  TextEditingController _makaleBaslikController = TextEditingController();
  TextEditingController _makaleIcerikController = TextEditingController();
  TextEditingController _storyLinkController = TextEditingController();

  String _selectedKategori = 'Yiyecek & İçecek';
  bool _isPremium = false;

  Map<String, bool> _errorMap = {
    'storyBaslik': false,
    'makaleBaslik': false,
    'makaleIcerik': false,
    'storyLink': false,
  };

  @override
  void dispose() {
    // Dispose the controllers when not needed
    _storyBaslikController.dispose();
    _makaleBaslikController.dispose();
    _makaleIcerikController.dispose();
    _storyLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Paylaş'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _storyBaslikController,
              decoration: InputDecoration(
                hintText: 'Story Başlık',
                errorText:
                    _errorMap['storyBaslik']! ? 'Lütfen başlık giriniz' : null,
              ),
              onChanged: (_) =>
                  setState(() => _errorMap['storyBaslik'] = false),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _makaleBaslikController,
              decoration: InputDecoration(
                hintText: 'Makale Başlığı',
                errorText: _errorMap['makaleBaslik']!
                    ? 'Lütfen makale başlığı giriniz'
                    : null,
              ),
              onChanged: (_) =>
                  setState(() => _errorMap['makaleBaslik'] = false),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _makaleIcerikController,
              decoration: InputDecoration(
                hintText: 'Makale İçeriği',
                errorText: _errorMap['makaleIcerik']!
                    ? 'Lütfen makale içeriği giriniz'
                    : null,
              ),
              maxLines: 5,
              onChanged: (_) =>
                  setState(() => _errorMap['makaleIcerik'] = false),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField(
              value: _selectedKategori,
              items: [
                'Yiyecek & İçecek',
                'Temel Gıdalar',
                'Vitamin Mineraller',
                'Yapılacak & Yapılmayacak',
                'Kilo Alımı',
                'Beden Değişimleri',
                'Bebek Gelişimi',
                'Bebek Güvenliği',
                'Huzur ve Mutluluk',
                'Uyku',
                'Fiziksel Sağlık',
                'Hamilelik Ağrısı',
                'Sıkça Sorulan Sorular',
                'Sizlerden Gelenler'
              ]
                  .map((kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKategori = value.toString();
                });
              },
              decoration: InputDecoration(
                hintText: 'Kategori',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text('Premium'),
                Checkbox(
                  value: _isPremium,
                  onChanged: (value) {
                    setState(() {
                      _isPremium = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _storyLinkController,
              decoration: InputDecoration(
                hintText: 'Story Linki',
                errorText: _errorMap['storyLink']!
                    ? 'Lütfen resim linki giriniz'
                    : null,
              ),
              onChanged: (_) => setState(() => _errorMap['storyLink'] = false),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _clearFields();
                  },
                  child: Text('Temizle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _validateAndPrintValues();
                  },
                  child: Text('Gönder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndPrintValues() {
    if (_storyBaslikController.text.isEmpty) {
      setState(() => _errorMap['storyBaslik'] = true);
    }
    if (_makaleBaslikController.text.isEmpty) {
      setState(() => _errorMap['makaleBaslik'] = true);
    }
    if (_makaleIcerikController.text.isEmpty) {
      setState(() => _errorMap['makaleIcerik'] = true);
    }
    if (_storyLinkController.text.isEmpty) {
      setState(() => _errorMap['storyLink'] = true);
    }

    if (_errorMap.containsValue(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doldurunuz'),
        ),
      );
    } else {
      _sendValues();
    }
  }

  void _sendValues() {
    var formatter = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // print('baslik: ${_storyBaslikController.text}');
    // print('header: ${_makaleBaslikController.text}');
    // print('icerik: ${_makaleIcerikController.text}');
    // print('imageLink: ${_storyLinkController.text}');
    // print('kategori: $_selectedKategori');
    // print('premium: $_isPremium');
    // print('tarih: $formatter');

    FirestoreFunctions.addNewStory(
        _storyBaslikController.text,
        _makaleBaslikController.text,
        _makaleIcerikController.text,
        _storyLinkController.text,
        _selectedKategori,
        _isPremium,
        formatter);

    _clearFields();
  }

  void _clearFields() {
    _storyBaslikController.clear();
    _makaleBaslikController.clear();
    _makaleIcerikController.clear();
    _storyLinkController.clear();
    setState(() {
      _selectedKategori = 'Yiyecek & İçecek';
      _isPremium = false;
      _errorMap = {
        'storyBaslik': false,
        'makaleBaslik': false,
        'makaleIcerik': false,
        'storyLink': false,
      };
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: StoryPaylasPage(),
  ));
}
