import 'package:flutter/material.dart';

class FunctionsWidget extends StatelessWidget {
  final VoidCallback onFunction1Pressed;
  final VoidCallback onFunction2Pressed;
  final VoidCallback onFunction3Pressed;
  final VoidCallback onFunction4Pressed;

  final String function1Description;
  final String function2Description;
  final String function3Description;
  final String function4Description;

  const FunctionsWidget({
    Key? key,
    required this.onFunction1Pressed,
    required this.onFunction2Pressed,
    required this.onFunction3Pressed,
    required this.onFunction4Pressed,
    required this.function1Description,
    required this.function2Description,
    required this.function3Description,
    required this.function4Description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFunctionButton(
          onPressed: onFunction1Pressed,
          icon: Icons.water_drop,
          description: function1Description,
        ),
        _buildFunctionButton(
          onPressed: onFunction2Pressed,
          icon: Icons.scale,
          description: function2Description,
        ),
        _buildFunctionButton(
          onPressed: onFunction3Pressed,
          icon: Icons.monitor_heart,
          description: function3Description,
        ),
        _buildFunctionButton(
          onPressed: onFunction4Pressed,
          icon: Icons.pending_actions,
          description: function4Description,
        ),
      ],
    );
  }

  Widget _buildFunctionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String description,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          child: Icon(icon),
        ),
        SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
