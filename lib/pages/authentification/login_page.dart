import 'package:organizare_timp/components/square_tile.dart';
import 'package:organizare_timp/components/textfields.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  //final Function()? onTap;  required this.onTap
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (context.mounted) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signInGoogle() async {
    await AuthService().signInWithGoogle();
    if (context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            //logo
            const Icon(
              Icons.calendar_month,
              size: 100,
            ),

            const SizedBox(
              height: 50,
            ),

            Text(
              'Bine ati revenit!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // username textfield
            Textfields(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            Textfields(
              controller: passwordController,
              hintText: 'Parola',
              obscureText: true,
            ),

            const SizedBox(height: 25),

            Button(
              text: "Autentificare",
              onTap: signUserIn,
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Sau continua cu',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
                const SizedBox(
                  width: 25,
                ),
                SquareTile(
                  imagePath: 'lib/images/google.png',
                  onTap: signInGoogle,
                ),
              ],
            ),

            const SizedBox(height: 25),

            Button(
              onTap: () {
                Navigator.pop(context);
              },
              text: 'Inapoi la pagina principala',
            ),
          ]),
        ),
      )),
    );
  }
}
