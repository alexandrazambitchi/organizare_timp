import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/authentification/login_page.dart';
import 'package:organizare_timp/pages/authentification/register_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

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
            const Icon(Icons.calendar_month,
                size: 100, color: Color.fromARGB(255, 102, 178, 255)),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Bine ati venit!',
              style: TextStyle(color: Colors.grey[700], fontSize: 25.0),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Ai deja un cont? Foloseste autentificarea!',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 25,
            ),

            Button(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginPage(),
              )),
              text: 'Autentificare',
            ),

            const SizedBox(
              height: 50,
            ),
            Text(
              'Pentru utilizatori noi,\n va puteti crea un cont nou chiar acum!',
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            Button(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              )),
              text: 'Inregistrare',
            ),
          ])))),
    );
  }
}
