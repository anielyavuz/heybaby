import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/jsonFiles.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(IntroPage());
}

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
    if (AppLocalizations.of(context)!.language == "English") {
      setState(() {
        onboardingPages[0] = _loginPages(
            "Welcome",
            "HeyBaby is a baby care app powered by artificial intelligence. It offers many features to support your child's development and your health, starting from your pregnancy. Let's start exploring this unique experience!",
            "welcomeMessage");

        onboardingPages[1] = _loginPages(
            "A journey full of information from pregnancy to baby development begins!",
            "Are you ready for an exciting journey? Starting from your pregnancy, follow your baby's development closely and discover new things about yourself! Thanks to our vast pool of knowledge, you will feel safe every step of the way. Come on, explore and enjoy a knowledge-filled experience!",
            'doctorWelcome');
        onboardingPages[2] = _loginPages(
            'Let your health journey begin! Your personal health assistant is here!',
            "With HeyBaby AI, your personal health assistant specially developed for you with artificial intelligence support, all the information you have in mind or want to learn is always with you!",
            'robotWelcome');
        onboardingPages[3] = _loginPages(
            "Stay in the moment with notifications!",
            "Track your daily water intake, monitor your mother and baby's development, organize your medications and create your weekly plans. We help you shape your healthy life with an app designed just for you!",
            'welcomeNotification');
        onboardingPages[4] = Stack(
          children: [
            _loginPages("Then let our journey begin 😇", '', "letsGo"),
          ],
        );
      });
    }
    print(AppLocalizations.of(context)!.language);
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
                          AppLocalizations.of(context)!.hosgeldinizGeri,
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
                          AppLocalizations.of(context)!.hosgeldinizIleri,
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
                    child: Text(
                        AppLocalizations.of(context)!
                            .hosgeldinizHeyBabyHesabimvar,
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
                        _showGuestLoginModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.hosgeldinizGiris,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            textAlign: TextAlign.center,
            header,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
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

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    print("ASdasdasd");
    Future.delayed(const Duration(milliseconds: 500), () {
      print(AppLocalizations.of(context)!.language);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context)!.language);
    return onboardingPages.length > 0
        ? Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Image.asset(
                  widget.imagePath,
                  height: 200,
                  width: 200,
                ),
              ],
            ),
          )
        : CircularProgressIndicator();
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
        title: Text(AppLocalizations.of(context)!.hosgeldinizGirisYap),
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
                labelText: AppLocalizations.of(context)!.hosgeldinizEposta,
                // Hata varsa altını kırmızı çizgiyle vurgula
                errorText: emailValid
                    ? null
                    : AppLocalizations.of(context)!.hosgeldinizUyari1,
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
                labelText: AppLocalizations.of(context)!.hosgeldinizSifre,
                // Hata varsa altını kırmızı çizgiyle vurgula
                errorText: passwordValid
                    ? null
                    : AppLocalizations.of(context)!.hosgeldinizUyari2,
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
              child:
                  Text(AppLocalizations.of(context)!.hosgeldinizParolaUnuttum),
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
                        AppLocalizations.of(context)!.hosgeldinizUyari1,
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
                        AppLocalizations.of(context)!.hosgeldinizUyari2,
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
              child: Text(AppLocalizations.of(context)!.hosgeldinizGirisYap),
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
                _showGuestLoginModal(context);
              },
              child:
                  Text(AppLocalizations.of(context)!.hosgeldinizHesabinizYokMu),
            ),
          ],
        ),
      ),
    );
  }
}

void _showGuestLoginModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return GuestLoginModalContent();
    },
  );
}

class GuestLoginModalContent extends StatefulWidget {
  @override
  _GuestLoginModalContentState createState() => _GuestLoginModalContentState();
}

class _GuestLoginModalContentState extends State<GuestLoginModalContent>
    with WidgetsBindingObserver {
  double heightFactor = 0.4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      heightFactor = bottomInset > 0 ? 0.8 : 0.4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.hosgeldinizGirisYap,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 26.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GuestLoginContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class GuestLoginContent extends StatefulWidget {
  @override
  _GuestLoginContentState createState() => _GuestLoginContentState();
}

class _GuestLoginContentState extends State<GuestLoginContent> {
  final TextEditingController _referansController = TextEditingController();

  String _dogumOnceSonra = "Once";
  bool isPregnant = true;
  DateTime lastPeriodDate = DateTime.now().add(Duration(days: -30));
  AuthService _authService = AuthService();
  late List<dynamic> jsonList = [];
  String _tahminiKilo = "";
  String _tahminiBoy = "";
  String _imageLink = "";
  String _gifLink = "";
  String _benzerlik = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          SwitchListTile(
            title: isPregnant
                ? Text(AppLocalizations.of(context)!.hosgeldinizHamileyim,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                    ))
                : Text(AppLocalizations.of(context)!.hosgeldinizBebegimVar),
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
                      content: Text(AppLocalizations.of(context)!
                          .hosgeldinizBebekDogumModu)),
                );
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isPregnant
                    ? Text(AppLocalizations.of(context)!.hesapSonReglTarihi,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ))
                    : Text(
                        AppLocalizations.of(context)!.hosgeldinizBebekDogumGunu,
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
                              MediaQuery.of(context).copyWith().size.height / 3,
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
                    DateFormat.yMMMd(Localizations.localeOf(context).toString())
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
          SizedBox(height: 16.0),
          TextField(
            controller: _referansController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.hosgeldinizReferansKod,
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var a = await _authService.anonymSignIn(
                    isPregnant, lastPeriodDate, _referansController.text);
              },
              child: Text(AppLocalizations.of(context)!.hosgelnizGirisYap))
        ],
      ),
    );
  }
}

void _showForgotPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(AppLocalizations.of(context)!.hosgeldinizParolaUnuttum),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.hosgeldinizEposta),
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
                  child: Text(AppLocalizations.of(context)!.hosgeldinizGonder),
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
