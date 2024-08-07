import 'package:flutter/material.dart';
class StarButton extends StatefulWidget {
  final String Currentindex;
  const StarButton({super.key, required this.Currentindex});
  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isStarred ? Icons.star : Icons.star_border,
        color: isStarred ? Colors.yellow : null,
      ),
      onPressed: () {
        setState(() {
          isStarred = !isStarred;
        });
      },
    );
  }
}
