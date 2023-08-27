import 'package:flutter/material.dart';
import 'package:organizare_timp/model/group.dart';
import 'package:organizare_timp/pages/group/group_page.dart';
import 'package:organizare_timp/pages/group/group_view_page.dart';

import '../../components/button.dart';
import '../../services/group_service.dart';

class JoinGroupPage extends StatefulWidget {
  final String? objId;

  const JoinGroupPage({Key? key, this.objId}) : super(key: key);

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final groupIdController = TextEditingController();

  void joinGroup() async {
    final GroupService groupService = GroupService();

    groupService.joinGroup(groupIdController.text);

    Group joinedGroup = await groupService.findGroup(groupIdController.text);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => GroupViewingPage(
              group: joinedGroup,
              objId: groupIdController.text,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const GroupPage(),
            )),
          ),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: groupIdController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.group),
                        hintText: "Codul de acces pe grup"),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Button(
                    text: "Intra in grup",
                    onTap: joinGroup,
                  )
                ]))
          ],
        ));
  }
}
