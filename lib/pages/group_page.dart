import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            onPressed: () =>  Navigator.pushNamed(context, '/newgrouppage'),
            )
          ],
          
        ),
      // body: grouplist(),
    );
  }

  // Widget grouplist() {
  //   return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('groups').snapshots(),
  //     builder: (context, snapshot){
  //       if(snapshot.hasError) {
  //         return const Text('error');
  //       }
  //       if(snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text('loading...');
  //       }
  //       return ListView(
  //         children: snapshot.data!.docs.map<Widget>((doc) => groupitem(doc)).toList(),
  //       );
  //     }
  //   );
  // }
 
  // Widget groupitem(DocumentSnapshot documentSnapshot){
  //   Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

  //   if(_firebaseAuth.currentUser!.email == data['admin']) {
  //     return ListTile(
  //       title: Text(data['name']),
  //     );
  //   }
  //   else {
  //     return Container();
  //   }

  // }
}