import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/anasayfa.dart';
import 'package:heybaby/pages/authentication.dart';

class SpinningWheel extends StatelessWidget {
  final Map<String, dynamic>? initialItems;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;

  SpinningWheel({
    required this.initialItems,
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
            initialItems: initialItems,
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
  Map<String, dynamic>? initialItems;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;
  RotatingHalfWheel({
    required this.initialItems,
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

  @override
  void initState() {
    super.initState();

    if (widget.initialItems != null &&
        widget.initialItems!.containsKey('dataRecord') &&
        widget.initialItems!['dataRecord'] != null &&
        widget.initialItems!['dataRecord'].containsKey(widget.pageType)) {
      var historyData = widget.initialItems!['dataRecord'][widget.pageType];

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          backgroundColor:
                              Color.fromRGBO(0, 203, 255, 1).withOpacity(0.2),
                          color: Color.fromRGBO(0, 203, 255, 1),
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
                                          ? Color.fromARGB(100, 50, 173, 54)
                                          : Color.fromARGB(112, 234, 34, 20),
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
                          child: Text('Kaydet'),
                        ),
                        GestureDetector(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
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
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _history
                              .map(
                                (item) => ListTile(
                                    title: item['count'] > 1
                                        ? Text(item['count'].toString() +
                                            "x " +
                                            item['type'] +
                                            " - " +
                                            item['amount'].toString() +
                                            item['unit'])
                                        : Text(item['type'] +
                                            " - " +
                                            item['amount'].toString() +
                                            item['unit'])),
                              )
                              .toList(),
                        ),
                      ),
                    ),
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
    );
  }
}
