import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/anasayfa.dart';
import 'package:heybaby/pages/authentication.dart';

class SpinningWheel extends StatelessWidget {
  final Map<String, dynamic>? userData;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;

  SpinningWheel({
    required this.userData,
    required this.pageType,
    required this.pageItems,
    required this.selectedItem,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(),
        body: Center(
          child: RotatingHalfWheel(
            userData: userData,
            pageType: pageType,
            pageItems: pageItems,
            selectedItem: selectedItem,
            selectedValue: selectedValue,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RotatingHalfWheel extends StatefulWidget {
  Map<String, dynamic>? userData;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;
  RotatingHalfWheel({
    required this.userData,
    required this.pageType,
    required this.pageItems,
    required this.selectedItem,
    required this.selectedValue,
  });

  @override
  _RotatingHalfWheelState createState() => _RotatingHalfWheelState();
}

class _RotatingHalfWheelState extends State<RotatingHalfWheel> {
  // final Map<String, String> _items = {
  //   'Bardak': "200",
  //   'Buyuk_Bardak': "300",
  //   'Matara': "500",
  //   'Sise': "750",
  //   'Surahi': "1000",
  // };

  // String _selectedItem = 'Bardak';
  // String _selectedValue = "200";
  List<Map> _history = [];
  int _historyValue = 0;
  int _targetValue = 2000;
  int _count = 1;
  late List pastItems;
  @override
  void initState() {
    super.initState();

    if (widget.userData != null &&
        widget.userData!.containsKey('dataRecord') &&
        widget.userData!['dataRecord'] != null &&
        widget.userData!['dataRecord'].containsKey(widget.pageType)) {
      var historyData = widget.userData!['dataRecord'][widget.pageType];

      if (historyData is List) {
        // Bugünün tarihini al
        var now = DateTime.now();
        var today = DateTime(now.year, now.month, now.day);

        // Bugünün tarihine sahip olan öğeleri filtrele
        var todayItems = historyData.where((item) {
          var itemDate =
              item['date'].toDate(); // Timestamp'ı DateTime'a dönüştür
          var itemDateOnly =
              DateTime(itemDate.year, itemDate.month, itemDate.day);
          return itemDateOnly.isAtSameMomentAs(today);
        }).toList();

        pastItems = historyData.where((item) {
          var itemDate =
              item['date'].toDate(); // Timestamp'ı DateTime'a dönüştür
          var itemDateOnly =
              DateTime(itemDate.year, itemDate.month, itemDate.day);
          return itemDateOnly.isBefore(today);
        }).toList();

        _history = List<Map<dynamic, dynamic>>.from(todayItems);

        _history.forEach((item) {
          print(_historyValue +
              ((item['count']).toInt() * (item['amount']).toInt()));

          if (_historyValue +
                  ((item['count']).toInt() * (item['amount']).toInt()) <=
              2000) {
            var _tempValue = _historyValue +
                ((item['count']).toInt() * (item['amount']).toInt());
            _historyValue = _tempValue.toInt();
          } else {
            _historyValue = 2000;
          }
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      print("refresh");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Center(
                    child: Text(
                        "Su Hedefi " +
                            _historyValue.toString() +
                            "/" +
                            _targetValue.toString(),
                        style: TextStyle(fontSize: 22, color: Colors.black)),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 10 * 4,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: MediaQuery.of(context).size.width - 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 30,
                            value: _historyValue / _targetValue,
                            backgroundColor: Color.fromARGB(255, 76, 0, 255)
                                .withOpacity(0.2),
                            color: Color.fromARGB(255, 111, 0, 255),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          child: ListWheelScrollView(
                            itemExtent: 100,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                widget.selectedItem =
                                    widget.pageItems.keys.elementAt(index);
                                widget.selectedValue = widget.pageItems[
                                    widget.pageItems.keys.elementAt(index)]!;
                              });
                            },
                            children: widget.pageItems.keys
                                .map(
                                  (e) => Container(
                                    decoration: BoxDecoration(
                                        color: e == widget.selectedItem
                                            ? Color.fromARGB(255, 111, 0, 255)
                                            : Color.fromARGB(255, 76, 0, 255)
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    width: e == widget.selectedItem ? 100 : 60,
                                    height: e == widget.selectedItem ? 100 : 60,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/$e.png', // Örneğin, bardak.png, şişe.png gibi
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
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
                  // flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _count > 1
                              ? Text(
                                  _count.toString() + "x ",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                              : SizedBox(),
                          Text(
                            widget.selectedItem +
                                " (" +
                                widget.selectedValue +
                                "ml)",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (_count > 1) {
                                  setState(() {
                                    _count -= 1;
                                  });
                                }
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var newData = {
                                "type": widget.selectedItem,
                                "unit": "ml",
                                "amount": int.parse(widget.selectedValue),
                                "count": _count,
                                "date": DateTime.now()
                              };
                              setState(() {
                                _history.insert(0, newData);
                                if (_historyValue +
                                        int.parse(widget.selectedValue) *
                                            _count <=
                                    _targetValue) {
                                  _historyValue +=
                                      int.parse(widget.selectedValue) * _count;
                                } else {
                                  _historyValue = _targetValue;
                                }
                              });

                              var _result =
                                  await FirestoreFunctions.updateDataRecord(
                                      newData, widget.pageType);
                            },
                            child: Text('Kaydet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 46, 2, 100))),
                          ),
                          GestureDetector(
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                setState(() {
                                  _count += 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Bugünün Listesi",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      _history.length > 0
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: _history
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                        255, 76, 0, 255)
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              title: item['count'] > 1
                                                  ? Container(
                                                      child: Text(item['count']
                                                              .toString() +
                                                          "x " +
                                                          item['type'] +
                                                          " - " +
                                                          item['amount']
                                                              .toString() +
                                                          item['unit']),
                                                    )
                                                  : Container(
                                                      child: Text(item['type'] +
                                                          " - " +
                                                          item['amount']
                                                              .toString() +
                                                          item['unit']),
                                                    ),
                                              subtitle: Text(
                                                "${item['date'].hour.toString()} : ${item['date'].minute.toString()} - ${item['date'].day.toString()}.${item['date'].month.toString()}.${item['date'].year.toString()}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Bugün için hiç su girişiniz yok. Lütfen su iç.  🐳",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ),
                            )),
                      ElevatedButton(
                          onPressed: () {
                            // print(pastItems);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return WaterTrackingHistory(
                                pastItems: pastItems,
                                dailyPurpose: 2000,
                              );
                            }));
                          },
                          child: Icon(
                            Icons.history,
                            size: 25,
                            color: Color.fromARGB(255, 46, 2, 100),
                          ))
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              left: 5,
              top: 10,
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

class WaterTrackingHistory extends StatefulWidget {
  List pastItems;
  int dailyPurpose;

  WaterTrackingHistory({required this.pastItems, required this.dailyPurpose});

  @override
  _WaterTrackingHistoryState createState() => _WaterTrackingHistoryState();
}

class _WaterTrackingHistoryState extends State<WaterTrackingHistory> {
  // Liste elemanları ve hedef sayıları burada tanımlanacak
  List<String> entries = ['Su İçme', 'Egzersiz', 'Yeşil Çay', 'Meyve Suyu'];
  List<int> goals = [8, 5, 3, 2]; // Her bir aktivite için günlük hedefler
  late Map _gunlukListe = {};
  late Map _gunlukListeFinal = {};
  DateTime _dun = DateTime.now().add(Duration(days: -1));
  @override
  void initState() {
    super.initState();
    // print(widget.pastItems);
    for (var element in widget.pastItems) {
      // print(element['date'].toDate());
      var _tempTarih =
          "${element['date'].toDate().day}.${element['date'].toDate().month}.${element['date'].toDate().year}";
      if (_gunlukListe.containsKey(_tempTarih)) {
        _gunlukListe[_tempTarih] += element['amount'] * element['count'];
      } else {
        _gunlukListe[_tempTarih] = element['amount'] * element['count'];
      }
    }

    for (var i = 1; i < 30; i++) //30 gün geriye doğru yazıcaz
    {
      DateTime _dun = DateTime.now().add(Duration(days: -i));
      var _tempData = "${_dun.day}.${_dun.month}.${_dun.year}";
      if (_gunlukListe.containsKey(_tempData)) {
        _gunlukListeFinal[_tempData] =
            _gunlukListe[_tempData] / widget.dailyPurpose;
      } else {
        _gunlukListeFinal[_tempData] = 0.00;
      }
    }
    print(_gunlukListeFinal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Su Geçmişi'),
      ),
      body: ListView.builder(
        itemCount: _gunlukListeFinal.length,
        itemBuilder: (BuildContext context, int index) {
          String date = _gunlukListeFinal.keys.toList()[index];
          double value = _gunlukListeFinal.values.toList()[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date),
                  Text(
                    _gunlukListe[date] != null
                        ? _gunlukListe[date].toString() +
                            "/" +
                            widget.dailyPurpose.toString() +
                            " ml"
                        : "0" + "/" + widget.dailyPurpose.toString() + " ml",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
              subtitle: LinearProgressIndicator(
                value: value,
              ),
            ),
          );
        },
      ),
    );
  }
}
