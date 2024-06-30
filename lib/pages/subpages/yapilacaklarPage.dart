import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';

class YapilacaklarPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const YapilacaklarPage({Key? key, this.userData}) : super(key: key);

  @override
  _YapilacaklarPageState createState() => _YapilacaklarPageState();
}

class _YapilacaklarPageState extends State<YapilacaklarPage> {
  List<String> oneriler = [];
  List yapilacaklar = [];
  int selectedWeek = 1;
  TextEditingController _textEditingController = TextEditingController();
  bool _isButtonEnabled = false;

  Map<int, List<String>> hamilelikYapilacaklar = {
    1: [
      "Hamilelik günlüğüne başla ve duygularını kaydet",
      "Hamilelikle ilgili kitaplar oku ve bilgi edin",
      "Dengeli beslenmeye özen göster",
      "Günlük yürüyüşler yaparak aktif kal",
      "Anne-bebek yoga dersine katıl"
    ],
    2: [
      "Doktor randevusuna git ve ultrason yaptır",
      "Kalsiyum ve demir açısından zengin besinler tüket",
      "Yumuşak müzikler dinleyerek rahatla",
      "Masaj yaptırarak rahatla",
      "Yeni anne hakkında bloglar ve makaleler oku"
    ],
    3: [
      "Bebeğin ilk hediyelerini satın al",
      "Evinde bebek odası için plan yap",
      "Hamilelik cilt bakım ürünleri al",
      "Hafif yoga ve nefes egzersizleri yap",
      "Yüzme havuzunda gevşeme seansı al"
    ],
    4: [
      "Bebek bakım kursuna katıl",
      "Doğum planı oluştur",
      "Sağlıklı atıştırmalıklar hazırla",
      "Meditasyon yaparak rahatla",
      "Hamilelik resimleri çek ve hatıra oluştur"
    ],
    5: [
      "Bebeğin ilk giysilerini alışveriş yap",
      "Eğlenceli bir hamilelik fotosu çekimi ayarla",
      "Eşinle birlikte romantik bir kaçamak yap",
      "Sağlıklı smoothie tarifleri dene",
      "Hamilelik egzersiz videoları izle"
    ],
    6: [
      "Bebek odasını dekore etmeye başla",
      "Düzenli olarak pelvik taban egzersizleri yap",
      "Hamilelik fotoğraf albümü oluştur",
      "Rahatlatıcı hamilelik masajı al",
      "Yeni annelerle tanışmak için gruplara katıl"
    ],
    7: [
      "Doğum ekipmanları için alışveriş yap",
      "Yüksek protein içeren diyeti benimse",
      "Yüzme veya su aerobiği yaparak rahatla",
      "Doğum partnerinle doğum planını gözden geçir",
      "Anne olmanın getirdiği değişiklikleri kabul etmeye hazırlan"
    ],
    8: [
      "Doktor randevusuna git ve doğum planını tartış",
      "Pilates veya doğum topu egzersizleri yap",
      "Gebelikte cilt bakım rutini oluştur",
      "Hamilelik günce yazarak duygularını ifade et",
      "Ebeveynlikle ilgili kitaplar oku ve bilgi edin"
    ],
    9: [
      "Bebeğin ilk ayları için alışveriş yap",
      "Rahat uyumanı sağlayacak pozisyonları dene",
      "Hamilelik yoga dersine katıl",
      "Anne sütü sağma yöntemlerini öğren",
      "Bebeğin ilk aşıları hakkında bilgi edin"
    ],
    10: [
      "Hamilelik egzersiz programını sürdür",
      "Gebelik modasına uygun kıyafetler al",
      "Doğum için hazırlık kursuna katıl",
      "Hamilelikte doğal doğum yöntemlerini araştır",
      "Bebekle iletişim kurmayı öğren"
    ],
    11: [
      "Hamilelik masajı yaptır",
      "Hafif egzersizlerle aktiviteyi sürdür",
      "Doğum ekipmanlarını düzenle",
      "Bebeğin odasını hazırla",
      "Sakinleştirici doğum müzikleri dinle"
    ],
    12: [
      "Rahat giysiler al",
      "Doğum egzersizleri yap",
      "Masaj yaptırarak rahatla",
      "Bebeğin adını seç",
      "Hamilelik günlüğüne mektup yaz"
    ],
    13: [
      "Bebeğin bakımı için alışveriş yap",
      "Doğum öncesi kursları araştır",
      "Sağlıklı beslenmeye devam et",
      "Yumuşak ve destekleyici yatak al",
      "Dinlenmek için rahat bir köşe oluştur"
    ],
    14: [
      "Doğum sonrası planını yap",
      "Bebeğin aşı takvimini oluştur",
      "Rahatlatıcı banyo yap",
      "Doğum öncesi yoga yap",
      "Hamilelikte giymek için rahat ve emzirme dostu kıyafetler al"
    ],
    15: [
      "Doğum öncesi masajı yaptır",
      "Doğum için meditasyon uygula",
      "Doğum hikayesi yaz",
      "Bebeğin güvenliği için evi düzenle",
      "Anne sütü pompası ve diğer bebek ürünlerini hazırla"
    ],
    16: [
      "Doğum sonrası kilo kaybı planı yap",
      "Bebeğin uyku düzenini oluştur",
      "Bebek bakımı kurslarına katıl",
      "Doğum sonrası yoga dersine katıl",
      "Doğum öncesi fotoğraf çekimi ayarla"
    ],
    17: [
      "Doğum öncesi arkadaşlarla buluş",
      "Doğum öncesi masaj yaptır",
      "Hamilelikte doğal doğum yöntemlerini öğren",
      "Doğum sonrası depresyon belirtilerini öğren",
      "Bebeğinizi emzirmeye hazırlık yapın"
    ],
    18: [
      "Bebeğin uyku düzenini oluştur",
      "Doğum sonrası egzersiz programı oluştur",
      "Doğum sonrası yardım için destek sistemini oluştur",
      "Emzirme desteği al",
      "Doğum öncesi masajı yaptır"
    ],
    19: [
      "Bebeğin ilk haftalarında yapılacaklar listesi oluştur",
      "Bebeğin ilk günlük alışkanlıklarını öğren",
      "Anne sütü arttırmak için diyeti düzenle",
      "Doğum sonrası yoga derslerine katıl",
      "Bebeğin uyku düzenini oluştur"
    ],
    20: [
      "Bebeğin ilerideki eğitim planını düşün",
      "Bebeğin sağlık sigortasını düzenle",
      "Bebeğin uyku düzenini oluştur",
      "Doğum sonrası egzersiz programına devam et",
      "Bebeğin diş etleri için masaj yap"
    ],
    21: [
      "Bebeğin gelişimini takip et",
      "Anne sütünü artırmak için beslenme planını düzenle",
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin sağlık sigortasını düzenle",
      "Bebeğin aşılarını planla"
    ],
    22: [
      "Bebeğin ilk dişlerinin çıkışını bekleyin",
      "Bebeğin uyku düzenini oluştur",
      "Anne sütü arttırmak için diyeti düzenle",
      "Bebeğin uygun oyun ve etkinliklerini araştır",
      "Bebeğin gelişimini takip et"
    ],
    23: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin beslenme alışkanlıklarını gözlemle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin güvenliği için evi düzenle",
      "Anne-bebek yoga derslerine devam et"
    ],
    24: [
      "Bebeğin diş çıkarma sürecini yönet",
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin emeklemeye başladığı zamanı bekleyin",
      "Bebeğin diş fırçalama alışkanlığını geliştir"
    ],
    25: [
      "Bebeğin dil gelişimini destekle",
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin ilgi alanlarını keşfet",
      "Bebeğin sağlık kontrolünü yap"
    ],
    26: [
      "Bebeğin dil gelişimini destekle",
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin yeni tatlar denemesine izin ver",
      "Bebeğin duygusal gelişimini destekle"
    ],
    27: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin duygusal gelişimini destekle",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap"
    ],
    28: [
      "Bebeğin dil gelişimini destekle",
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin ilk yürüyüş denemesine hazır ol"
    ],
    29: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun zamanını planla"
    ],
    30: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sosyal etkileşimini teşvik et"
    ],
    31: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    32: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    33: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    34: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    35: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    36: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    37: [
      "Bebeğin uyku düzenini oluştur",
      "Bebeğin gelişimini takip et",
      "Bebeğin dil gelişimini destekle",
      "Bebeğin sağlık kontrolünü yap",
      "Bebeğin oyun ve etkinliklerini planla"
    ],
    38: [
      "Bebeğin doğumuna hazır ol",
      "Doktor randevusuna git ve doğum sürecini değerlendir",
      "Doğum ekipmanlarını hazırla",
      "Doğum sonrası planını yap",
      "Son hamilelik masajını yaptır"
    ],
    39: [
      "Bebeğin doğumunu beklemeye başla",
      "Doğum için hastane çantasını hazırla",
      "Doğum sonrası destek sistemini organize et",
      "Doğum öncesi son egzersiz seansını yap",
      "Doğum sonrası planını gözden geçir"
    ],
    40: [
      "Doğumun belirtilerini izle",
      "Sakinleştirici aktivitelerle stresi azalt",
      "Doğum partnerinle son hazırlıkları yap",
      "Rahat ve destekleyici kıyafetler giy",
      "Doğum sonrası dinlenme planını hazırla"
    ],
    41: [
      "Doğum için son hazırlıkları tamamla",
      "Doktorun talimatlarına tam olarak uyun",
      "Sakinleştirici aktivitelerle gevşemeye devam et",
      "Doğum sonrası iletişim planını oluştur",
      "Doğum partnerine ihtiyaç duyduğunuzu belirt"
    ],
    42: [
      "Doğumun başladığını belirtileri izle",
      "Hastaneye git ve doğum sürecini başlat",
      "Doğum sürecinde sakin ve pozitif kal",
      "Doğum sonrası dinlenme planını uygula",
      "Yeni bebeğinle tanışmak için heyecanlan"
    ],
  };

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
        for (var _element in hamilelikYapilacaklar[selectedWeek]!) {
          if (!yapilacaklar.contains(_element)) {
            oneriler.add(_element);
          }
        }
      });
    } else {
      setState(() {
        oneriler = [];

        print(yapilacaklar);
        for (var _element in hamilelikYapilacaklar[selectedWeek]!) {
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
          title: Text('Yapılacaklar'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Öneriler'),
              Tab(text: 'Yapılacaklar'),
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
                      child: Text('Hafta $week'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      oneriler = [];
                      selectedWeek = value!;
                      print(yapilacaklar);
                      for (var _element
                          in hamilelikYapilacaklar[selectedWeek]!) {
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
                          hintText: 'Yapılacak Ekle',
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
                      child: Text('Ekle'),
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
                            for (var _element
                                in hamilelikYapilacaklar[selectedWeek]!) {
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
