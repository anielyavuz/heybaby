import 'package:flutter/material.dart';
import 'package:heybaby/pages/storyImages.dart';

class AnaSayfa extends StatelessWidget {
  final List<String> storyImages;
  final Map<String, dynamic>? userData;

  const AnaSayfa({Key? key, this.userData, required this.storyImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Story Circles
        Container(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: storyImages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StoryScreen(storyImages: storyImages),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(storyImages[index]),
                  ),
                ),
              );
            },
          ),
        ),
        // Resim
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/Leonardo_Diffusion_XL_A_baby_cartoon_in_the_womb_make_its_age_2.jpg?alt=media&token=f1a7f0dc-b9b5-46e7-891f-ca4a76c78712',
            fit: BoxFit.cover,
          ),
        ),
        // Alıntılar Container'ı
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bebeğinizden Mesaj',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                """Merhaba Annecim!
4 aylık oldum ve seninle daha fazla bağ kuruyorum. Karnında sıcacık ve güvende olmak harika!""",
                style: TextStyle(fontSize: 15.0),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Aktiviteler Container'ı
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5.0),
                Text(
                  'Yaklaşan Aktiviteler',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Yürüyüş'),
                  subtitle: Text('23 Ocak 2024, 15:00'),
                ),
                ListTile(
                  title: Text('Kahve Buluşması'),
                  subtitle: Text('25 Ocak 2024, 18:30'),
                ),
                ListTile(
                  title: Text('Kitap Okuma'),
                  subtitle: Text('27 Ocak 2024, 20:00'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnaSayfa(
      storyImages: [
        // Story Images'larınızı ekleyin
      ],
    ),
  ));
}
