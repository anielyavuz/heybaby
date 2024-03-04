import 'package:flutter/material.dart';
import 'package:heybaby/functions/authFunctions.dart';

void main() {
  runApp(IntroPage());
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
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
                var a = await _authService.signIn(
                    emailController.text, passwordController.text);
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
  DateTime lastPeriodDate = DateTime.now();
  AuthService _authService = AuthService();

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
                        content:
                            Text('Yeni doğum modu henüz desteklenmemektedir.')),
                  );
                }
              },
            ),
            Column(
              children: [
                isPregnant
                    ? Text('Son adet tarihi giriniz:')
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
                  var a = await _authService.anonymSignIn(
                      isPregnant, lastPeriodDate);

                  Navigator.of(context).pop();
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
                    ? Text('Son adet tarihi giriniz:')
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
