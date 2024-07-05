import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/jsonFiles.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(IntroPage());
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length - 1,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return onboardingPages[index];
            },
          ),
          Positioned(
            bottom: 106.0,
            left: 50,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _currentPageIndex != 0
                    ? GestureDetector(
                        onTap: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "Geri",
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 0, 140),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : SizedBox(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _currentPageIndex == 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 111, 0, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          width: 50,
                          height: 10,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 203, 176, 238),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 15,
                            height: 10,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _currentPageIndex > 0 &&
                            _currentPageIndex < onboardingPages.length - 2
                        ? Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 111, 0, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 50,
                            height: 10,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 203, 176, 238),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              width: 15,
                              height: 10,
                            ),
                          ),
                  ),
                  _currentPageIndex >= onboardingPages.length - 2
                      ? Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 111, 0, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          width: 50,
                          height: 10,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 203, 176, 238),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 15,
                            height: 10,
                          ),
                        ),
                ]),
                _currentPageIndex < onboardingPages.length - 2
                    ? ElevatedButton(
                        onPressed: () {
                          print(_pageController.page);

                          if (_pageController.page ==
                              onboardingPages.length - 2) {}
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "İleri",
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 0, 140),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          // Positioned(
          //   bottom: 106.0,
          //   left: 16.0,
          //   child:

          //   GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         _skipButtonControl = true;
          //       });

          //       _pageController.previousPage(
          //         duration: Duration(milliseconds: 300),
          //         curve: Curves.easeInOut,
          //       );
          //     },
          //     child: Text(
          //       "Geri",
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 14.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),

          // ),
          // Positioned(
          //   bottom: 96.0,
          //   right: 16.0,
          //   child:

          //   ElevatedButton(
          //     onPressed: () {
          //       onPressed:
          //       () {
          //         print(_pageController.page);
          //         setState(() {
          //           _skipButtonControl = true;
          //         });
          //         if (_pageController.page == onboardingPages.length - 2) {
          //           setState(() {
          //             _skipButtonControl = false;
          //           });
          //         }
          //         _pageController.nextPage(
          //           duration: Duration(milliseconds: 300),
          //           curve: Curves.easeInOut,
          //         );
          //       };
          //     },
          //     child: Text("İleri"),
          //   ),
          // ),
          Positioned(
            bottom: 46.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: 200,
                height: 40,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text("HeyBaby hesabım var",
                        style: TextStyle(
                          color: Color.fromARGB(255, 92, 0, 197),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ),
          ),
          _currentPageIndex == onboardingPages.length - 2
              ? Center(
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        _showGuestLoginPopup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Giriş',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 92, 0, 197),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

Widget _loginPages(String header, String body, String lottie) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          textAlign: TextAlign.center,
          header,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          body,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          width: 300,
          height: 300,
          child: Lottie.asset(
              // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
              "assets/lottie/" + lottie + ".json"),
        ),
        // Container(
        //   height: 30,
        // )
      ],
    ),
  );
}

