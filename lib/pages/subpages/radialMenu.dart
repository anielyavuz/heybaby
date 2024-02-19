import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadialMenu extends StatefulWidget {
  RadialMenu({Key? key}) : super(key: key); // Anahtar ekle

  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
        controller: controller, key: widget.key); // Anahtarı aktar
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}

class RadialAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  RadialAnimation({Key? key, required this.controller})
      : scale = Tween<double>(begin: 1.5, end: 0.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        translation = Tween<double>(begin: 0.0, end: 100.0)
            .animate(CurvedAnimation(parent: controller, curve: Curves.linear)),
        rotation = Tween<double>(begin: 0.0, end: 360.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.3, 0.9, curve: Curves.decelerate))),
        super(key: key);

  @override
  build(context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Transform.rotate(
              angle: radians(rotation.value),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildButton(0,
                      color: Colors.red, icon: FontAwesomeIcons.thumbtack),
                  _buildButton(45,
                      color: Colors.green, icon: FontAwesomeIcons.sprayCan),
                  _buildButton(90,
                      color: Colors.orange, icon: FontAwesomeIcons.fire),
                  _buildButton(135,
                      color: Colors.blue, icon: FontAwesomeIcons.kiwiBird),
                  _buildButton(180,
                      color: Colors.black, icon: FontAwesomeIcons.cat),
                  _buildButton(225,
                      color: Colors.indigo, icon: FontAwesomeIcons.paw),
                  _buildButton(270,
                      color: Colors.pink, icon: FontAwesomeIcons.bong),
                  _buildButton(315,
                      color: Colors.yellow, icon: FontAwesomeIcons.bolt),
                ],
              ));
        });
  }

  _buildButton(double angle, {required Color color, required IconData icon}) {
    final double rad = radians(angle);
    return Transform(
        transform: Matrix4.identity()
          ..translate(
              (translation.value) * cos(rad), (translation.value) * sin(rad)),
        child: FloatingActionButton(
            child: Icon(icon),
            backgroundColor: color,
            onPressed: () {
              if (controller.isDismissed) {
                _open();
              } else {
                _close();
              }
            },
            elevation: 0));
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }
}
