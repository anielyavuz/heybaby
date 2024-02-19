import 'package:flutter/material.dart';

class SpinningWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListWheelScrollView Örneği'),
        ),
        body: Center(
          child: RotatingHalfWheel(),
        ),
      ),
    );
  }
}

class RotatingHalfWheel extends StatefulWidget {
  @override
  _RotatingHalfWheelState createState() => _RotatingHalfWheelState();
}

class _RotatingHalfWheelState extends State<RotatingHalfWheel> {
  final List<String> _items = [
    'Bardak',
    'Şişe',
    'Matara',
    'Damacana',
    'Çeşmeden',
  ];

  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text("Baslik"),
          flex: 1,
        ),
        Expanded(
          flex: 3,
          child: ListWheelScrollView(
            itemExtent: 100,
            diameterRatio: 1.8,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });
            },
            children: _items
                .map(
                  (e) => Container(
                    width: 100,
                    height: 100,
                    child: Card(
                      color: _items.indexOf(e) == _selectedItemIndex
                          ? Colors.orange
                          : Colors.indigo,
                      child: Center(
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Text(
            _items[_selectedItemIndex],
            style: TextStyle(fontSize: 32, color: Colors.black),
          ),
          flex: 5,
        )
      ],
    );
  }
}