final List onboardingPages = [
  _loginPages(
      "Hoşgeldiniz",
      "HeyBaby, yapay zeka destekli bir bebek bakım uygulamasıdır. Hamilelik sürecinizden başlayarak çocuğunuzun gelişimi ve sizin sağlığınıza destek olacak birçok özellik sunmaktadır. Haydi, siz de bu benzersiz deneyimi keşfetmeye başlayın!",
      "welcomeMessage"),

  _loginPages(
      "Hamilelikten bebek gelişimine bilgi dolu bir yolculuk başlıyor!",
      'Heyecan verici bir yolculuğa hazır mısınız? Hamilelik sürecinizden başlayarak, bebeğinizin gelişimini yakından takip edin ve kendiniz hakkında yeni şeyler keşfedin! Geniş bilgi havuzumuz sayesinde, her adımda güvende hissedeceksiniz. Haydi, keşfedin ve bilgi dolu bir deneyimin tadını çıkarın!',
      'doctorWelcome'),

  _loginPages(
      'Sağlık yolculuğunuz başlasın! Kişisel sağlık asistanınız burada!',
      "Yapay zeka destekli olarak size özel geliştirilen kişisel sağlık asistanınız HeyBaby AI ile aklınıza takılan veya öğrenmek istediğiniz tüm bilgiler her an yanınızda!",
      'robotWelcome'),

  _loginPages(
      "Bildirimler ile anı yakalayın!",
      'Günlük su alımınızı takip edin, anne ve bebeğinizin gelişimini izleyin, ilaçlarınızı düzenleyin ve haftalık planlarınızı oluşturun. Size özel tasarlanmış bir uygulama ile sağlıklı yaşamınızı şekillendirmenize yardımcı oluyoruz!',
      'welcomeNotification'),

  Stack(
    children: [
      _loginPages("O zaman yolculuğumuz başlasın. 😇", '', "letsGo"),
    ],
  ),
  LoginScreen()
  // Ekleyeceğiniz diğer sayfalar buraya eklenebilir
];

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 16.0),
          Image.asset(
            imagePath,
            height: 200,
            width: 200,
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  AuthService _authService = AuthService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<dynamic> jsonList = [];
  bool _obscureText = true;
  // Global değişken tanımı
  // late List<dynamic> jsonList0 = [];
  bool emailValid = true;
  bool passwordValid = true;

  // imageandInfoJsonFileLoad() async {
  //   jsonList0 = await JsonReader.readJson();
  //   setState(() {
  //     jsonList = jsonList0;
  //   });
  //   // print(jsonList);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kullanıcı adı alanı
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                // Hata varsa altını kırmızı çizgiyle vurgula
                errorText: emailValid ? null : 'E-posta alanı boş olamaz',
                // Eğer hata varsa kırmızı çerçeve ekle
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
// Şifre alanı
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                // Hata varsa altını kırmızı çizgiyle vurgula
                errorText: passwordValid ? null : 'Şifre alanı boş olamaz',
                // Eğer hata varsa kırmızı çerçeve ekle
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              obscureText: _obscureText,
            ),

            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                _showForgotPasswordDialog(context);
                // Burada parolayı unuttum işlemlerini gerçekleştirebilirsiniz.
                // Örneğin, kullanıcının e-postasına şifre sıfırlama bağlantısı gönderme işlemi yapabilirsiniz.
              },
              child: Text('Parolamı Unuttum'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text != "" &&
                    passwordController.text != "") {
                  var a = await _authService.signIn(
                      emailController.text, passwordController.text);
                  if (!a['status']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          a['value'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 126, 52, 253), // Snackbar arka plan rengi
                        duration:
                            Duration(seconds: 3), // Snackbar gösterim süresi
                        behavior:
                            SnackBarBehavior.floating, // Snackbar davranışı
                        shape: RoundedRectangleBorder(
                          // Snackbar şekli
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4, // Snackbar yükseltilmesi
                        margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                      ),
                    );
                  }
                } else if (emailController.text == "") {
                  setState(() {
                    emailValid = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kullanıcı adı alanı boş olamaz!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Color.fromARGB(
                          255, 126, 52, 253), // Snackbar arka plan rengi
                      duration:
                          Duration(seconds: 3), // Snackbar gösterim süresi
                      behavior: SnackBarBehavior.floating, // Snackbar davranışı
                      shape: RoundedRectangleBorder(
                        // Snackbar şekli
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4, // Snackbar yükseltilmesi
                      margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                    ),
                  );
                } else if (passwordController.text == "") {
                  setState(() {
                    passwordValid = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password alanı boş olamaz!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Color.fromARGB(
                          255, 126, 52, 253), // Snackbar arka plan rengi
                      duration:
                          Duration(seconds: 3), // Snackbar gösterim süresi
                      behavior: SnackBarBehavior.floating, // Snackbar davranışı
                      shape: RoundedRectangleBorder(
                        // Snackbar şekli
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4, // Snackbar yükseltilmesi
                      margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                    ),
                  );
                }

                // Burada giriş işlemlerini gerçekleştirebilirsiniz.
                // Örneğin, emailController.text ve passwordController.text'i kullanarak kontrol yapabilirsiniz.
                // Eğer giriş başarılıysa başka bir ekran açabilir veya işlemleri gerçekleştirebilirsiniz.
              },
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 12.0),
            // ElevatedButton(
            //   onPressed: () async {
            //     _showGuestLoginPopup(context);
            //     // var a = await _authService.anonymSignIn();
            //     // Burada giriş işlemlerini gerçekleştirebilirsiniz.
            //     // Örneğin, emailController.text ve passwordController.text'i kullanarak kontrol yapabilirsiniz.
            //     // Eğer giriş başarılıysa başka bir ekran açabilir veya işlemleri gerçekleştirebilirsiniz.
            //   },
            //   child: Text('Giriş Yap'),
            // ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                _showGuestLoginPopup(context);
              },
              child: Text('Hesabınız yok mu? İlk defa giriş yapın.'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showGuestLoginPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20), // Burada pop-up'ın köşelerini yuvarlak yapabiliriz.
        ),
        title: Text('Giriş Yap',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 26.0,
              fontWeight: FontWeight.normal,
            )),
        content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Burada pop-up'ın genişliğini ekranın %80'i olarak ayarladık.
            height: MediaQuery.of(context).size.height *
                0.3, // Burada pop-up'ın yüksekliğini ekranın %50'si olarak ayarladık.

            child: GuestLoginContent()),
      );
    },
  );
}

