import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KiloTakipPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String language;

  const KiloTakipPage({Key? key, this.userData, required this.language})
      : super(key: key);

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
  String _selectedWeightType = 'Bebek Kilo';

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
        FirestoreFunctions.updateKiloDataRecord(
            WeightEntry(
              weight: _currentWeight,
              dateTime: formattedDate,
              isMotherWeight: _isMotherWeight,
              dogumOnceSonra: widget.userData!['dogumOnceSonra'],
            ),
            "KiloSaveData");
      });
    } else {
      print("user data null");
    }
  }

  mevcutKilolariDiz() {
    setState(() {
      List _tempList = widget.userData!['dataRecord']['KiloSaveData'];
      _tempList.sort((a, b) {
        String dateStringA = (a['dateTime'] as String).replaceAll(' – ', ' ');
        String dateStringB = (b['dateTime'] as String).replaceAll(' – ', ' ');
        DateTime dateTimeA = DateTime.parse(dateStringA);
        DateTime dateTimeB = DateTime.parse(dateStringB);
        return dateTimeB.compareTo(dateTimeA);
      });
      _weightHistory = _tempList
          .map((entry) => WeightEntry(
                weight: entry['weight'],
                dateTime: entry['dateTime'],
                isMotherWeight: entry['isMotherWeight'],
                dogumOnceSonra: entry['dogumOnceSonra'],
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.language == "English") {
        _selectedWeightType = "Baby Weight";
      } else {
        _selectedWeightType = "Bebek Kilo";
      }
    });

    if (widget.userData != null) {
      if (widget.userData!['dataRecord'] != null) {
        if (widget.userData!['dataRecord']['KiloSaveData'] != null) {
          mevcutKilolariDiz();
        }
      }
    }
  }

  void silKilo(weightToRemove, dateTimeToRemove, isMotherWeightToRemove,
      dogumOnceSonraToRemove) {
    print(_weightHistory);

    FirestoreFunctions.deleteKiloDataRecord(
        WeightEntry(
          weight: weightToRemove,
          dateTime: dateTimeToRemove,
          isMotherWeight: isMotherWeightToRemove,
          dogumOnceSonra: dogumOnceSonraToRemove,
        ),
        "KiloSaveData");

    _weightHistory.removeWhere((entry) =>
        entry.weight == weightToRemove &&
        entry.dateTime == dateTimeToRemove &&
        entry.isMotherWeight == isMotherWeightToRemove &&
        entry.dogumOnceSonra == dogumOnceSonraToRemove);
    print(_weightHistory);
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
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280.0, // Yüksekliği biraz artırarak taşma sorununu çözeriz
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom), // Alt boşluk ekleyerek taşmayı önleriz
          color: CupertinoColors.systemBackground,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200.0,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: (_currentWeight * 10)
                        .toInt(), // 0.1 aralıklarla gösterim
                  ),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _currentWeight = index / 10.0;
                    });
                  },
                  children: List<Widget>.generate(1000, (int index) {
                    return Center(
                      child: Text((index / 10.0).toStringAsFixed(1)),
                    );
                  }),
                ),
              ),
              CupertinoButton(
                child: Text("Kaydet"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
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
                  height: 70,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.kiloTakipKiloTakibi,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          DropdownButton<String>(
                            value: _selectedWeightType,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedWeightType = newValue!;
                                _isMotherWeight =
                                    _selectedWeightType == 'Anne Kilo';
                                _currentWeight = _isMotherWeight ? 50.0 : 1.0;
                              });
                            },
                            items: <String>[
                              AppLocalizations.of(context)!.kiloTakipBebekKilo,
                              AppLocalizations.of(context)!.kiloTakipAnneKilo
                              // 'Bebek Kilo', 'Anne Kilo'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showWeightInputDialog(); // Kullanıcı tıkladığında ağırlık giriş iletişim kutusunu göster
                        },
                        onVerticalDragUpdate: (details) {
                          _updateWeight(
                              details.primaryDelta! < 0); // Changed here
                        },
                        child: Container(
                          width: 150.0, // Halka genişliği
                          height: 110.0, // Halka yüksekliği
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isMotherWeight
                                  ? Color.fromARGB(255, 243, 101, 148)
                                  : Color.fromARGB(205, 196, 145,
                                      247), // Halka rengini ayarlayabilirsiniz.
                              width: 4.0, // Halka kalınlığı
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _currentWeight.toStringAsFixed(
                                  1), // Değeri yuvarlatır ve gösterir.
                              style: TextStyle(
                                fontSize: 40.0,
                                color: _isMotherWeight
                                    ? Color.fromARGB(255, 243, 101, 148)
                                    : Color.fromARGB(205, 196, 145,
                                        247), // Metin rengini ayarlayabilirsiniz.
                              ),
                            ),
                          ),
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
                      // GestureDetector(
                      //   onTapDown: (_) {
                      //     _updateWeight(false); // Changed here
                      //     _longPressSubtract = true;
                      //     _startTimer(false);
                      //   },
                      //   onTapUp: (_) {
                      //     _longPressSubtract = false;
                      //     _stopTimer();
                      //   },
                      //   child: IconButton(
                      //     icon: Icon(Icons.remove),
                      //     onPressed: null,
                      //   ),
                      // ),

                      ElevatedButton(
                        onPressed: () async {
                          _saveWeight();
                        },
                        child: Text(AppLocalizations.of(context)!.gunlukKaydet),
                      ),
                      // GestureDetector(
                      //   onTapDown: (_) {
                      //     _updateWeight(true); // Changed here
                      //     _longPressAdd = true;
                      //     _startTimer(true);
                      //   },
                      //   onTapUp: (_) {
                      //     _longPressAdd = false;
                      //     _stopTimer();
                      //   },
                      //   child: IconButton(
                      //     icon: Icon(Icons.add),
                      //     onPressed: null,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 4,
                  // color: Colors.red,
                ),
                Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.kiloTakipGecmis,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
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
                        // color: bgColor,
                        child: Dismissible(
                          key: Key((_weightHistory[index].weight).toString() +
                              (_weightHistory[index].dateTime).toString() +
                              (_weightHistory[index].isMotherWeight)
                                  .toString() +
                              DateTime.now().microsecondsSinceEpoch.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            silKilo(
                                _weightHistory[index].weight,
                                _weightHistory[index].dateTime,
                                _weightHistory[index].isMotherWeight,
                                _weightHistory[index].dogumOnceSonra);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      // color: const Color.fromARGB(255, 138, 33,
                                      //     243), // Arka plan rengini ayarlayabilirsiniz.
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Köşeleri yuvarlatmak için.
                                    ),
                                    child: Text(
                                      ((((DateTime.parse(_weightHistory[index]
                                                              .dateTime
                                                              .substring(
                                                                  0, 10)))
                                                          .difference(DateTime
                                                              .parse(widget
                                                                      .userData![
                                                                  'sonAdetTarihi'])))
                                                      .inDays) ~/
                                                  7)
                                              .toString() +
                                          ". ${AppLocalizations.of(context)!.hafta}",
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Metnin rengini ayarlayabilirsiniz.
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  // CircleAvatar ve metin arasında biraz boşluk bırakır.
                                  Row(
                                    children: [
                                      Text(
                                        '${_weightHistory[index].weight.toStringAsFixed(1)} kg',
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _weightHistory[index].isMotherWeight
                                          ? Icon(
                                              Icons.pregnant_woman,
                                              size: 40,
                                            )
                                          : Icon(Icons.child_care, size: 40)
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${_weightHistory[index].dateTime}',
                                style: TextStyle(fontSize: 13.0),
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
