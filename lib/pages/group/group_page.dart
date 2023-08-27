import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/group/group_edit_page.dart';
import 'package:organizare_timp/pages/group/group_join_page.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/pages/home_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(),
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GroupEditPage(),
            )),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 150,
            ),
            Button(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GroupEditPage()));
                },
                text: "Creaza grup"),
            Button(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const JoinGroupPage()));
                },
                text: "Alatura-te unui grup"),
            Button(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GroupListPage()));
                },
                text: "Lista grupurilor tale"),
            const SizedBox(
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}
