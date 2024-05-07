import 'package:flutter/material.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/jsonFiles.dart';

void main() {
  runApp(IntroPage());
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
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
  bool _skipButtonControl = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
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
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
          Positioned(
            bottom: 96.0,
            left: 16.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _skipButtonControl = true;
                });

                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            bottom: 96.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                print(_pageController.page);
                setState(() {
                  _skipButtonControl = true;
                });
                if (_pageController.page == onboardingPages.length - 2) {
                  setState(() {
                    _skipButtonControl = false;
                  });
                }
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          _skipButtonControl
              ? Positioned(
                  bottom: 26.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _skipButtonControl = false;
                        });
                        _pageController.jumpToPage(5);
                      },
                      child: Text("Skip"),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    Color color = index == _currentPageIndex ? Colors.blue : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(Icons.fiber_manual_record, color: color),
    );
  }
}

final List onboardingPages = [
  OnboardingPage(
    title: 'Hoşgeldiniz',
    description:
        "HeyBaby, yapay zeka destekli bir bebek bakım uygulamasıdır. Hamilelik sürecinizden başlayarak çocuğunuzun gelişimi ve sizin sağlığınıza destek olacak birçok özellik sunmaktadır. Haydi, siz de bu benzersiz deneyimi keşfedin!",
    imagePath: 'assets/Bardak.png',
  ),
  OnboardingPage(
    title: 'Hamilelik Takibi',
    description:
        'Hamilelik takibi uygulamasıyla ilgili bilgiler burada yer alacak.',
    imagePath: 'assets/images/onboarding2.png',
  ),
  OnboardingPage(
    title: 'Su Takibi',
    description:
        'Su takibi yapabilme özelliği hakkında bilgiler burada yer alacak.',
    imagePath: 'assets/images/onboarding3.png',
  ),
  OnboardingPage(
    title: 'Makaleler',
    description: 'Makalelerle ilgili bilgiler burada yer alacak.',
    imagePath: 'assets/images/onboarding4.png',
  ),
  OnboardingPage(
    title: 'Başlayalım',
    description: 'Hazırsanız başlayalım',
    imagePath: 'assets/images/onboarding4.png',
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
  // Global değişken tanımı
  late List<dynamic> jsonList0 = [];
  bool emailValid = true;
  bool passwordValid = true;

  imageandInfoJsonFileLoad() async {
    jsonList0 = await JsonReader.readJson();
    setState(() {
      jsonList = jsonList0;
    });
    // print(jsonList);
  }

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
              ),
              obscureText: true,
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
            ElevatedButton(
              onPressed: () async {
                _showGuestLoginPopup(context);
                // var a = await _authService.anonymSignIn();
                // Burada giriş işlemlerini gerçekleştirebilirsiniz.
                // Örneğin, emailController.text ve passwordController.text'i kullanarak kontrol yapabilirsiniz.
                // Eğer giriş başarılıysa başka bir ekran açabilir veya işlemleri gerçekleştirebilirsiniz.
              },
              child: Text('Misafir olarak Gir'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Kayıt ekranına yönlendirme işlemi
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Hesabınız yok mu? Kayıt yapın'),
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
        title: Text('Misafir Olarak Giriş Yap'),
        content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Burada pop-up'ın genişliğini ekranın %80'i olarak ayarladık.
            height: MediaQuery.of(context).size.height *
                0.2, // Burada pop-up'ın yüksekliğini ekranın %50'si olarak ayarladık.

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
  late List<dynamic> jsonList0 = [];

  String _tahminiKilo = "";
  String _tahminiBoy = "";
  String _imageLink = "";
  String _gifLink = "";
  String _benzerlik = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 50), () {
      imageandInfoJsonFileLoad();
    });
  }

  imageandInfoJsonFileLoad() async {
    jsonList0 = await JsonReader.readJson();
    setState(() {
      jsonList = jsonList0;
    });
    // print(jsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: isPregnant ? Text('Hamileyim') : Text("Bebeğim var"),
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
                            'Yeni doğum modu henüz geliştirme adımındadır.')),
                  );
                }
              },
            ),
            Column(
              children: [
                isPregnant
                    ? Text('Son regl tarihi giriniz:')
                    : Text('Bebek doğum tarihini giriniz:'),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: lastPeriodDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != lastPeriodDate) {
                      setState(() {
                        lastPeriodDate = picked;
                      });
                    }
                  },
                  child: Text(
                    '${lastPeriodDate.day}/${lastPeriodDate.month}/${lastPeriodDate.year}',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
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
  DateTime lastPeriodDate = DateTime.now();
  AuthService _authService = AuthService();

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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: registerPasswordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            SizedBox(height: 24.0),
            SwitchListTile(
              title: isPregnant ? Text('Hamileyim') : Text("Bebeğim var"),
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
                        content:
                            Text('Yeni doğum modu henüz desteklenmemektedir.')),
                  );
                }
              },
            ),
            Column(
              children: [
                isPregnant
                    ? Text('Son regl tarihi giriniz:')
                    : Text('Bebek doğum tarihini giriniz:'),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: lastPeriodDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != lastPeriodDate) {
                      setState(() {
                        lastPeriodDate = picked;
                      });
                    }
                  },
                  child: Text(
                    '${lastPeriodDate.day}/${lastPeriodDate.month}/${lastPeriodDate.year}',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                var a = await _authService.createPerson(
                    registerEmailController.text,
                    registerPasswordController.text,
                    isPregnant,
                    lastPeriodDate,
                    registerUsernameController.text);
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
