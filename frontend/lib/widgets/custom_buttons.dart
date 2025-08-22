import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: color,
          backgroundColor: color,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
              ),
        ),
      );
    }
  }
}
