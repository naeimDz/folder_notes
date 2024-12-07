import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color? backgroundColor;

  const CustomFloatingActionButton({
    required this.onPressed,
    this.label = 'Add Word',
    this.icon = Icons.add,
    this.backgroundColor,
    super.key,
  });

  @override
  _CustomFloatingActionButtonState createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // Proper lifecycle management
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          _animationController
              .forward()
              .then((_) => _animationController.reverse());
          widget.onPressed(); // Call the provided callback
        },
        icon: Icon(widget.icon),
        label: Text(widget.label),
        elevation: 4,
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
