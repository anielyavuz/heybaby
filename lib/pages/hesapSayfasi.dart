import 'package:flutter/material.dart';

class HesapSayfasi extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback? onSignOutPressed;

  const HesapSayfasi({Key? key, this.userData, this.onSignOutPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              userData?['photoURL'] ?? 'https://placekitten.com/200/200'),
        ),
        SizedBox(height: 16),
        Text(
          userData?['name'] ?? 'Guest',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          userData?['email'] ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSignOutPressed,
          child: Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
