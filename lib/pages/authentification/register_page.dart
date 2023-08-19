import 'package:organizare_timp/components/square_tile.dart';
import 'package:organizare_timp/components/textfields.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    if (passwordController.text != passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Parolele nu se potrivesc")));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signInGoogle() async {
    await AuthService().signInWithGoogle();
    if (context.mounted) Navigator.pop(context);
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

            // name textfield
            Textfields(
              controller: nameController,
              hintText: 'Nume',
              obscureText: false,
            ),
            const SizedBox(height: 10),

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
                // Navigator.pushNamed(context, '/initpage');
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
