import 'package:organizare_timp/components/square_tile.dart';
import 'package:organizare_timp/components/textfields.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == passwordConfirmController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        //show message passwords don't match
        wrongMessage("Passwords don't match!");
      }

      Navigator.pop(context);
      Navigator.pushNamed(context, '/homepage');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrongMessage(e.code);
    }
  }

  void signInGoogle() async {
    await AuthService().signInWithGoogle();
    Navigator.pushNamed(context, '/homepage');
  }

  void wrongMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepOrange,
            title: Center(
                child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            )),
          );
        });
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

            const SizedBox(height: 10),
            // password textfield
            Textfields(
              controller: passwordConfirmController,
              hintText: 'Confirmare parola',
              obscureText: true,
            ),

            const SizedBox(height: 25),

            Button(
              text: "Sign up",
              onTap: signUserUp,
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
                      'Or continue with',
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
                Navigator.pushNamed(context, '/initpage');
              },
              text: 'Inapoi la pagina principala',
            ),
          ]),
        ),
      )),
    );
  }
}
