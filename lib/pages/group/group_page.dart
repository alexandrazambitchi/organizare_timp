import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        actions: [
            IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () =>  Navigator.pushNamed(context, '/creategroup'),
            )
          ],
        ),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              onTap: () {
                                Navigator.pushNamed(context, '/creategroup');
                              },
                              text: "Creaza grup"
                              ),
                            const SizedBox(
                              width: 25,
                            ),
                            Button(
                              onTap: () {
                                Navigator.pushNamed(context, '/joingroup'
                                );
                              },
                              text: "Alatura-te unui grup")
                          ],
                        ),

                      ]
                  )
              )
          )
      )
      // grouplist(),
    );
  }

}