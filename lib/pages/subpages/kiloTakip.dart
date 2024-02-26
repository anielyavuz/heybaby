import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(KiloTakipApp());
}

class KiloTakipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kilo Takip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KiloTakipPage(),
    );
  }
}

class KiloTakipPage extends StatefulWidget {
  @override
  _KiloTakipPageState createState() => _KiloTakipPageState();
}

class _KiloTakipPageState extends State<KiloTakipPage> {
  double _currentWeight = 1.0; // Default weight for baby
  List<WeightEntry> _weightHistory = []; // Weight history list
  bool _isMotherWeight = false; // Default switch value

  Timer? _timer;
  bool _longPressAdd = false;
  bool _longPressSubtract = false;

  void _updateWeight(bool isIncreasing) {
    setState(() {
      if (isIncreasing) {
        _currentWeight = (_currentWeight + 0.1)
            .clamp(0.0, 9999.9); // Prevents from going below 0
      } else {
        _currentWeight = (_currentWeight - 0.1)
            .clamp(0.0, 9999.9); // Prevents from going below 0
      }
    });
  }

  void _saveWeight() {
    setState(() {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      _weightHistory.insert(
        0,
        WeightEntry(
          weight: _currentWeight,
          dateTime: formattedDate,
          isMotherWeight: _isMotherWeight,
        ), // Insert at the beginning
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(bool isIncreasing) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (isIncreasing) {
          _currentWeight += 0.1;
        } else {
          _currentWeight -= 0.1;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color itemColor = _isMotherWeight ? Colors.purple[50]! : Colors.pink[50]!;
    return PopScope(
      onPopInvoked: (didPop) {
        print("pop oldu");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return CheckAuth();
        }));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kilo Takip'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bebek Kilo'),
                        Switch(
                          value: _isMotherWeight,
                          onChanged: (value) {
                            setState(() {
                              _isMotherWeight = value;
                              _currentWeight = value ? 50.0 : 1.0;
                            });
                          },
                        ),
                        Text('Anne Kilo'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Mevcut Kilo',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            _updateWeight(
                                details.primaryDelta! < 0); // Changed here
                          },
                          child: Text(
                            _currentWeight.toStringAsFixed(1), // Changed here
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapDown: (_) {
                          _updateWeight(false); // Changed here
                          _longPressSubtract = true;
                          _startTimer(false);
                        },
                        onTapUp: (_) {
                          _longPressSubtract = false;
                          _stopTimer();
                        },
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: null,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _saveWeight();
                        },
                        child: Text('Kaydet'),
                      ),
                      GestureDetector(
                        onTapDown: (_) {
                          _updateWeight(true); // Changed here
                          _longPressAdd = true;
                          _startTimer(true);
                        },
                        onTapUp: (_) {
                          _longPressAdd = false;
                          _stopTimer();
                        },
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _weightHistory.length,
                      itemBuilder: (context, index) {
                        Color bgColor = _weightHistory[index].isMotherWeight
                            ? Colors.purple[100]!
                            : Colors.pink[100]!;
                        return Container(
                          color: bgColor,
                          child: ListTile(
                            title: Text(
                              'Kilo: ${_weightHistory[index].weight.toStringAsFixed(1)} kg', // Changed here
                              style: TextStyle(fontSize: 16.0),
                            ),
                            subtitle: Text(
                              'Kayıt Tarihi: ${_weightHistory[index].dateTime}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 5,
              top: 0,
              child: Container(
                height: 40,
                child: IconButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return CheckAuth();
                      }));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 35,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WeightEntry {
  final double weight;
  final String dateTime;
  final bool isMotherWeight;

  WeightEntry({
    required this.weight,
    required this.dateTime,
    required this.isMotherWeight,
  });
}