class GuestLoginContent extends StatefulWidget {
  @override
  _GuestLoginContentState createState() => _GuestLoginContentState();
}

class _GuestLoginContentState extends State<GuestLoginContent> {
  String _dogumOnceSonra = "Once";
  bool isPregnant = true;
  DateTime lastPeriodDate = DateTime.now().add(Duration(days: -30));
  AuthService _authService = AuthService();
  late List<dynamic> jsonList = [];
  // Global değişken tanımı
  // late List<dynamic> jsonList0 = [];

  String _tahminiKilo = "";
  String _tahminiBoy = "";
  String _imageLink = "";
  String _gifLink = "";
  String _benzerlik = "";

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 50), () {
    //   imageandInfoJsonFileLoad();
    // });
  }

  // imageandInfoJsonFileLoad() async {
  //   jsonList0 = await JsonReader.readJson();
  //   setState(() {
  //     jsonList = jsonList0;
  //   });
  //   // print(jsonList);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            SwitchListTile(
              title: isPregnant
                  ? Text('Hamileyim',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ))
                  : Text("Bebeğim var"),
              value: isPregnant,
              onChanged: (bool value) async {
                setState(() {
                  _dogumOnceSonra = "Once";
                  isPregnant = value;
                });

                if (!value) {
                  await Future.delayed(Duration(milliseconds: 100));
                  setState(() {
                    isPregnant = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Doğum sonrası modu henüz geliştirme adımındadır.')),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  isPregnant
                      ? Text('Son regl tarihiniz:',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                          ))
                      : Text('Bebeğiniz doğum günü:',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                          )),
                  SizedBox(height: 55),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    initialDateTime: lastPeriodDate,
                                    minimumDate: DateTime.now()
                                        .subtract(Duration(days: 10 * 30)),
                                    maximumDate: DateTime.now(),
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (DateTime newDate) {
                                      setState(() {
                                        lastPeriodDate = newDate;
                                      });
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Done'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      DateFormat.yMMMd(
                              Localizations.localeOf(context).toString())
                          .format(lastPeriodDate),
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 19.0,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.0),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  var a = await _authService.anonymSignIn(
                      isPregnant, lastPeriodDate);
                },
                child: Text('Giriş Yap'))
          ],
        );
      }),
    );
  }
}

void _showForgotPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Şifremi Unuttum'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'E-posta'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Burada şifre sıfırlama bağlantısı gönderme işlemlerini gerçekleştirebilirsiniz.
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //         'Şifre sıfırlama bağlantısı mailinize gönderildi.'),
                    //     duration: Duration(seconds: 3),
                    //   ),
                    // );
                    Navigator.pop(context); // Dialog kapatılır
                  },
                  child: Text('Gönder'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String? lastPeriodDate;
  final String? dogumOnceSonra;
  RegisterScreen(
      {Key? key,
      required this.userData,
      required this.lastPeriodDate,
      required this.dogumOnceSonra})
      : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController registerUsernameController =
      TextEditingController();

  bool isPregnant = true;
  String _dogumOnceSonra = "Once";
  String lastPeriodDate = "";
  AuthService _authService = AuthService();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dogumOnceSonra = widget.dogumOnceSonra!;
      lastPeriodDate = widget.lastPeriodDate!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: registerEmailController,
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: registerUsernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: registerPasswordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              obscureText: _obscureText,
            ),
            SizedBox(height: 24.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                var a = await _authService.createPerson(
                    widget.userData?['id'],
                    registerEmailController.text,
                    registerPasswordController.text,
                    isPregnant,
                    lastPeriodDate,
                    registerUsernameController.text,
                    widget.userData?['bildirimler'],
                    widget.userData?['dogumOnceSonra'],
                    widget.userData?['createTime'],
                    widget.userData?['dataRecord']);
                if (a['status']) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) {
                    return CheckAuth();
                  }));
                }
                // Burada kayıt işlemlerini gerçekleştirebilirsiniz.
                // Örneğin, registerEmailController.text ve registerPasswordController.text'i kullanarak yeni bir kullanıcı kaydedebilirsiniz.
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
