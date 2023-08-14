import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            const SizedBox(
              height: 25,
            ),
            //logo
            const Icon(
              Icons.calendar_month,
              size: 100,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Bine ati venit!',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Ai deja un cont? Foloseste autentificarea',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 25,
            ),

            Button(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              text: 'Autentificare',
            ),

            const SizedBox(
              height: 50,
            ),
            Text(
              'Pentru utilizatori noi, va puteti crea un cont nou chiar acum',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 25,
            ),
            Button(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              text: 'Inregistrare',
            ),
          ])))),
    );
  }
}
