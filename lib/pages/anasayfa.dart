import 'package:flutter/material.dart';
import 'package:heybaby/pages/functions.dart';
import 'package:heybaby/pages/storyImages.dart';
import 'package:heybaby/pages/subpages/anaSayfaFoto.dart';

class AnaSayfa extends StatelessWidget {
  final List<String> storyImages;
  final Map<String, dynamic>? userData;

  const AnaSayfa({Key? key, this.userData, required this.storyImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Story Circles
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
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
                            builder: (context) => StoryScreen(
                              storyImages: storyImages,
                              startingPage: index,
                            ),
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
              SizedBox(height: 10),
              // Resim
              TrimesterProgressWidget(),
              SizedBox(height: 10),
              FunctionsWidget(
                onFunction1Pressed: () {
                  print("Test1");
                },
                onFunction2Pressed: () {
                  print("Test1");
                },
                onFunction3Pressed: () {
                  print("Test1");
                },
                onFunction4Pressed: () {
                  print("Test1");
                },
                function1Description: 'Su',
                function2Description: 'Kilo',
                function3Description: 'İlaç/Vitamin',
                function4Description: 'Aktivite',
              ),
            ],
          ),
        ),

        // SizedBox(height: 10),
        Positioned(
          bottom: 10,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpansionTile(
                  title: Text(
                    'Yaklaşan Aktiviteler',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: [
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
