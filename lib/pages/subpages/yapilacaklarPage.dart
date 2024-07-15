import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YapilacaklarPage extends StatefulWidget {
  Map<int, List<String>> hamilelikYapilacaklar;
  final Map<String, dynamic>? userData;

  YapilacaklarPage(
      {Key? key, required this.userData, required this.hamilelikYapilacaklar})
      : super(key: key);

  @override
  _YapilacaklarPageState createState() => _YapilacaklarPageState();
}

class _YapilacaklarPageState extends State<YapilacaklarPage> {
  List<String> oneriler = [];
  List yapilacaklar = [];
  int selectedWeek = 1;
  TextEditingController _textEditingController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    // print(widget.userData);

    setState(() {
      selectedWeek = (((DateTime.now().difference(
                  DateTime.parse(widget.userData?['sonAdetTarihi'])))
              .inDays) ~/
          7);
    });
    print("Buradaaaaa $selectedWeek");

    if (widget.userData != null &&
        widget.userData!['dataRecord'].containsKey('yapilacaklarData')) {
      setState(() {
        yapilacaklar = widget.userData!['dataRecord']['yapilacaklarData'];
        for (var _element in widget.hamilelikYapilacaklar[selectedWeek]!) {
          if (!yapilacaklar.contains(_element)) {
            oneriler.add(_element);
          }
        }
      });
    } else {
      setState(() {
        oneriler = [];

        print(yapilacaklar);
        for (var _element in widget.hamilelikYapilacaklar[selectedWeek]!) {
          if (!yapilacaklar.contains(_element)) {
            if (!yapilacaklar.contains("-" + _element)) {
              oneriler.add(_element);
            }
          }
        }
      });
      print('yapilacaklarData parametresi bulunamadı veya null.');
    }

    // print((((DateTime.now().difference(
    //                 DateTime.parse(widget.userData?['sonAdetTarihi'])))
    //             .inDays) ~/
    //         7)
    //     .toString());

    super.initState();
  }

  yapilacaklarEkleDB(index) async {
    setState(() {
      yapilacaklar.add(oneriler[index]);
      oneriler.removeAt(index);
    });

    var _result2 =
        await FirestoreFunctions.yapilacaklarDataRecord(yapilacaklar);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.yapilacaklarYapilacaklar),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.yapilacaklarOneriler),
              Tab(text: AppLocalizations.of(context)!.yapilacaklarYapilacaklar),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                DropdownButton<int>(
                  value: selectedWeek,
                  items: List.generate(42, (index) => index + 1).map((week) {
                    return DropdownMenuItem<int>(
                      value: week,
                      child:
                          Text('${AppLocalizations.of(context)!.hafta} $week'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      oneriler = [];
                      selectedWeek = value!;
                      print(yapilacaklar);
                      for (var _element
                          in widget.hamilelikYapilacaklar[selectedWeek]!) {
                        if (!yapilacaklar.contains(_element)) {
                          if (!yapilacaklar.contains("-" + _element)) {
                            oneriler.add(_element);
                          }
                        }
                      }
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: oneriler.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(oneriler[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            yapilacaklarEkleDB(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              "-"), // "-" sembolünü engeller
                        ],
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .yapilacaklarYapilacakEkle,
                          contentPadding: EdgeInsets.only(
                              left:
                                  10.0), // Sadece sol tarafa 10 birim boşluk ekler
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (_textEditingController.text.isNotEmpty) {
                            yapilacaklar.add(_textEditingController.text);

                            _textEditingController.clear();
                          }
                        });
                        var _result2 =
                            await FirestoreFunctions.yapilacaklarDataRecord(
                                yapilacaklar);
                      },
                      child: Text(AppLocalizations.of(context)!.takvimEkle),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: yapilacaklar.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(yapilacaklar[index]),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            yapilacaklar.removeAt(index);
                            oneriler = [];
                            for (var _element in widget
                                .hamilelikYapilacaklar[selectedWeek]!) {
                              if (!yapilacaklar.contains(_element)) {
                                oneriler.add(_element);
                              }
                            }
                          });
                        },
                        child: CheckboxListTile(
                          title: Text(
                            yapilacaklar[index],
                            style: TextStyle(
                              decoration: yapilacaklar[index].startsWith('-')
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          value: yapilacaklar[index].startsWith('-'),
                          onChanged: (checked) async {
                            print(yapilacaklar);
                            setState(() {
                              if (checked!) {
                                yapilacaklar[index] = "-${yapilacaklar[index]}";
                              } else {
                                yapilacaklar[index] =
                                    yapilacaklar[index].substring(1);
                              }
                            });

                            print(yapilacaklar);
                            var _result2 =
                                await FirestoreFunctions.yapilacaklarDataRecord(
                                    yapilacaklar);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
