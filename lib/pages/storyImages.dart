import 'dart:async';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  final List<String> storyImages;
  final int startingPage;

  StoryScreen({required this.storyImages, required this.startingPage});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _animationController;
  int _waitingTime =
      5; // Her bir fotoğrafın ekranda kalma süresi saniye cinsinden
  Timer? _timer;
  bool _isTouching = false;

  @override
  void initState() {
    // print("Baslangic story no: " + widget.startingPage.toString());
    super.initState();
    _pageController = PageController(initialPage: widget.startingPage);
    setState(() {
      _currentIndex = widget.startingPage;
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _waitingTime),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isTouching) {
        _nextImage();
        _animationController.reset();
        _animationController.forward();
      }
    });

    _animationController.forward();

    // Timer'ı başlat
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isTouching) {
        // print(_animationController.value);
      }
    });
  }

  void _nextImage() {
    if (_currentIndex < widget.storyImages.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Story Images
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                // Sağa doğru dokunma, önceki resme geç
                _previousImage();
              } else {
                // Sola doğru dokunma, sonraki resme geç
                _nextImage();
              }
            },
            onTapDown: (TapDownDetails details) {
              //ekranın sağına dokununca sonraki resme soluna dokununca önceki resme geçen kod, kapatıldı çünkü uzun basma ile sorun yaşanıyordu
              // double screenWidth = MediaQuery.of(context).size.width;
              // if (details.globalPosition.dx > screenWidth / 2) {
              //   // Sağ tarafa dokunma, sonraki resme geç
              //   _nextImage();
              // } else {
              //   // Sol tarafa dokunma, önceki resme geç
              //   _previousImage();
              // }
              //ekranın sağına dokununca sonraki resme soluna dokununca önceki resme geçen kod, kapatıldı çünkü uzun basma ile sorun yaşanıyordu
              setState(() {
                _isTouching = true;
              });
              _animationController.stop();
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                _isTouching = false;
              });
              _animationController.forward();
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.storyImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.storyImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          // Progress Bar
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: LinearProgressIndicator(
              value: _animationController.value,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          // Close Button
          Positioned(
            top: 40.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer?.cancel();

    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
