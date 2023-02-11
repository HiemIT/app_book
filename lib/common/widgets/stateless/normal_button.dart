import 'package:app_book/themes/app_style_text.dart';
import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const NormalButton({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.blue[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          title,
          style: AppStyleText.subtitle,
        ),
      ),
    );
  }
}
