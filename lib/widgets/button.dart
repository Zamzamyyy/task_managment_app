

import 'package:flutter/cupertino.dart';

import '../themes/themes.dart';
import '../themes/themes.dart' as Colors;

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.label, required this.onTap});

  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryClr,
          ),
          child: Center(
            child: Text(label,
              style: TextStyle(
                color: Colors.white,
              ),

            ),
          ),
        ) );
  }
}
