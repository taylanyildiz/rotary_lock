import 'package:flutter/material.dart';
import '/src/rotary_phone.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(),
            RotaryPhone(
              radius: 150.0,
              onChanged: (number) {
                print("Selected Number $number");
              },
            ),
          ],
        ),
      ),
    );
  }
}
