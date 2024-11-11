import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double expandedHeight;
  final String title;
  final Color? titleColor;
  final List<Color> gradientColors;
  final IconData? leadingIcon;
  final Function()? onLeadingIconPressed;
  final List<Widget> actions;

  const CustomSliverAppBar({
    super.key,
    this.expandedHeight = 140.0,
    required this.title,
    this.titleColor,
    this.gradientColors = const [Color(0xFFBBDEFB), Colors.white],
    this.leadingIcon,
    this.onLeadingIconPressed,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            color:
                titleColor ?? Theme.of(context).textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
      ),
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: Theme.of(context).iconTheme.color),
              onPressed: onLeadingIconPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
    );
  }
}
