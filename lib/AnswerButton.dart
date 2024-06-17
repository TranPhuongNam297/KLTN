import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback onPressed;
  final bool isSelected;

  AnswerButton({
    Key? key,
    required this.answerText,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 300,
            height: 65,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[200] : Colors.grey[350], // Change color based on isSelected
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(answerText, style: TextStyle(fontSize: 20, color: Colors.black)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
