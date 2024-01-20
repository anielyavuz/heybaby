import 'package:auto_size_text/auto_size_text.dart';
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
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Resim
                Image.network(
                  'https://placekitten.com/300/200',
                  fit: BoxFit.cover,
                ),
                // Alıntılar Container'ı
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        'Bebeğinizden Mesaj',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      AutoSizeText(
                        """Merhaba Annecim!
4 aylık oldum ve seninle daha fazla bağ kuruyorum. Karnında sıcacık ve güvende olmak harika!""",
                        style: TextStyle(fontSize: 20.0),
                        maxLines: 3, // Maksimum satır sayısı
                        overflow:
                            TextOverflow.ellipsis, // Fazla metni gösterme şekli
                      ),
                    ],
                  ),
                ),
                // Aktiviteler Container'ı
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 5.0),
                        Text(
                          'Yakındaki Aktiviteler',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3.0),
                        // Yakındaki aktivitelerin listesi
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
            ),
          ),
        ),
      ],
    );
  }
}
