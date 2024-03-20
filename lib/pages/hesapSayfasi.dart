import 'package:flutter/material.dart';

class HesapSayfasi extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback? onSignOutPressed;

  HesapSayfasi({Key? key, this.userData, this.onSignOutPressed})
      : super(key: key);

  @override
  _HesapSayfasiState createState() => _HesapSayfasiState();
}

class _HesapSayfasiState extends State<HesapSayfasi> {
  int _selectedStarIndex = -1;
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(widget.userData?['photoURL'] ??
              'https://placekitten.com/200/200'),
        ),
        Text(
          widget.userData?['name'] ?? 'Guest',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.userData?['email'] ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index <= _selectedStarIndex ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _selectedStarIndex = index;
                });
              },
            );
          }),
        ),
        SizedBox(height: 16),
        TextField(
          maxLines: 2,
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'Geri bildiriminizi buraya yazın',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          child: Text('Geri Bildirim Gönder'),
          onPressed: () {
            print(
                'Geri Bildirim: ${noteController.text}, Seçilen yıldız: ${_selectedStarIndex + 1}');
          },
        ),
        ElevatedButton(
          child: Text(
            'Beğendiğim Storyler',
          ),
          onPressed: () {},
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: widget.onSignOutPressed,
          child: Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
