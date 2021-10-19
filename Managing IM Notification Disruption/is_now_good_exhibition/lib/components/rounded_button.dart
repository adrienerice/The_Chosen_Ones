import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  late final String text;
  late final Color color;
  late final void Function()? onPressed;

  RoundedButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth: 200.0,
          height: 52.0,
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, //Colors.brown[900],
            ),
          ),
        ),
      ),
    );
  }
}
