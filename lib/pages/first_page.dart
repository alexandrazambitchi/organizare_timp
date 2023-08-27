import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/authentification/login_page.dart';
import 'package:organizare_timp/pages/authentification/register_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 102, 178, 255),
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(),
              )),
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterPage(),
              )),
              text: 'Inregistrare',
            ),
          ])))),
    );
  }
}
