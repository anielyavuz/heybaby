import 'package:flutter/material.dart';

class SpinningWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
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
  final Map<String, String> _items = {
    'Bardak': "200",
    'Buyuk_Bardak': "300",
    'Matara': "500",
    'Sise': "750",
    'Surahi': "1000",
  };

  String _selectedItem = 'Küçük Bardak';
  String _selectedValue = "200";
  List<String> _history = [];
  int _historyValue = 0;
  int _targetValue = 2000;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
              "Su Hedefi " +
                  _historyValue.toString() +
                  "/" +
                  _targetValue.toString(),
              style: TextStyle(fontSize: 22, color: Colors.black)),
          flex: 1,
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: CircularProgressIndicator(
                    strokeWidth: 30,
                    value: _historyValue / _targetValue,
                    backgroundColor:
                        Color.fromRGBO(0, 203, 255, 1).withOpacity(0.2),
                    color: Color.fromRGBO(0, 203, 255, 1),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 400,
                  height: 250,
                  child: ListWheelScrollView(
                    itemExtent: 100,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedItem = _items.keys.elementAt(index);
                        _selectedValue = _items[_items.keys.elementAt(index)]!;
                      });
                    },
                    children: _items.keys
                        .map(
                          (e) => Column(
                            children: [
                              Container(
                                width: e == _selectedItem ? 150 : 100,
                                height: e == _selectedItem ? 100 : 80,
                                child: Card(
                                  color: e == _selectedItem
                                      ? Colors.orange
                                      : Colors.indigo,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/$e.png', // Örneğin, bardak.png, şişe.png gibi
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Text(
                _selectedItem + " (" + _selectedValue + "ml)",
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _history.insert(0, _selectedItem);
                    if (_historyValue + int.parse(_selectedValue) <=
                        _targetValue) {
                      _historyValue += int.parse(_selectedValue);
                    } else {
                      _historyValue = _targetValue;
                    }
                  });
                },
                child: Text('Kaydet'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _history
                        .map(
                          (item) => ListTile(
                            title: Text(item),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
