import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:intl/intl.dart';

class KiloTakipPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const KiloTakipPage({Key? key, this.userData}) : super(key: key);

  @override
  _KiloTakipPageState createState() => _KiloTakipPageState();
}

class _KiloTakipPageState extends State<KiloTakipPage> {
  double _currentWeight = 1.0; // Default weight for baby
  List<WeightEntry> _weightHistory = []; // Weight history list
  bool _isMotherWeight = false; // Default switch value
  TextEditingController _weightController = TextEditingController();

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
    print(widget.userData);
    if (widget.userData != null) {
      print(widget.userData!['isPregnant']);
    } else {
      print("user data null");
    }
    setState(() {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      _weightHistory.insert(
        0,
        WeightEntry(
          weight: _currentWeight,
          dateTime: formattedDate,
          isMotherWeight: _isMotherWeight,
          dogumOnceSonra: widget.userData!['dogumOnceSonra'],
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

  void _showWeightInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kilo Girin"),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller:
                _weightController, // TextEditingController tanımlanmalıdır.
            decoration: InputDecoration(labelText: "Kilo"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
                _weightController.clear();
              },
            ),
            TextButton(
              child: Text("Kaydet"),
              onPressed: () {
                // Kullanıcının girdiği kiloyu al ve _currentWeight'i güncelle
                setState(() {
                  _currentWeight = double.parse(_weightController.text);
                });
                Navigator.of(context).pop();
                _weightController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color itemColor = _isMotherWeight ? Colors.purple[50]! : Colors.pink[50]!;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 80,
                  child: Center(
                      child: Text(
                    "Kilo Takip",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Mevcut Kilo',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          _showWeightInputDialog(); // Kullanıcı tıkladığında ağırlık giriş iletişim kutusunu göster
                        },
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
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
                ),
                Divider(
                  thickness: 4,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    "Geçmiş",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
                ),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: _weightHistory.length,
                    itemBuilder: (context, index) {
                      Color bgColor = _weightHistory[index].isMotherWeight
                          ? Colors.purple[100]!
                          : Colors.pink[100]!;
                      return Container(
                        color: bgColor,
                        child: Slidable(
                          endActionPane: const ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: null,
                                backgroundColor:
                                    Color.fromARGB(255, 133, 221, 106),
                                foregroundColor: Colors.white,
                                icon: Icons.archive,
                                label: 'Düzenle',
                              ),
                              SlidableAction(
                                onPressed: null,
                                backgroundColor: Color.fromARGB(255, 207, 3, 3),
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Sil',
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: widget.userData!['isPregnant']
                                ? Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: const Color.fromARGB(
                                            255,
                                            138,
                                            33,
                                            243), // Yuvarlağın arka plan rengini ayarlayabilirsiniz.
                                        child: Column(
                                          children: [
                                            Text(
                                              (((DateTime.now().difference(
                                                              DateTime.parse(widget
                                                                      .userData![
                                                                  'sonAdetTarihi'])))
                                                          .inDays) ~/
                                                      7)
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors
                                                    .white, // Metnin rengini ayarlayabilirsiniz.
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10.0), // CircleAvatar ve metin arasında biraz boşluk bırakır.
                                      Text(
                                        'Kilo: ${_weightHistory[index].weight.toStringAsFixed(1)} kg',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '${_weightHistory[index].weight.toStringAsFixed(1)} kg',
                                    // Changed here
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                            subtitle: Text(
                              'Kayıt Tarihi: ${_weightHistory[index].dateTime}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            trailing: Container(
                              width: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit_note_sharp,
                                    size: 30,
                                    // color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Text("Not Ekle"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 5,
              top: 0,
              child: Container(
                height: 40,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (_) {
                      //   return CheckAuth();
                      // }));
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
  final String dogumOnceSonra;

  WeightEntry({
    required this.weight,
    required this.dateTime,
    required this.isMotherWeight,
    required this.dogumOnceSonra,
  });
}
